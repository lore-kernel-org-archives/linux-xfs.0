Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 07:40:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OEeqQG029173
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 07:40:52 -0700
Date: Wed, 24 Sep 2008 10:42:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080924144226.GB349@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F44A.5010601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9F44A.5010601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, Sep 24, 2008 at 06:03:22PM +1000, Lachlan McIlroy wrote:
> Pete clearly demonstrated to me that the sv_wait is being prematurely
> woken up when it should not be.  There may be an underlying problem or
> this could just be another peculiarity of the Linux kernel.  Either way
> Pete will continue to look into this and whatever the explanation turns
> out to be, we deperately need a way to prevent our customers from
> running into this deadlock.  Even if there is another problem lurking
> this code change is fine and if nothing else will serve as a performance
> improvement.

Folks, please at least invest half the time you spend flaming each other
into looking at underlying causes ;-)
