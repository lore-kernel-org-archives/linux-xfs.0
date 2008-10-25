Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:27:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKQvcN030627
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:26:57 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3543546B06
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:26:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id DMgMcNs5cORkjflf for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:26:57 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:26:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2 v2] hook up fiemap & associated formatter
Message-ID: <20081025202657.GG28002@infradead.org>
References: <49031E81.7040807@sandeen.net> <4903207B.6030009@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4903207B.6030009@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> +#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)

Why do we need FIEMAP_FLAG_SYNC in here?  That flag is implemented in
the VFS and should be handled there.  (Probably more a question for
the generic implementation than your patch)

> +
> +STATIC int xfs_fiemap_format(

STATIC int
xfs_fiemap_format(



Buit the meat of the patch looks good to me.
