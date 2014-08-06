Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11B367F87
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 05:05:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F30618F8035
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 03:05:38 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	0HwFjvCngxAtWeOb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 03:05:36 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id n3so8477140wiv.11
	for <xfs@oss.sgi.com>; Wed, 06 Aug 2014 03:05:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140804230721.GA20518@dastard>
References: <A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
Date: Wed, 6 Aug 2014 13:05:34 +0300
Message-ID: <CAOcd+r0_KjaZam8ocA1YtwF7jmCyh0+bXOY8nqiE3fsVn1gyiA@mail.gmail.com>
Subject: Re: use-after-free on log replay failure
From: Alex Lyakas <alex@zadarastorage.com>
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

Hi Dave,

On Tue, Aug 5, 2014 at 2:07 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Aug 04, 2014 at 02:00:05PM +0300, Alex Lyakas wrote:
>> Greetings,
>>
>> we had a log replay failure due to some errors that the underlying
>> block device returned:
>> [49133.801406] XFS (dm-95): metadata I/O error: block 0x270e8c180
>> ("xlog_recover_iodone") error 28 numblks 16
>> [49133.802495] XFS (dm-95): log mount/recovery failed: error 28
>> [49133.802644] XFS (dm-95): log mount failed
>
> #define ENOSPC          28      /* No space left on device */
>
> You're getting an ENOSPC as a metadata IO error during log recovery?
> Thin provisioning problem, perhaps,
Yes, it is a thin provisioning problem (which I already know the cause for).

> and the error is occurring on
> submission rather than completion? If so:
>
> 8d6c121 xfs: fix buffer use after free on IO error
I am not sure what do you mean by "submission rather than completion".
Do you mean that xfs_buf_ioapply_map() returns without submitting any
bios? In that case, no, bios are submitted to the block device, and it
fails them through a different context with ENOSPC error. I will still
try the patch you mentioned, because it also looks relevant to another
question I addressed to you earlier in:
http://oss.sgi.com/archives/xfs/2013-11/msg00648.html

Thanks,
Alex.


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
