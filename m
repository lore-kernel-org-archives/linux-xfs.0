Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Aug 2007 18:21:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7B1Llbm006615
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2007 18:21:49 -0700
Message-ID: <46BD0F30.6080306@sandeen.net>
Date: Fri, 10 Aug 2007 20:21:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS thread inflation in 2.6.23rc
References: <200708081240.21548.ak@suse.de> <200708081422.10373.ak@suse.de> <20070808131404.GQ52011508@sgi.com> <200708081526.06860.ak@suse.de> <20070809110322.GA12413810@sgi.com> <46BCBDB2.6070703@sandeen.net> <20070810234940.GO12413810@sgi.com>
In-Reply-To: <20070810234940.GO12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

David Chinner wrote:

> http://oss.sgi.com/archives/xfs/2007-08/msg00009.html
> 
> "On-demand reaping of the MRU cache
> 
> Instead of running the mru cache reaper all the time based on a
> timeout, we should only run it when the cache has active objects.
> This allows CPUs to sleep when there is no activity rather than
> be woken repeatedly just to check if there is anything to do."

Ah, cool.  Missed that, sorry.  Will re-run powertop with that just to
keep you on your toes.  ;-)

-Eric
