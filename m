Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TCUVCx043552 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 07:30:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C095B184E405
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 05:30:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lt3JA0aGWHtUzKc4 for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 05:30:30 -0700 (PDT)
Date: Fri, 29 Jul 2011 08:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfstests: Add support for btrfs in 079
Message-ID: <20110729123028.GA4764@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de>
	<20110728085158.GD3407@infradead.org>
	<4E32A67E.9070306@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E32A67E.9070306@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 29, 2011 at 02:24:30PM +0200, Stefan Behrens wrote:
> I changed it according to your suggestion:
> - Get rid of the check for the specific filesystem type.
> - Always use FS_IOC_GETFLAGS/FS_IOC_SETFLAGS. This code is inside an
>   '#ifdef FS_IOC_SETFLAGS" block in order to never fail compilation.
> - Without support for FS_IOC_SETFLAGS, the test completes with _notrun.

Thanks!

> One issue is that the file is there (the creation did succeed but
> the open for writing did not) what IEEE 1003.1-2004 prohibits
> (open() must not create or modify any files if -1 is returned).

That sounds like something we need to fix, and it seems like we'll
need to fix it in the VFS.  Can you start a thread about that particular
issue on fsdevel?

> The difference between the filesystems is whether the append-only
> flag from the directory is inherited to the newly create file inside
> that directory. XFS does not inherit that append-only flag, ext2,
> ext3, ext4 and btrfs do inherit it.
> Test 079 fails when the open("/mnt3/foo/append-only.d/newfile-0",
> O_RDWR|O_CREAT, 0666) fails due to the O_RDWR flag. The O_RDWR
> flag lets the open() fail when the file has the append-only flag
> set. On one type of filesystem the flag is inherited from the
> directory, on the other type it is not. Test 079 expects that flag
> to not be inherited.
> 
> What is your opinion? I would prefer to either change the test to
> detect whether the append-only flag is inherited and then interpret
> the following system call result depending on the state of the flag,
> or to force the flag to a defined state to be independent of the
> inheritance behaviour.

Having different behaviour for different filesystems is a bad thing,
and given that XFS is the lonely one out there I think we should
remove the inheritance.  I'll preparate a patch for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
