Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 27 Oct 2007 06:07:48 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9RD7fcm006791
	for <xfs@oss.sgi.com>; Sat, 27 Oct 2007 06:07:42 -0700
Date: Sat, 27 Oct 2007 09:07:43 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raw vs XFS sequential write and system load
In-Reply-To: <034B199C-F1D2-42F8-B774-58AA11D8C79E@cern.ch>
Message-ID: <Pine.LNX.4.64.0710270907370.17945@p34.internal.lan>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch>
 <20071018222357.GN995458@sgi.com> <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch>
 <20071019075949.GS995458@sgi.com> <034B199C-F1D2-42F8-B774-58AA11D8C79E@cern.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mario Kadastik <mario.kadastik@cern.ch>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com



On Sat, 27 Oct 2007, Mario Kadastik wrote:

> Well to finally summarize, the things pointed out all helped too, but the 
> major change in system behavior came from the fact that 2.6.23 had totally 
> different virtual memory defaults than 2.6.9 and running with 2.6.23 one has 
> to change the dirty_ratio to something bigger to allow for a fast i/o machine 
> to actually handle the load. Now the four nodes we have are all running very 
> nicely and calmly and performing all the tasks we have asked from them, no 
> more see we any congestion etc.
>
> I have summarized my weeks of investigations into a twiki page, comments are 
> welcome:
>
> http://hep.kbfi.ee/index.php/IT/KernelTuning
>
> Thanks for the help,
>
> Mario
>

Very nice doc!

Thanks.

Justin.
