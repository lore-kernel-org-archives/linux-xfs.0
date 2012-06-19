Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JLbUpK169786 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 16:37:30 -0500
Received: from blade3.isti.cnr.it (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id EZ3Ge88pTImImxk5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 14:37:28 -0700 (PDT)
Received: from [10.0.55.100] ([94.36.116.228])
	by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
	with ESMTPSA id <01OGVZ7QWSMYODSON8@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Tue, 19 Jun 2012 23:37:19 +0200 (MEST)
Date: Tue, 19 Jun 2012 23:37:54 +0200
From: Spelic <spelic@shiftmail.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
In-reply-to: <20120619200631.GL25389@dastard>
Message-id: <4FE0F132.2080207@shiftmail.org>
MIME-version: 1.0
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
	<alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
	<20120619133041.GB6811@redhat.com> <4FE0840F.2050704@shiftmail.org>
	<20120619144413.GA7225@redhat.com> <20120619184858.GA8841@redhat.com>
	<20120619200631.GL25389@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On 06/19/12 22:06, Dave Chinner wrote:
> On Tue, Jun 19, 2012 at 02:48:59PM -0400, Mike Snitzer wrote:
>> On Tue, Jun 19 2012 at 10:44am -0400,
>> Mike Snitzer<snitzer@redhat.com>  wrote:
>>
>>> On Tue, Jun 19 2012 at  9:52am -0400,
>>> Spelic<spelic@shiftmail.org>  wrote:
>>>
>>>> I do not know what is the mechanism for which xfs cannot unmap
>>>> blocks from dm-thin, but it really can't.
>>>> If anyone has dm-thin installed he can try. This is 100%
>>>> reproducible for me.
>>> I was initially surprised by this considering the thinp-test-suite does
>>> test a compilebench workload against xfs and ext4 using online discard
>>> (-o discard).
>>>
>>> But I just modified that test to use a thin-pool with 'ignore_discard'
>>> and the test still passed on both ext4 and xfs.
>>>
>>> So there is more work needed in the thinp-test-suite to use blktrace
>>> hooks to verify that discards are occuring when the compilebench
>>> generated files are removed.
>>>
>>> I'll work through that and report back.
>> blktrace shows discards for both xfs and ext4.
>>
>> But in general xfs is issuing discards with much smaller extents than
>> ext4 does, e.g.:
> THat's normal when you use -o discard - XFS sends extremely
> fine-grained discards as the have to be issued during the checkpoint
> commit that frees the extent. Hence they can't be aggregated like is
> done in ext4.
>
> As it is, no-one really should be using -o discard - it is extremely
> inefficient compared to a background fstrim run given that discards
> are unqueued, blocking IOs. It's just a bad idea until the lower
> layers get fixed to allow asynchronous, vectored discards and SATA
> supports queued discards...
>

Could it be that the thin blocksize is larger than the discard 
granularity by xfs so nothing ever gets unmapped?
I have tried thin pools with the default blocksize (64k afair with lvm2) 
and 1MB.
HOWEVER I also have tried fstrim on xfs, and that is also not capable to 
unmap things from the dm-thin.
What is the granularity with fstrim in xfs?
Sorry I can't access the machine right now; maybe tomorrow, or in the 
weekend.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
