Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 16:12:55 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5TNCmIF031429
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:12:49 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F085184E8AC
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:13:49 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id uEeFRjBwiIaq8Va4 for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:13:49 -0700 (PDT)
Message-Id: <C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080624160056t-sato@mail.jp.nec.com><20080624150925.765155f0.akpm@linux-foundation.org><7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp> <20080627115727.149dcb2e.akpm@linux-foundation.org>
In-Reply-To: <20080627115727.149dcb2e.akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 30 Jun 2008 08:13:07 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Hi,

>> >>  case XFS_FSOP_GOING_FLAGS_DEFAULT: {
>> >> - struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
>> >> + struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
>> >
>> > Using NULL here is clearer and will, I expect, avoid a sparse warning.
>> 
>> I checked it but I couldn't find a sparse warning in xfs_fsops.c.
>> Can you tell me how to use NULL?
> 
> struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, NULL);
> 
> :)
> 
> It's much better to use NULL here rather than literal zero because the
> reader of this code can then say "ah-hah, we're passing in a pointer". 
> Whereas plain old "0" could be a pointer or a scalar.

The second argument's type of freeze_bdev() is "long", not pointer as below.
struct super_block *freeze_bdev(struct block_device *, long timeout_msec);

So "0" is reasonable, isn't it?

> We should always use NULL to represent a null pointer in the kernel. 
> The one acceptable exception is when testing for nullness:
> 
> if (ptr1)
> if (!ptr2)
> 
> Often people will use
> 
> if (ptr1 != NULL)
> if (ptr2 == NULL)
> 
> in this case as well.  (I prefer the shorter version personally, but
> either is OK).
