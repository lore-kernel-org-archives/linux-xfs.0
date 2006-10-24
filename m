Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 10:41:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OHf4aG009559
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 10:41:07 -0700
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl>
Date: Tue, 24 Oct 2006 16:27:08 +0000
Message-ID: <slrnejsfms.93p.olecom@flower.upol.cz>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com, Oleg Verych <olecom@flower.upol.cz>


On 2006-10-24, Rafael J. Wysocki wrote:
> On Tuesday, 24 October 2006 16:44, David Chinner wrote:
>> On Mon, Oct 23, 2006 at 12:36:53PM +0200, Rafael J. Wysocki wrote:
>> > On Monday, 23 October 2006 06:12, Nigel Cunningham wrote:
>> > > XFS can continue to submit I/O from a timer routine, even after
>> > > freezeable kernel and userspace threads are frozen. This doesn't seem to
>> > > be an issue for current swsusp code,
>> > 
>> > So it doesn't look like we need the patch _now_.
>> > 
>> > > but is definitely an issue for Suspend2, where the pages being written could
>> > > be overwritten by Suspend2's atomic copy.
>> > 
>> > And IMO that's a good reason why we shouldn't use RCU pages for storing the
>> > image.  XFS is one known example that breaks things if we do so and
>> > there may be more such things that we don't know of.  The fact that they
>> > haven't appeared in testing so far doesn't mean they don't exist and
>> > moreover some things like that may appear in the future.
>> 
>> Could you please tell us which XFS bits are broken so we can get
>> them fixed?  The XFS daemons should all be checking if they are
>> supposed to freeze (i.e. they call try_to_freeze() after they wake
>> up due to timer expiry) so I thought they were doing the right
>> thing.
>> 
>> However, I have to say that I agree with freezing the filesystems
>> before suspend - at least XFS will be in a consistent state that can
>> be recovered from without corruption if your machine fails to
>> resume....
>
> Do you mean calling sys_sync() after the userspace has been frozen
> may not be sufficient?

Please see
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=317479;msg=105;att=0>

it's bottom of
<http://bugs.debian.org/317479>

IMHO it's may be helpful.

-o--=O`C
 #oo'L O
<___=E M
