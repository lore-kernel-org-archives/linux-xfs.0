Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n091QGih030897 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 19:26:18 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6D3872BF7
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 17:26:14 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id OEJA0qFHeFRWyIDb for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 17:26:14 -0800 (PST)
Date: Fri, 9 Jan 2009 02:26:10 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109012610.GA23075@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109004609.GM9448@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> Looking at this, I think there are two possibilities in terms of the
> problem being detected. We are modifying the inode BMBT here,
> so that means we have XFS_BTREE_ROOT_IN_INODE set. The corruption
> trigger has occurred because a xfs_btree_increment() call has
> returned a zero status. This means we failed here:
> 
> 1324         /* Fail if we just went off the right edge of the tree. */
> 1325         xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
> 1326         if (xfs_btree_ptr_is_null(cur, &ptr))
> 1327                 goto out0;
> 
> or here:
> 
> 1351         /*
> 1352          * If we went off the root then we are either seriously
> 1353          * confused or have the tree root in an inode.
> 1354          */
> 1355         if (lev == cur->bc_nlevels) {
> 1356                 if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> 1357                         goto out0;
> 1358                 ASSERT(0);
> 
> i.e. we either fell off the right edge of the tree or went over the top
> of it.

> I can't really see how we've done either of those things unless the
> tree has been corrupted by a prior operation.
sounds logical.

First time when it happened i moved the primairy hd to sec ide connector, connected
a seperate hard drive as new master, installed a fresh debian lenny on that
harddrive, ran xfs-repair on all xfs filesystems: no errors

> Given that each time it is aptitude that is causing the problem, can you
> prevent aptitude from running automatically on boot and run it manually?
> If you can reporduce the problem manually then we can move on to the
> next step....

I wasn't clear (obvioulsy)
This machine is besides my NAS also my apt-cacher-ng server for all my other
machines here at home. The easiest way to trigger the error is often by running
a simple "aptitude update; aptitude -d dist-upgrade" 
So when it barfed i did the aptitude by hand.
And it checks everything from the cache at /var/cache/apt-cacher-ng
which is on sda6 (root filesystem on XFS)

So it doesn't "barf" right on boot, it takes a few minutes or even hours:

filer1:~# last -20 reboot
reboot   system boot  2.6.28-git2-d    Thu Jan  8 12:00 - current(05:18)    
reboot   system boot  2.6.28-git3-d    Thu Jan  8 11:31 - 11:59  (00:27)    
reboot   system boot  2.6.28-git3-d    Thu Jan  8 10:56 - 11:59  (01:02)    
reboot   system boot  2.6.28-git3-d    Thu Jan  8 10:44 - 10:54  (00:10)    
reboot   system boot  2.6.28-git3-d    Thu Jan  8 10:30 - 10:43  (00:12)    
reboot   system boot  2.6.28-git2      Wed Jan  7 15:08 - 10:28  (19:19)    
reboot   system boot  2.6.28-git9-d    Wed Jan  7 12:29 - 14:58  (02:29)    
reboot   system boot  2.6.28-git2      Wed Jan  7 10:08 - 12:27  (02:19)    
reboot   system boot  2.6.28-git9      Wed Jan  7 09:21 - 10:06  (00:45)    
reboot   system boot  2.6.28-git9      Wed Jan  7 08:42 - 10:06  (01:24)    
reboot   system boot  2.6.28-git2      Tue Jan  6 21:45 - 08:40  (10:55)    
reboot   system boot  2.6.28-git4      Tue Jan  6 21:27 - 08:40  (11:13)    
reboot   system boot  2.6.28-git4      Tue Jan  6 21:22 - 08:40  (11:18)

Sometimes the kernel barfes while accessing /dev/sdb1 of /dev/sdc1
which is only accessed using samba.

I can once more install the "other" debian lenny harddrive, boot from there
and than manually do an xfs_repair on xfs filesystems.
I can than boot a kernel that is know to barf and try to get it to barf.

> > So (in my case) something while going from git2 -> git3 didn't go positive.
> That would have been when Linus did the XFS pull...

Do you want me to figure out what patch from git2->git3 is the cullprit ?
I'll have to compile/reboot for a while.

Tell me what else i can do to resolve this.

Danny
-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
