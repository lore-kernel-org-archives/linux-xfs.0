Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 02:38:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N9cEq0002147
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 02:38:14 -0700
Date: Mon, 23 Jun 2008 05:39:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: XFSQA test for CI testing
Message-ID: <20080623093913.GB21251@infradead.org>
References: <op.uc62b6dy3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uc62b6dy3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> +/*
> + * Implement a simple hash on a character string.
> + * Rotate the hash value by 7 bits, then XOR each character in.
> + * This is implemented with some source-level loop unrolling.
> + */
> +static uint32_t xfs_da_hashname(const char *name, int namelen)

Shouldn't this be available from recent libxfs?   Except for that the
patch looks good to me.
