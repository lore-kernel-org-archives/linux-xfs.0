Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 16:44:45 -0800 (PST)
Received: from mail.atipa.com (125.14.cm.sunflower.com [24.124.14.125])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB20iaaG014993
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 16:44:37 -0800
MIME-Version: 1.0
Subject: RE: Issues with XFS on Sles9 sp2.
Date: Fri, 1 Dec 2006 18:44:56 -0600
Message-ID: <E7EB4A8D5B2C8F498A269F0963C8BB8ED86D@mail.atipa.com>
References: <45704570.7020209@atipa.com> <Pine.LNX.4.64.0612020007490.3735@sheep.housecafe.de>
From: "Roger Heflin" <rheflin@atipa.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com




-----Original Message-----
From: Christian Kujau [mailto:lists@nerdbynature.de]
Sent: Fri 12/1/2006 6:25 PM
To: Roger Heflin
Cc: xfs@oss.sgi.com
Subject: Re: Issues with XFS on Sles9 sp2.
 
>On Fri, 1 Dec 2006, Roger Heflin wrote:
>> converting the machines to ext3 eliminates the issues.  Under load
>> they were seeing 1-2 events per 24 hours on 100 machines.
>
>just to be sure: 1-2 machines out of 100 had a hanging XFS in 24h, 
>right? (as opposed to "each of the 100 machines had 1-2 incidents in 
>24h" ;))

1-2 machines out of the 100 each 24 hours, different machines will
fail the next day if they are under a similar load.

>> They are using Sles9SP2, currently we cannot go to SP3 as there
>> are some other bad driver issues unrelated to XFS (the issue
>> preventing us from upgrading also appears to be in 2.6.16.x
>> kernel.org kernels so that is a more than just a SLES issue).
>
>So, you can't upgrade to a more current SuSE kernel, but you've already 
>tried vanilla kernels? OK, you won't be able to upgrade to a kernel.org 
>kernel because of the driver issues - but do the XFS hangs go away?
>Did it happen with earlier SuSE kernels too?

I tested with the earlier vanilla kernels on only a couple
of machines to see if the "other" problems was also in it, as if
it was not I might be able to upgrade that specific part and the
"other" problem was in the kernel.org kernel, so the new driver was
unlikely fix anything so I don't have any data that would tell me
if the problem XFS happens or not.     We did not find the XFS issue
in the testing stage (where the SP3 and kernel.org testing was done),
we found the XFS issues in the early production phase.  The customer
can duplicate it, but those machines are connected by sneakernet, at
a remote site.

I also don't have similar data on earlier versions of 
sles as the SP1 setup only uses XFS on a limited number
of file servers (no general usage) but on those file servers
we have not seen any issues and have ran 4 machine like that
for 1.5 years.   Though if it were a out of kernel memory
issue those machines may not be having that condition happen.

The condition does not seem to happen at idle, the machines
only lockup with a load on them, we never saw the issue at 
idle, or with well understood loads (HPL).

>> anywhere.  The first type of machine to have the issue
>> and where the issue is alot more common has only 4GB
>> of ram, the second type of machine that has recently
>> starting also having the error has 32GB of ram.
>
>Shot in the dark: did you try to boot with the "mem=" option?
>You could try to boot with e.g. "mem=512M" and see if the problem has 
>something to do with memory...


I don't think it has to do with real memory, it may have to
do with some resource that is in short supply at some time,
like maybe a shortage of kernel memory at the wrong time,
the machines have never been observed to fail under idle
or under controlled loads (HPL) and we have significant
runs times under both of those conditions (ie 20+ times the
observed failure time) so far the machines have only failed under
production loads, we have yet to be able to duplicate the
failure under any test loads.

The machines all appear to work correctly under tests like
bonnie, and the machines are found with XFS locked up
several hours later, so we don't really have a way of catching
exactly what happened at the time of the event to cause it,
non-xfs file systems still function, and the machine is still
usable so long as one avoids the locked up XFS file systems,
we only have 1 xfs file system on each machine so I don't know
if a second xfs would also be locked up or not.  Also these
file systems are build on MD stripe arrays, and that may
play some part in this.    The ext3 filesystems are also
build on the same md arrays and work just fine.

We used XFS because we observed that ext3's write rates 
started to drop down significantly after a few minutes of
sustained IO rates (much more than was expected from moving
to the inner disk tracks), and XFS did not appear to suffer from
this issue, so produced more predictable results.

                         Roger


[[HTML alternate version deleted]]
