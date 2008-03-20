Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 13:35:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2KKZcv5006179
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 13:35:40 -0700
Date: Thu, 20 Mar 2008 16:36:10 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] XFSQA 166: support varying page sizes
Message-ID: <20080320203610.GA16357@josefsipek.net>
References: <20080320063713.GC103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320063713.GC103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 05:37:13PM +1100, David Chinner wrote:
> Make the filter check the resultant output based on
> the initial written region size. hence page size of the
> machine will not affect the output of the filter.
> Modify the golden output to match.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>

This fixes the failure I reported few days ago.

Josef 'Jeff' Sipek.

-- 
If I have trouble installing Linux, something is wrong. Very wrong.
		- Linus Torvalds
