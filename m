Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:20:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKK5h5029290
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:06 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B944147F671
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ccLlKP6Ly44HsVCY for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:20:05 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:20:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] clean up printk formats with DMAPI_DEBUG
Message-ID: <20081025202005.GC28002@infradead.org>
References: <49031BB1.7080609@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49031BB1.7080609@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 08:14:25AM -0500, Eric Sandeen wrote:
>  #ifdef CONFIG_DMAPI_DEBUG
> -	printk("xfs_dm_round_hole: off %lu, len %ld, align %lu, "
> -	       "filesize %llu, roff %ld, rlen %ld\n",
> +	printk("xfs_dm_round_hole: off %lld, len %llu, align %llu, "
> +	       "filesize %lld, roff %lld, rlen %llu\n",
>  	       offset, length, align, filesize, *roff, *rlen);

We'd still need casts to (unsigned) long long because the 64 bit
types may be either variant on 64 bit platforms.
