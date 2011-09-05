Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p857ldGD261142 for <xfs@oss.sgi.com>; Mon, 5 Sep 2011 02:47:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 006E316A1F12
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2011 00:51:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	miamt5fgUszMxgUP for <xfs@oss.sgi.com>;
	Mon, 05 Sep 2011 00:51:28 -0700 (PDT)
Date: Mon, 5 Sep 2011 03:47:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ENOSPC and filesystem shutdowns
Message-ID: <20110905074734.GA18504@infradead.org>
References: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
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
To: Bernard Chan <bernard@goanimate.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 04, 2011 at 02:09:49PM +0800, Bernard Chan wrote:
> We have an XFS filesystem (on LVM, probably doesn't matter anyway) that is
> 4TB running on CentOS kernel 2.6.21.7,

Isn't Centos based on RHEL and thus running either 2.6.9, 2.6.18 or
2.6.32-ish kernels?

> We searched and found this list, and a few patches around kernel
> 2.6.26-2.6.27 that seem to match our scenario. We were able to log the
> specific mkdir command that failed and confirmed it consistently fails that
> way that gives "no space left on device", while we did not reproduce the
> same issue mkdir in other directories with large inode numbers. We haven't
> tried patching or upgrading the kernel yet, but we will do that later.
> 
> As the root cause of that patch points to a bug triggered by ENOSPC, we
> checked the inode numbers created for some directories and files with "ls
> -li" and some of them are pretty close to 2^32.
> 
> So, we would like to ascertain if that is the cause for ENOSPC in our case,
> and does that mean 32-bit inodes are no longer adequate for us and we should
> switch to 64-bit inodes? Will switching it avoid this kind of shutdowns with
> successful writes in the future?
> 
> And is it true that we don't need a 64-bit OS for 64-bit inodes? How can we
> tell if our system supports 64-bit inodes?

It doesn't.  On Linux XFS only supports inode64 on 32-bit systems since
Linux 3.0.

> Finally, although we all know that "df -i" is sort of nonsense on XFS, how
> can we get the output of 5% inode while having inode numbers that are close
> to 2^32? So what does that 5% exactly mean, or were I looking at inodes the
> wrong way?

It's based on the available space given that XFS can theoretically use
any inode block for data.

> Thanks in advance for any insights anyone may shed on this one.

I'd move off a 4.5-year old unsupposed kernel.  The real RHEL/Centos
kernel have fairly good xfs support these days if you want a backporting
option.  Even RHEL5 might have inode64 on 32-bit systems as it has a lot
of XFS updates backport, but in doubt I would recommend to move to
a RHEL6/Centos6 kernel at least.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
