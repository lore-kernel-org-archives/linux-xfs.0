Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Apr 2008 23:35:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3Q6ZB63001709
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 23:35:19 -0700
Date: Sat, 26 Apr 2008 02:35:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: 980021 - fix up noattr2 mount option
Message-ID: <20080426063551.GA7193@infradead.org>
References: <480EC93D.9090103@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480EC93D.9090103@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Apr 23, 2008 at 03:29:33PM +1000, Timothy Shimmin wrote:
> Hi there,
>
> Mounting noattr2 in xfs fails to achieve anything AFAICT -
> and it certainly doesn't do anything useful.

The patch looks correct in that it turns off attr2 when using the mount
option now.  But the real question is why do we even need this option at
all?
