Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 02:06:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G96MGO005963
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 02:06:22 -0700
Date: Thu, 16 Oct 2008 05:08:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: another problem with latest code drops
Message-ID: <20081016090805.GA32101@infradead.org>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6FCB7.6050905@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 16, 2008 at 06:35:03PM +1000, Lachlan McIlroy wrote:
> I'm not seeing a leak in that slab - actually that slab doesn't even
> show up.  I am seeing a lot of memory used here though:

Are you using slab or slub?  The latter merges caches of equal size, so
it's totally useless for the kind of debug stats Dave looked at.
