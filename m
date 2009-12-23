Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNDsVPA239598 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 07:54:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7973E1221FE
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 05:55:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ar2wFxf0lQ0fgbO6 for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 05:55:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NNRgJ-0007gR-5z
	for xfs@oss.sgi.com; Wed, 23 Dec 2009 13:55:15 +0000
Date: Wed, 23 Dec 2009 08:55:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] repair btree validation improvements
Message-ID: <20091223135515.GA29509@infradead.org>
References: <20091201150503.958283878@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091201150503.958283878@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Tue, Dec 01, 2009 at 10:05:03AM -0500, Christoph Hellwig wrote:
> This patchset contains some improvements to the allocation btree checking
> in xfs_repair.  Patches 2 / 3 are straight ports of code used for xfs_check
> in xfs_db and bring the level of btree-related checks up to the standard
> of xfs_check, making xfs_repair -n a fully suitable replacement for xfs_check.
> 
> Patch 1 is a bug fixes found while validating the other patches.
> 
> With this code we could in theory start chaning xfs_check to use xfs_repair
> as backend instead of xfs_db, but there are two issues still preventing this
> for now:
> 
>  - xfs_check is supposed to not give any output when a filesystem is clean
>    while xfs_repair is quite noisy
>  - xfs_check has a -s option to only complain about serious structural
>    issues while xfs_repair lacks the infrastructure for it.
>  - xfs_check has -i and -b options to only examine specific blocks or inodes
>    in details, while xfs_repair lacks the infrastructure for this.
> 
> While we could add support for this in xfs_repair I wonder if we should
> just leave xfs_check as-is and instead tie up xfs_repair -n to fsck.xfs
> if used with the -f option or the /forcefsck file.  Most fsck programs
> are a least a bit noisy to we would fit right in and there's not need
> to implement the additional check options.
> 
> We can't really get rid of the check code in xfs_db anyway as it's also
> used for xfs_ncheck and useful db commands like blockuse.  A second codebase
> also provides a useful validation for xfs_repair.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
