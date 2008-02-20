Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 11:13:11 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KJD4QM008065
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 11:13:06 -0800
Date: Wed, 20 Feb 2008 14:13:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] detect and correct bad features2 superblock field
Message-ID: <20080220191328.GB24257@infradead.org>
References: <20080220054041.GM155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220054041.GM155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 20, 2008 at 04:40:41PM +1100, David Chinner wrote:
> There is a bug in mkfs.xfs that can result in writing the features2
> field in the superblock to the wrong location. This only occurs
> on some architectures, typically those with 32 bit userspace and
> 64 bit kernels.

Well, we don't use different ABIs for kernel vs userspace so some
kernels will get it wrong aswell, you just won't notice until moving
to a different box because userspace is the same.

> +
> +	/* must be padded to 64 bit alignment */
>  } xfs_dsb_t;

I'm pretty sure there is some gcc __packed__ magic to enfore that,
might it be worth to poke some gcc experts to add it?


But the actual patch looks fine, ACK from me.
