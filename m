Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 06:35:45 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l92DZS2a010150
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 06:35:31 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
Date: Tue, 2 Oct 2007 15:35:14 +0200
References: <200710021010.58284.ak@suse.de> <20071002125923.GH995458@sgi.com>
In-Reply-To: <20071002125923.GH995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021535.14973.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, cattelan@thebarn.com


> One thing that is notable here is that the XFS code returns
> -1 if no bits are set. fls/fls64 return 0 in the same case, so
> the magic "- 1" will make them behave the same. however, it
> appears that find_first_bit() will return the number of bits
> searched. That might leave us with som nasty, non-obvious error
> cases....

See the changelog:

The semantics of the Linux functions differ a little, but i checked
all call sites that they can deal with that.

> 
> Also, I don't really like the fact it requires sprinkling magic "-
> 1" adjustments to the return value of the replacement functions.  If
> that is the way the functions work and relate to the XFS bitmaps,

Not all callers use them as bitmap indexes, some also use them as true log2s.
I also eliminated some + 1s.

Whatever you do it's not the same for all.

-Andi
