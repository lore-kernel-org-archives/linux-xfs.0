Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:49:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m397mwXp023661
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:48:59 -0700
Date: Wed, 9 Apr 2008 03:49:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #3] cleanup - remove bhv_vname_t
Message-ID: <20080409074924.GA27552@infradead.org>
References: <op.t9b1ien03jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9b1ien03jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Apr 09, 2008 at 05:24:04PM +1000, Barry Naujok wrote:
> +	ASSERT(ip1);

No need for an assert here, there's only one caller and we know it's
there.


Except for that nitpick the patch looks fine to me.
