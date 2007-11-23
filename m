Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 17:24:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAN1OTmJ024010
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 17:24:32 -0800
Date: Fri, 23 Nov 2007 12:24:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/2] Debug - don't exhaustively check the AIL on every operation
Message-ID: <20071123012425.GA114266761@sgi.com>
References: <20071122005003.GQ114266761@sgi.com> <47462222.9060501@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47462222.9060501@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Nov 23, 2007 at 11:43:14AM +1100, Lachlan McIlroy wrote:
> Looks good Dave.
> 
> There's lots of debug code bound by XFS_TRANS_DEBUG - should we be
> enabling this in our QA?

No, they are more for validation when you are hacking on the
transaction code.  The current debug code should detect most
problems runtime problems, but if you change the way anything in the
logging works you'll be wanting to test your changes with that set
(e.g. when we do the transaction rollback stuff).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
