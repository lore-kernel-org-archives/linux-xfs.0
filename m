Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Sep 2006 19:07:49 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8D27LVw025631
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 19:07:32 -0700
Received: from omx2.sgi.com ([198.149.32.25])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k8D26anx006434
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 21:06:36 -0500
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id k8D4f984014465
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 21:41:11 -0700
Message-ID: <450758E2.30408@sgi.com>
Date: Wed, 13 Sep 2006 11:03:30 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Mounting IRIX disk on Linux
References: <45053B2D.50203@crc.dk> <4505712E.5070801@oss.sgi.com> <4506529F.9030109@crc.dk> <4506831A.3000001@sgi.com> <4506D66D.8060206@sandeen.net>
In-Reply-To: <4506D66D.8060206@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mogens Kjaer <mk@crc.dk>, linux-xfs@oss.sgi.com

Eric Sandeen wrote:
> Timothy Shimmin wrote:
> 
>>> This gives me:
>>>
>>
>>> versionnum = 0x1084
>>
>> #define XFS_SB_VERSION_DIRV2BIT         0x2000
>>
>> So, yes it doesn't look like you have v2 directories
>> and there is no support for it in Linux.
> 
> Hm, the kernel should probably print something more helpful in that case :)
> 
> -Eric

Good point.
And indeed it should have:

xfs_mount.c/xfs_mount_validate_sb()
...
         /*
          * Version 1 directory format has never worked on Linux.
          */
         if (unlikely(!XFS_SB_VERSION_HASDIRV2(sbp))) {
                 xfs_fs_mount_cmn_err(flags,
                         "file system using version 1 directory format");
                 return XFS_ERROR(ENOSYS);
         }

Did this not happen, Mogens?

--Tim
