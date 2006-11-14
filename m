Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Nov 2006 02:34:28 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAEAYJaG020999
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 02:34:20 -0800
Message-ID: <45599B0E.8050505@uni-hd.de>
Date: Tue, 14 Nov 2006 11:31:42 +0100
From: Martin Braun <mbraun@uni-hd.de>
Reply-To: mbraun@uni-hd.de
MIME-Version: 1.0
Subject: Re: xfs kernel BUG again in 2.6.17.11
References: <44E1D9CA.30805@uni-hd.de> <20060816101122.E2740551@wobbly.melbourne.sgi.com> <44EB228F.6020903@uni-hd.de> <20060823134211.E2968256@wobbly.melbourne.sgi.com> <45583ABE.6080909@uni-hd.de> <20061114040053.GD8394166@melbourne.sgi.com> <45598B07.6080401@uni-hd.de> <slrnelj5k3.7lr.olecom@flower.upol.cz>
In-Reply-To: <slrnelj5k3.7lr.olecom@flower.upol.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oleg Verych <olecom@flower.upol.cz>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Oleg,

thanks for your response.
> You can find fixes in .17 stable git tree.
Yes it is a 2.6.17.11 stable kernel. - By the way: we tried to setup
kernel 2.6.18.2 on that machine but we got a weired time error, ntpdate
shows two times: first run correct time, second run time is half an hour
in the future - so we switched back to 2.6.17.11

> If it was really just sparse annotations, they were obviously
> fixed, i think. If not, meybe there are some new bugs.
> +
>> It seems that xfs_repair (2.8.10), did not find all of the errors of the FS.
>> Is there a way to be sure that the FS is clean?
> 
> As in faq:
> |   Update: a fixed xfs_repair is now available; version 2.8.10 or later
> |   of the xfsprogs package contains the fixed version.
> .....      
> |   The xfs_check tool, or xfs_repair -n, should be able to detect any
> |   directory corruption.

However the two Kernel BUGS were _after_ xfs_repair (version 2.8.10).

>> Normally  the Kernel freezes/hangs completely, but I found two new
> 
> Do you mean panic or oops here, or just freeze?

In detail:  a Kernel BUG in /var/log/messages is written and after that
the cpu load average is climbing up to 20-30, any tries to shutdown the
system, kill processes umounts etc. are in vain. Than the system freezes
completely: no keyboard, nothing.

 cheers,
martin
