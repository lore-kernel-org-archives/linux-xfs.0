Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 00:56:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4C7uVfB013039
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 00:56:32 -0700
Date: Sat, 12 May 2007 17:56:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070512075618.GE85884050@sgi.com>
References: <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com> <4643A5B2.3060906@goop.org> <20070510232729.GH86004887@sgi.com> <4643AF8F.5040705@goop.org> <20070511003257.GL86004887@sgi.com> <4644823A.8090104@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4644823A.8090104@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Fri, May 11, 2007 at 07:48:26AM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> >> Yes, that does look like a good candidate.  Should I try to
> >> before-and-after this change?
> >>     
> >
> > Yes please!
> >   
> 
> OK, definite result.  Before ba87ea699ebd9dd577bf055ebc4a98200e337542: 
> all OK.  After: truncated files.
> 
> I also got a bmap of a particular truncated file,
> linux-clone-test-1/.hg/store/00manifest.i, diffing before with after:
> 
> --rw-r--r--  1 root root   3558208 May 11 01:16 /home/jeremy/hg/linux-clone-test-1/.hg/store/00manifest.i
> +-rw-r--r--  1 root root   3541760 May 11 01:16 /home/jeremy/hg/linux-clone-test-1/.hg/store/00manifest.i
> 
>    16: [6144..6271]:    18141808..18141935  2 (2413168..2413295)   128
>    17: [6272..6399]:    18140608..18140735  2 (2411968..2412095)   128
>    18: [6400..6911]:    18136464..18136975  2 (2407824..2408335)   512
> -  19: [6912..6951]:    18136336..18136375  2 (2407696..2407735)    40
> +  19: [6912..6919]:    18136336..18136343  2 (2407696..2407703)     8

Ok, thanks for confirming the cause of the regression. I'll post a patch
when I've got something for you to try.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
