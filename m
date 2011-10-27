Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RG7HLG104362 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 11:07:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2B451FC758
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 09:07:15 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	k5JH16Lnfs7GylMA for <xfs@oss.sgi.com>;
	Thu, 27 Oct 2011 09:07:15 -0700 (PDT)
Date: Thu, 27 Oct 2011 12:07:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question w.r.t xfsprogs changes
Message-ID: <20111027160711.GB21551@infradead.org>
References: <1319664723.1959.90.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319664723.1959.90.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, Oct 26, 2011 at 04:32:03PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> I am trying to make changes to the xfsprogs to support the patches I
> posted last week (and few minutes earlier).
> 
> Looking at the xfsprogs code, I realize that the content of some of the
> files(xfs_mount.c, xfs_quota.h, etc.,) are pretty much same as the
> kernel files.
> 
> Just wondering if those changes are to be made explicitly or they will
> be copied over from the kernel tree at some regular intervals ? IOW,
> should I be changing those files (in xfsprogs) and posting them as
> patches or have to wait for the sync to happen and then make only the
> changes that are specific to user space ?

Yes - basically all of the xfs_* files in libxfs/ and include are
copies of the kernel code.  Unfortunately it's not 1:1 at the moment
as there are a few differences:

 - the userspace code uses a single <xfs.h> include instead of the
   individual includes in kernel space
 - some files aren't fully used in userspace and the userspace variants
   miss some functions
 - if I remember correctly some functions aren't static in the userland
   version.

The latests xfsprogs release contains a major rebase of the code, but
if you have enough time to a resync with the code for the Linux 3.2
merge it would help a lot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
