Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 01:38:29 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E8cL4p027680
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 01:38:25 -0700
Date: Fri, 14 Sep 2007 04:38:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [UNSURE] can't remove dir
In-Reply-To: <20070914080926.GA30150@apartia.fr>
Message-ID: <Pine.LNX.4.64.0709140438130.752@p34.internal.lan>
References: <20070914080926.GA30150@apartia.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: linux-xfs@oss.sgi.com



On Fri, 14 Sep 2007, Louis-David Mitterrand wrote:

> Hello,
>
> While cleaning up /lost+found a directory resisted removal:
>
> 	sylla:/lost+found# rm 1879629858 -rf
> 	rm: cannot remove directory `1879629858': Directory not empty
>
> The directory _is_ empty and "-rf" should remove it anyway, so this
> looks like a fs error.
>
> This is on debian unstable with 2.6.23-rc6.
>
>

what does "ls -al 1879629858" say?
