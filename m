Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 10:35:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OHZCfB010141
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 10:35:15 -0700
Message-ID: <462E3E93.8090400@sandeen.net>
Date: Tue, 24 Apr 2007 12:29:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: system freeze with xfs
References: <1177433458.3360.12.camel@localhost.localdomain>
In-Reply-To: <1177433458.3360.12.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jurgen Schulz <jmschulz@earthlink.net>
Cc: xfs@oss.sgi.com

Jurgen Schulz wrote:
> When I create an xfs filesystem and run
> 'stress' (http://weather.ou.edu/~apw/projects/stress/stress.html) I can
> induce a system freeze (hang, no panic). There are no issues if I create
> a jfs filesystem (on the same disk) or run 'stress' on a different disk
> (ext3)
> 
> I'd like to know how I could go about debugging this, otherwise I will
> have to switch filesystem types.

is that a threat?  ;-)

Try enabling sysrq, and do sysrq-t when it freezes, as a first pass, to
see where all the threads are (stuck) at.

You might also try this on a stock upstream kernel, and see if you have
the same problem with 8k stacks vs. 4k (as is in FC6)

You could also set up kdump and/or netdump (whatever FC5 supports...)
and get a system dump at the time it freezes up, via sysrq-c.

Thanks,

-Eric
