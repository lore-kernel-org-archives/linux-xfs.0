Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMA4028123287 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 04:04:01 -0600
Received: from smtp2b.orange.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E643AE8AB94
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 02:04:42 -0800 (PST)
Received: from smtp2b.orange.fr (smtp2b.orange.fr [80.12.242.144]) by
	cuda.sgi.com with ESMTP id oPyCVgnB2B74wuFM for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 02:04:42 -0800 (PST)
Message-ID: <4B3097C4.3060803@wanadoo.fr>
Date: Tue, 22 Dec 2009 10:56:20 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net> <87d427jscr.fsf@devron.myhome.or.jp>
In-Reply-To: <87d427jscr.fsf@devron.myhome.or.jp>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Blake <ebb9@byu.net>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>

Hi all,


OGAWA Hirofumi wrote:
> Eric Blake<ebb9@byu.net>  writes:
>
>    
> It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
> people at all. So, for now, just Cc: to fuse people.
>    

Which ntfs-3g version are you using ?

>> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0
>>      
>    

Currently ntfs-3g does not set sub-second precision.

There is also a slight problem in the fuse interface :
the time buffer is never passed as NULL, consequently
in some circumstances ntfs-3g cannot decide correctly
over permissions. A permissive action is taken in this
situation.

> > From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
> request would pass to userland via fuse of kernel part, then it will be
> handled by libfuse.
>
> > From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g is
> using "struct fuse_operations", not "struct fuse_lowlevel_ops".
>    

With the latest ntfs-3g, currently as a release candidate,
you can (optionally) use the low level fuse interface
http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html
use the "lowntfs-3g" driver instead of "ntfs-3g"

Hope this helps

Regards

Jean-Pierre



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
