Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 04:45:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ABiudI021300
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 04:44:56 -0700
Message-ID: <47D51FF0.2080000@steelbox.com>
Date: Mon, 10 Mar 2008 07:48:00 -0400
From: Kris Kersey <kkersey@steelbox.com>
MIME-Version: 1.0
Subject: Re: pdflush hang on xlog_grant_log_space()
References: <47D062AF.80501@steelbox.com> <20080307223510.GM155407@sgi.com>
In-Reply-To: <20080307223510.GM155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Bill Vaughan <billv@steelbox.com>

Thank you for your help.  Two questions:

1) Can you define "much larger number"?  I know you recently increased
this number from 10 to 1000, so should I increase it to 10,000?  100,000?

2) Is this a fix or a work-around?  If this is a work-around, is there a
fix in the works?  Can you explain the issue a bit, or if it's been
covered, can you point me to the explanation?  I'd just like to
understand what's going on.

Thanks,
Kris Kersey


David Chinner wrote:
> On Thu, Mar 06, 2008 at 04:31:27PM -0500, Kris Kersey wrote:
>> Hello,
>>
>> I'm working on a NAS product and we're currently having lock-ups that
>> seem to be hanging in XFS code.  We're running a NAS that has 1024 NFSD
>> threads accessing three RAID mounts.  All three mounts are running XFS
>> file systems.  Lately we've had random lockups on these boxes and I am
>> now running a kernel with KDB built-in.
>>
>> The lock-up takes the form of all NFSD threads in D state with one out
>> of three pdflush threads in D state.  The assumption can be made that
>> all NFSD threads are waiting on the one pdflush thread to complete.  So
>> two times now when an NAS has gotten in this state I have accessed KDB
>> and ran a stack trace on the pdflush thread.  Both times the thread was
>> stuck on xlog_grant_log_space+0xdb.
> 
> Try bumping XFS_TRANS_PUSH_AIL_RESTARTS to a much larger number and
> seeing if the problem goes away....
> 
> Alternatively, that restart hack is backed by a "watchdog" timeout
> in 2.6.25-rc1, so if that is the cause of the problem perhaps the
> latest -rcX kernel will prevent the hang?
> 
> BTW, you can get all the traces of D state threads through the sysrq
> interface, so you don't need to drop into kdb to get this.....
> 
> Cheers,
> 
> Dave.
