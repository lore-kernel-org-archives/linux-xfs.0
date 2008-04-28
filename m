Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 22:55:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S5sUQW004783
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:54:37 -0700
Date: Mon, 28 Apr 2008 01:55:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa - 008 is unreliable on 64k page size
Message-ID: <20080428055511.GA3192@infradead.org>
References: <20080408013833.GN108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408013833.GN108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 08, 2008 at 11:38:33AM +1000, David Chinner wrote:
> Test 008 is unreliable on 64k page size. The I/O size is large
> enough that the probability of extent merging results in intermittent
> failures due to fewer extents that the +/- 10% tolerance allows.

Looks good.
