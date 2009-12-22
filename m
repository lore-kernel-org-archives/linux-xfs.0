Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBM901rj119442 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 03:00:02 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C6C5E89ED1
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 01:00:42 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id kzBdfWWLeoJBZPUv for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 01:00:42 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
Date: Tue, 22 Dec 2009 18:00:36 +0900
In-Reply-To: <4B304D04.6040501@byu.net> (Eric Blake's message of "Mon, 21 Dec
	2009 21:37:24 -0700")
Message-ID: <87d427jscr.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
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
To: Eric Blake <ebb9@byu.net>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Eric Blake <ebb9@byu.net> writes:

> According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
>>> It may also be file-system dependent.  On the machine where I saw the
>>> original failure:
>>>> $ uname -a
>>>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>>>> x86_64 GNU/Linux
>>> $ df -T .
>>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>>> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
>> 
>> Thanks.
>> 
>> This is good point. This would be xfs issue or design. xfs seems to have
>> own special handling of ctime.
>
> Here's another report, this time about an mtime update not happening on
> ntfs-3g.  http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/19336

It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
people at all. So, for now, just Cc: to fuse people.

> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0

>From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
request would pass to userland via fuse of kernel part, then it will be
handled by libfuse.

>From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g is
using "struct fuse_operations", not "struct fuse_lowlevel_ops".

So, fuse_lib_setattr() would be the handler for it in libfuse. And, from
the following part, it seems to require the both of MTIME and ATIME to
call ntfs-3g's ->utime handler.

I don't know whether it is limitation or bug in fuse_operations.
Any ideas?

		if (!err &&
		    (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) ==
		    (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
			struct timespec tv[2];
			tv[0].tv_sec = attr->st_atime;
			tv[0].tv_nsec = ST_ATIM_NSEC(attr);
			tv[1].tv_sec = attr->st_mtime;
			tv[1].tv_nsec = ST_MTIM_NSEC(attr);
			err = fuse_fs_utimens(f->fs, path, tv);
		}

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
