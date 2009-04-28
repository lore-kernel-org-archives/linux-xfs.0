Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3S4CGhP068505 for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 23:12:17 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 573241452B0C
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 21:15:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id wKmXxFvQ1EHwO01X for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2009 21:15:29 -0700 (PDT)
Date: Tue, 28 Apr 2009 00:11:36 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <860553965.233621240891896139.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1913401106.233581240891740242.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] xfs_file_last_byte() needs to acquire ilock
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

----- "Felix Blyakher" <felixb@sgi.com> wrote:

> On Apr 23, 2009, at 10:46 PM, Lachlan McIlroy wrote:
> 
> >
> > ----- "Eric Sandeen" <sandeen@sandeen.net> wrote:
> >
> >> Lachlan McIlroy wrote:
> >>> We had some systems crash with this stack:
> >>>
> >>> [<a00000010000cb20>] ia64_leave_kernel+0x0/0x280
> >>> [<a00000021291ca00>] xfs_bmbt_get_startoff+0x0/0x20 [xfs]
> >>> [<a0000002129080b0>] xfs_bmap_last_offset+0x210/0x280 [xfs]
> >>> [<a00000021295b010>] xfs_file_last_byte+0x70/0x1a0 [xfs]
> >>> [<a00000021295b200>] xfs_itruncate_start+0xc0/0x1a0 [xfs]
> >>> [<a0000002129935f0>] xfs_inactive_free_eofblocks+0x290/0x460
> [xfs]
> >>> [<a000000212998fb0>] xfs_release+0x1b0/0x240 [xfs]
> >>> [<a0000002129ad930>] xfs_file_release+0x70/0xa0 [xfs]
> >>> [<a000000100162ea0>] __fput+0x1a0/0x420
> >>> [<a000000100163160>] fput+0x40/0x60
> >>>
> >>> The problem here is that xfs_file_last_byte() does not acquire
> the
> >>> inode lock and can therefore race with another thread that is
> >> modifying
> >>> the extext list.  While xfs_bmap_last_offset() is trying to
> lookup
> >>> what was the last extent some extents were merged and the extent
> >> list
> >>> shrunk so the index we lookup is now beyond the end of the extent
> >> list
> >>> and potentially in a freed buffer.
> >>>
> >>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >>> index e7ae08d..cf62d9d 100644
> >>> --- a/fs/xfs/xfs_inode.c
> >>> +++ b/fs/xfs/xfs_inode.c
> >>> @@ -1258,8 +1258,10 @@ xfs_file_last_byte(
> >>
> >>        /*
> >>         * Only check for blocks beyond the EOF if the extents have
> >>         * been read in.  This eliminates the need for the inode
> >> lock,
> >>         * and it also saves us from looking when it really isn't
> >>> 	 * necessary.
> >>> 	 */
> >>
> >> I suppose that comment should be modified too, and maybe the
> commit
> >> log
> >> should say why, exactly, it was wrong? :)
> > Ha, I didn't even read the comment!  It's still kind of correct in
> > that we wont have to get the inode lock if the extents have not
> been
> >
> > read in.
> 
> I'd still think the comments could be made less confusing
> if we're adding the inode lock here.
The more I read the comment the more it makes sense and it seems to
make more sense now with the change because it is clear how we can
avoid the inode lock if the extents are not read in.

How would you prefer the comment reads?

> 
> Felix
> 
> >
> >
> >>
> >> -Eric
> >>
> >>> 	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
> >>> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> >>> 		error = xfs_bmap_last_offset(NULL, ip, &last_block,
> >>> 			XFS_DATA_FORK);
> >>> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >>> 		if (error) {
> >>> 			last_block = 0;
> >>> 		}
> >>>
> >>> _______________________________________________
> >>> xfs mailing list
> >>> xfs@oss.sgi.com
> >>> http://oss.sgi.com/mailman/listinfo/xfs
> >>>
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
