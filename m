Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNJMsnW259165 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 13:22:55 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8A79134ECDA
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 11:23:36 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id isymQeHirBgVerji for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 11:23:36 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B3212ED.4090208@byu.net>
Date: Thu, 24 Dec 2009 04:23:28 +0900
In-Reply-To: <4B3212ED.4090208@byu.net> (Eric Blake's message of "Wed, 23 Dec
	2009 05:54:05 -0700")
Message-ID: <87vdfxmr4f.fsf@devron.myhome.or.jp>
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
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, bug-coreutils <bug-coreutils@gnu.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, ctrn3e8 <ctrn3e8@gmail.com>, Jean-Pierre =?iso-8859-1?Q?Andr=E9?= <jean-pierre.andre@wanadoo.fr>, Christoph Hellwig <hch@lst.de>

Eric Blake <ebb9@byu.net> writes:

> By the way, is there any reliable way, other than uname() and checking for
> a minimum kernel version, to tell if all file systems will properly
> support UTIME_OMIT?

Um... sorry, I don't know. And it might be hard to detect efficiently if
the workaround is enough efficient like one fstat() syscall (Pass fd to
kernel.  I.e. just read from cached inode).

> For coreutils 8.3, we will be inserting a workaround where instead of
> using UTIME_OMIT, we call fstatat() in advance of utimensat() and pass
> the original timestamp down.  But it would be nice to avoid the
> penalty of the extra stat if there were a reliable way to ensure that,
> regardless of file system, the use of UTIME_OMIT will be honored.
> After all, coreutils wants touch(1) to work regardless of how old the
> user's kernel and file system drivers are.

Or it would depend on coreutils policy though, personally I think it's
ok that it ignores the bug as known fs bug, otherwise coreutils would
need to collect workarounds on several filesystems of several OSes.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
