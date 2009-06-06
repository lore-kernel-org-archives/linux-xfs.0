Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n564hnkQ084813 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 23:43:49 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70EB22D8079
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 21:44:07 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id SvtPnejOUdtzHRiT for
	<xfs@oss.sgi.com>; Fri, 05 Jun 2009 21:44:07 -0700 (PDT)
Message-ID: <4A29F415.5020203@sandeen.net>
Date: Fri, 05 Jun 2009 23:44:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Segmentation fault during xfs_repair
References: <20090605222236.GA39825@magus.portal.sigil.org>
In-Reply-To: <20090605222236.GA39825@magus.portal.sigil.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Richard Kolkovich <richard@intrameta.com>
Cc: xfs@oss.sgi.com

Richard Kolkovich wrote:
> We have a corrupted XFS partition on a storage server.  Attempting to run xfs_repair the first time yielded the message about a corrupt log file, so I have run xfs_repair with -L to clear that.  Now, xfs_repair segfaults in Phase 3.  I have tried -P and a huge -m to no avail.  It always seems to segfault at the same point:
> 
> bad directory block magic # 0 in block 11 for directory inode 341521797
> corrupt block 11 in directory inode 341521797
>         will junk block
> Segmentation fault (core dumped)

...

> I can provide the full core file, if need be (956M).  The xfs_metadump can be found at:
> 
> http://files.intrameta.com/metadump.gz (735M)
> 
> Any suggestions/ideas on how to proceed are welcome.  Please Reply-All, as I'm not subscribed to the ML.

Ok, on a -g (not -02) build:

Program terminated with signal 11, Segmentation fault.
#0  0x0000000000418d05 in traverse_int_dir2block (mp=0x7ffff4c4f150,
da_cursor=0x7ffff4c4eb30, rbno=0x7ffff4c4ebdc) at dir2.c:356
356			da_cursor->level[i].hashval =
(gdb) p i
$1 = 46501

i is set from

i = da_cursor->active = be16_to_cpu(node->hdr.level);

(gdb) p node->hdr.level // note this is big endian
$2 = 42421

that's a crazily deep btree, well beyond anything sane:

#define XFS_DA_NODE_MAXDEPTH    5       /* max depth of Btree */

So repair really should be checking for this before it goes off and
indexes it:

356			da_cursor->level[i].hashval =

because the cursor only has this much in the array:

        dir2_level_state_t      level[XFS_DA_NODE_MAXDEPTH];

I'll have to ponder what repair should do in this case ... and I'll see
if there's something we can do in xfs_db to just whack out this problem
and let repair continue for now.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
