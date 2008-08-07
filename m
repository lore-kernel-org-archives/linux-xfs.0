Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 15:03:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77M3m3j030262
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 15:03:48 -0700
Date: Thu, 7 Aug 2008 18:04:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
Message-ID: <20080807220459.GA15199@infradead.org>
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Sorry for the later review, but the xfs_super.c changes don't make
sense.  These allocations are done during module_init time and thus
it'ss fien to call back into any fs to reclaim pages for it.
Fortunately the affect is harmless, but I'd suggest reverting that part
of the change.
