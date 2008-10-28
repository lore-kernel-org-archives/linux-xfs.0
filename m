Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 05:34:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SCYEH6024631
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 05:34:15 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2BCB5517F2
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 05:34:14 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id ixDPZnr9AvVjq1mv for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 05:34:14 -0700 (PDT)
Message-ID: <F69DB5CD5C544C428676CFA36F31FF26@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20081027215855t-sato@mail.jp.nec.com> <20081027231533.96c42a78.akpm@linux-foundation.org>
In-Reply-To: <20081027231533.96c42a78.akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Date: Tue, 28 Oct 2008 21:33:59 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@googlemail.com, axboe@kernel.dk, linux-kernel@vger.kernel.org

Hi,

>> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
>> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>>  {
>> + int error = 0;
>> +
>> + mutex_lock(&bdev->bd_fsfreeze_mutex);
>> + if (!bdev->bd_fsfreeze_count) {
>> + mutex_unlock(&bdev->bd_fsfreeze_mutex);
>> + return -EINVAL;
> 
> This would be a programming error, yes?

This is not a kernel programming error but a user's.
thaw_bdev() is called via the unfreeze ioctl.  If a user calls the unfreeze
ioctl for an unfrozen filesystem, this error will be returned.
So a WARN_ON isn't needed.

> If so, a WARN_ON is more appropriate than a silent runtime error.
> 
>> + }

Cheers, Takashi
