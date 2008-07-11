Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 00:18:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B7Io6a008922
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:18:50 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAF831BB5000
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:19:55 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id NZSikBeVLCXTkgeE for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 00:19:55 -0700 (PDT)
Date: Fri, 11 Jul 2008 17:19:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix reference counting race on log buffers
Message-ID: <20080711071953.GR29319@disturbed>
References: <1215752481-6862-1-git-send-email-david@fromorbit.com> <4876EED7.8060004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876EED7.8060004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 03:25:43PM +1000, Timothy Shimmin wrote:
> Dave,
> 
> Yeah, looks good. Thanks.

Thanks, Tim - I'll add the right tags and send it to Linus.

> (My personal preference is for reversing if/else than using !
>  as it is easier to read but whatever :)

It looked funny with one line in the upper branch, and I added
the comment inside the if() because it wasn't obvious from the
code (either way) which branch was the 'only ref' branch....

> But will need Eric's result before checking it in.

Seems like it's working fine, and i've got a coupl eof runs
through xfsqa now, so it should be good to go.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
