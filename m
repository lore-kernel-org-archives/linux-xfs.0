Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 05:16:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m32CGRm6007138
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 05:16:28 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA301069942
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 05:17:02 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id 0QHbnAYc1hOOM8JM for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 05:17:02 -0700 (PDT)
Message-Id: <3AF481B79787436E8E20D6C597D5DD1C@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080328180736t-sato@mail.jp.nec.com> <20080331000057.GI108924158@sgi.com> <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp> <20080402062147.GH103491721@sgi.com>
In-Reply-To: <20080402062147.GH103491721@sgi.com>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Date: Wed, 2 Apr 2008 21:16:59 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Hi,

David Chinner wrote:
>> Exactly my timeout feature is only for an application, not for
>> freeze_bdev().
>> I think it is needed for the situation we can't unfreeze from userspace.
>> (e.g. Freezing the root filesystem)
>
> Ummm - why can't you unfreeze the root fs from userspace? freezing
> only prevents modification to the filesystem. A frozen filesystem is
> effectively a read-only filesystem...
>
> On XFS:
>
> # xfs_freeze -f /
> # echo $?
> 0
> # xfs_freeze -u /
> # echo $?
> 0

Yes. If we have already logged in, we can unfreeze as above.
But if not, we cannot log in and unfreeze because the modification
of /var/log/wtmp is blocked in the log-in procedure.
The timeout feature will work in such case.

Cheers, Takashi
