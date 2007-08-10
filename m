Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Aug 2007 12:34:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7AJY6bm012960
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2007 12:34:08 -0700
Message-ID: <46BCBDB2.6070703@sandeen.net>
Date: Fri, 10 Aug 2007 14:34:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS thread inflation in 2.6.23rc
References: <200708081240.21548.ak@suse.de> <200708081422.10373.ak@suse.de> <20070808131404.GQ52011508@sgi.com> <200708081526.06860.ak@suse.de> <20070809110322.GA12413810@sgi.com>
In-Reply-To: <20070809110322.GA12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

David Chinner wrote:

> Andi, you are complaining to the wrong person about thread counts. I
> live in the world of excessive parallelism and multithreaded I/O. I
> regularly see 4-8p boxes running hundreds to thousands of I/O
> threads on a single filesystem. These are the workloads XFS is
> designed for and we optimise for. A single extra thread is noise....


The other thing this is doing, though, is having an impact on power
usage, I think.  Fedora is trying to identify things which wake the CPU
in an effort to reduce power usage if possible.

See for example:
http://article.gmane.org/gmane.linux.redhat.fedora.testers/50480

quoting:

"One of the biggest power problems is apps that wake up the CPU
unnecessarily. With the tickless kernel for x86 (and soon x86_64),
every time this happens it's a chance for power savings lost.

HOW YOU CAN HELP
----------------

We'd like to get as many reports of misbehaving apps as possible.

1) Install the 'powertop' package

2) Run it in a terminal window on a reasonably idle system with your
   normal combination of apps. (If you run it when you're actively
   compiling a kernel, watching a movie, or doing other CPU-intensive
   things, the results aren't as useful.)

3) Note the results..."

and here are the results w/ xfs mounted:

< Detailed C-state information is only available on Mobile CPUs (laptops) >
P-states (frequencies)
  2.21 Ghz     0.0%
  2.00 Ghz     0.0%
  1.80 Ghz   100.0%
Wakeups-from-idle per second : 31.7
no ACPI power usage estimate available
Top causes for wakeups:
  37.0% ( 20.0)             mount : xfs_mru_cache_create

...

looks like having this running (note: i'm not using filestreams on this
mounted filesystem) may be impacting the power usage of the CPU?  Or
maybe SGI doesn' care about that, if the goal is 100% utilization of
these machines on altixes etc... but still - something to consider I think.

Thanks,
-Eric
