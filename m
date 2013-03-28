Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8BE07CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 10:16:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8ED9E30407F
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 08:16:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id o0oDH8uRPXuHy5D6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 08:16:44 -0700 (PDT)
Message-ID: <51545EC1.5000707@oracle.com>
Date: Thu, 28 Mar 2013 23:16:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [ASSERT failure] transaction reservations changes bad?
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
	<513F0C07.1060000@oracle.com> <513F17F3.1010204@oracle.com>
	<20130312120545.GO21651@dastard> <51517506.1020906@oracle.com>
	<20130327020331.GO6369@dastard>
In-Reply-To: <20130327020331.GO6369@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/27/2013 10:03 AM, Dave Chinner wrote:
> On Tue, Mar 26, 2013 at 06:14:30PM +0800, Jeff Liu wrote:
>> On 03/12/2013 08:05 PM, Dave Chinner wrote:
>>> On Tue, Mar 12, 2013 at 07:56:35PM +0800, Jeff Liu wrote:
>>>> More info, 3.7.0 is the oldest kernel on my environment, I ran into the
>>>> same problem.
>>>
>>> Thanks for following up so quickly, Jeff. So the problem is that a
>>> new test is tripping over a bug that has been around for a while,
>>> not that it is a new regression.
>>>
>>> OK, so I'll expunge that from my testing for the moment as I don't
>>> ahve time to dig in and find out what the cause is right now. If
>>> anyone else wants to.... :)
>>
>> I did some further tests to nail down this issue, just posting the analysis result here,
>> it might be of some use when we revising it again.
>>
>> The disk is formated with Dave's previous comments, i.e.
>> mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/xxx
>>
>> First of all, looks this bug stayed in hiding for years since I can reproduce it between upstream
>> 3.0 to 3.9.0-rc3, the oldest kernel I have tried is 2.6.39 which has the same problem.
> 
> If you mount 2.6.39 with "-o nodelaylog", does the problem go away?
touch file is ok, but create directory still cause the assertion failure.
> 
>> IMHO, looks the major cause is related to the 'sunit' parameter,
>> since it would affect the log space unit calculations by
>> '2*log->l_mp->m_sb.sb_logsunit' at xlog_ticket_alloc().  However,
>> we don't include this factor into consideration at mkfs or mount
>> stage, should we take it into account?
> 
> That's what I suspected was the problem. i.e. that the log was too
> small for the given configuration.
> 
> The question is this: how much space do we need to reserve. I'm
> thinking a minimum of 4*lsu - 2*lsu for the existing CIL context, and
> another 2*lsu for any queued ticket waiting for space to come
> available.
> 
> I haven't thought a lot about it, though, and I have a little demon
> sitting on my shoulder nagging me about specific thresholds whether
> they need to play a part in this. e.g. no single transaction can be
> larger than half the log; AIL push thresholds of 25% of log space;
> background CIL commit threshold of 12.5% of the log...
> 
> So it's not immediately clear to me how much bigger the log needs to
> be...
I still need some time to understand the space reservation strategy to
figure them out. :(

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
