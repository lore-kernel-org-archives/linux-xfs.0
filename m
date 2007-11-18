Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Nov 2007 15:13:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAINDVsl032445
	for <xfs@oss.sgi.com>; Sun, 18 Nov 2007 15:13:35 -0800
Message-ID: <4740C727.4050008@sgi.com>
Date: Mon, 19 Nov 2007 10:13:43 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com> <473D32D9.2020500@sgi.com> <473D36AC.7040507@sgi.com>
In-Reply-To: <473D36AC.7040507@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Timothy Shimmin wrote:
> Vlad Apostolov wrote:
>>
>> When the XFS parent pointers feature is released we would need to find
>> out to update the EA to point to the new inode parent directory. This 
>> may
>> not be that easy though.
>>
> Really?
> Apart from the swapping of extents, reno uses standard calls doesn't it,
> in which case any movement of inodes will have the parent pointers
> updated by the normal vnode ops (e.g. mkdir, rename) in the kernel.
>
> --Tim
When a 64 bits parent inode directory is changed to 32 bits inode,
I couldn't see code that would change parent pointer EA of the
children to point to the new 32 bits parent. Please correct me if
I missed something.

Regards,
Vlad
