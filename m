Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3D7929DF5
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 07:34:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A98E304066
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 05:34:46 -0700 (PDT)
Received: from mail-yk0-f178.google.com (mail-yk0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	taLC3JjlHDsPsoXj (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 05:34:44 -0700 (PDT)
Received: by ykcp133 with SMTP id p133so18799505ykc.1
	for <xfs@oss.sgi.com>; Wed, 08 Jul 2015 05:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150707233743.GZ7943@dastard>
References: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
	<20150707233743.GZ7943@dastard>
Date: Wed, 8 Jul 2015 20:34:43 +0800
Message-ID: <CA+eFSM2mSSW-BtP5-ArHREPu9sRRO3=J8acWJ-h_iZHfLPnhiw@mail.gmail.com>
Subject: Re: Possible memory allocation deadlock in kmem_alloc and hung task
	in xfs_log_commit_cil and xlog_cil_push
From: Gavin Guo <gavin.guo@canonical.com>
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
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,

On Wed, Jul 8, 2015 at 7:37 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jul 07, 2015 at 05:29:43PM +0800, Gavin Guo wrote:
>> Hi all,
>>
>> Recently, we observed that there is the error message in
>> Ubuntu-3.13.0-48.80:
>>
>> "XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)"
>>
>> repeatedly shows in the dmesg. Temporarily, our workaround is to tune the
>> parameters, such as, vfs_cache_pressure, min_free_kbytes, and dirty_ratio.
>>
>> And we also found that there are different error messages regarding the
>> hung tasks which happened in xfs_log_commit_cil and xlog_cil_push.
>>
>> The log is available at: http://paste.ubuntu.com/11835007/
>>
>> The following link seems the same problem we suffered:
>>
>> XFS hangs with XFS: possible memory allocation deadlock in kmem_alloc
>> http://oss.sgi.com/archives/xfs/2015-03/msg00172.html
>>
>> I read the mail and found that there might be some modification regarding
>> to move the memory allocation outside the ctx lock. And I also read the
>> latest patch from February of 2015 to see if there is any new change
>> about that. Unfortunately, I didn't find anything regarding the change (may
>> be I'm not familiar with the XFS, so didn't find the commit). If it's
>> possible for someone who is familiar with the code to point out the commits
>> related to the bug if already exist or any status about the plan.
>
> No commits - the approach I thought we might be able to take to
> avoid the problem didn't work out. I have another idea of how we
> might solve the problem, but I haven't ad a chance to prototype it
> yet.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Really thanks for your information, I'll keep watching out the status.

Thanks,
Gavin Guo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
