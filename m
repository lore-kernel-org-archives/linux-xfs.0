Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:05:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F65A8J017160
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:05:11 -0700
Date: Thu, 15 May 2008 02:05:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa 073 - don't host loopback images in /tmp
Message-ID: <20080515060558.GB8780@infradead.org>
References: <20080515013255.GM155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515013255.GM155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 15, 2008 at 11:32:55AM +1000, David Chinner wrote:
> /tmp might be small, might not support files larger than 2GB,
> etc, so trying to host loopback images of 100GB filesystems
> will break in some situations. We should use $TEST_DIR for the
> images.
> 
> Note: remounting of loopback images has a major bug (in mount)
> that "leaks" loopback device references. Hence all the hackery
> with losetup to work around this.

Looks good.
