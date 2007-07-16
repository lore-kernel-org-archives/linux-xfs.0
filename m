Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 20:28:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G3Shbm002542
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 20:28:45 -0700
Date: Mon, 16 Jul 2007 13:28:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix ASSERT and ASSERT_ALWAYS
Message-ID: <20070716032834.GK12413810@sgi.com>
References: <20070714160418.GA7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714160418.GA7768@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 14, 2007 at 06:04:21PM +0200, Christoph Hellwig wrote:
>  - remove the != 0 inside the unlikely in ASSERT_ALWAYS because sparse now
>    complains about comparisms between pointers and 0
>  - add a standalone ASSERT implementation because defining it to
>    ASSERT_ALWAYS means the string is expanded before the #token passing
>    stringification.  This way we get the actual content of the
>    assertatio in the assfail message and don't overflow sparse's
>    strinification buffer leading to sparse error messages.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

OK.

Rather than replying to each patch, Christoph - I've taken the
whole set into my queue for 2.6.24. All the warnings and cleanups
look ok and should not be a problem, but I need to have a much
closer look at the bmbt_rec endian notation series before that
goes further.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
