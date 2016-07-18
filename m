Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 574617CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 13:55:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1623AC004
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 11:55:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Osj6Ee6I3pQcVZ29 for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 11:55:03 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 86BE6142E
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 13:55:02 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Metadata corruption detected at xfs_agf block
References: <20160718112544.GF27776@eguan.usersys.redhat.com>
Message-ID: <f7fba852-d5a5-1775-f41e-f74c411daa4f@sandeen.net>
Date: Mon, 18 Jul 2016 11:55:01 -0700
MIME-Version: 1.0
In-Reply-To: <20160718112544.GF27776@eguan.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 7/18/16 4:25 AM, Eryu Guan wrote:
> Hi,
> 
> I hit metadata corruption reported by xfs_repair after running fsstress
> on the test XFS.
> 
> # xfs_repair -n /dev/mapper/testvg-testlv
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> Metadata corruption detected at xfs_agf block 0x59fa001/0x200
> flfirst 118 in agf 3 too large (max = 118)
          ^^^                           ^^^

FWIW, this confusing output was fixed by:

6aa32b4 xfs_repair: fix agf limit error messages

so today it would say:

flfirst 118 in agf 3 too large (max = 117)

> agf 118 freelist blocks bad, skipping freelist scan
> sb_fdblocks 15716842, counted 15716838
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 0
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> 
> Kernel is 4.7-rc7, xfsprogs is v4.3.0 (v4.5.0/v4.7-rc1 reported no
> corruption, I think that's because of commit 96f859d ("libxfs: pack the
> agfl header structure so XFS_AGFL_SIZE is correct"))

hm this does seem related.

> This is similar to this thread:
> 
> new fs, xfs_admin new label, metadata corruption detected
> http://oss.sgi.com/archives/xfs/2016-03/msg00297.html

That one did have a growfs step, which you don't have, right?

> which ended up a new patch in growfs code, commit ad747e3b2996 ("xfs:
> Don't wrap growfs AGFL indexes"), so I think I'd better report this
> similar issue anyway, though I'm not sure if it's really a bug.

Ok, interesting, I thought growfs was the only path to this.

/*
 * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
 * slots in the beginning of the block for a proper header with the
 * location information and CRC.
 */
#define XFS_AGFL_SIZE(mp) \
        (((mp)->m_sb.sb_sectsize - \
         (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
                sizeof(struct xfs_agfl) : 0)) / \
          sizeof(xfs_agblock_t))

so the packed version of struct xfs_agfl is smaller (36 vs 40), and so
yields a larger XFS_AGFL_SIZE (119 vs 118 in this case) and thus a
larger possible index (118 vs 117)

The (older) repair code you ran thinks 117 is the max index, but the
(newer) kernel created 118.  So this is newer kernel + older userspace,
that all makes sense so far.

xfs_alloc_put_freelist():

        be32_add_cpu(&agf->agf_flfirst, 1);
        xfs_trans_brelse(tp, agflbp);
        if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp)) // 119
                agf->agf_flfirst = 0;

so I guess this is the non-growfs case that can hit this as well, and
we can end up with agf_flfirts == 118 when the repair code thinks
117 is the max permissible.  It's just less likely than the growfs
case.  Now, how to fix this one for all combinations...  :(

-Eric 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
