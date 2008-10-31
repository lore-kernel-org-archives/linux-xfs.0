Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 13:37:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VKbFro019934
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:37:16 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BA30568142
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:37:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ncnqMOCaTGBLEfsE for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:37:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1Kw0k8-0001qK-Fq
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 20:37:16 +0000
Date: Fri, 31 Oct 2008 16:37:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031203716.GB11514@infradead.org>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed> <20081031004814.GN4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031004814.GN4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 11:48:14AM +1100, Dave Chinner wrote:
> @@ -1118,8 +1118,7 @@ xfs_fs_write_super(
>  	struct super_block	*sb)
>  {
>  	if (!(sb->s_flags & MS_RDONLY))
> +		xfs_sync_fsdata(XFS_M(sb), SYNC_WAIT);

Not commenting on the rest yet, but I'm sure you noticed that before
your patch we ever called xfs_sync_fsdata with SYNC_WAIT at all.  I
think with the current codebase there is nothing to guarantee we ever
write the superblock out to disk as xfs_wait_buftarg specificly
excludes the superblock (XBF_FS_MANAGED)
