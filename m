Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 11:38:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84IcmoE007183
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 11:38:49 -0700
Date: Thu, 4 Sep 2008 14:40:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Improve caching in libxfs
Message-ID: <20080904184014.GB25890@infradead.org>
References: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com> <20080903234758.GA18368@infradead.org> <op.ugx0d0i83jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugx0d0i83jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 04, 2008 at 04:02:14PM +1000, Barry Naujok wrote:
>> Assert that we don't put a node that's already on the mru list, okay.
>> Shouldn't this be ASSERT?
>
> I chose to make this always abort as it can be triggered outside of
> libxfs by xfsprogs usage of it (ie. doing a "put" on a buffer that has
> already been "put").
>
> So, I thought this needs to always work, debug or non-debug and
> halt immediately if it happens.

Ok, makes sense.
