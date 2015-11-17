Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECCEF7F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 06:52:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE17E8F8040
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 04:52:24 -0800 (PST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id X0S0TW1ShWEf7n7I
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Nov 2015 04:52:23 -0800 (PST)
Received: by wmec201 with SMTP id c201so225855374wme.0
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 04:52:22 -0800 (PST)
Subject: Re: AIO read returns negative number for bytes read
References: <564883BD.8070607@scylladb.com>
	<x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <564B2303.7000902@scylladb.com>
Date: Tue, 17 Nov 2015 14:52:19 +0200
MIME-Version: 1.0
In-Reply-To: <x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com



On 11/16/2015 09:27 PM, Jeff Moyer wrote:
> Hi Avi,
>
> Avi Kivity <avi@scylladb.com> writes:
>
>> Due to a bug in my program, I initiated a read beyond
>> eof. Specifically, the file size is 13002 bytes and the read offset is
>> 13312 (0x3400).
>>
>> I would expect such a read to return 0 bytes read, but io_getevents
>> returns -310, which is suspiciously equal to (13002 - 13312).
>>
>> I attach a reproducer.
>>
>> 4.2.5-201.fc22.x86_64
>>
>> Are my expectations incorrect, or is this a bug in aio or xfs?
> Your expectations are correct.  The bug was introduced by commit
> 9fe55eea7e4b4 (Fix race when checking i_size on direct i/o read).  I've
> CC'd the patch author and linux-fsdevel.  I'm not sure what the right
> fix is, given that the size checks were removed from the vfs to fix some
> race condition.  Unfortunately, the commit message doesn't really do a
> good job of explaining the race.  In order to save others time, here is
> a good explanation of the problem that commit is meant to fix, along
> with a reproducer:
>    http://marc.info/?l=linux-fsdevel&m=138641356614458&w=2
>
> Thanks for the great bug report, and sorry I have no solution to
> proffer.
>

Thanks.  I will await a fix with interest.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
