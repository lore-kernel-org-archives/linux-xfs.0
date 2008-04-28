Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 06:00:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SCxc9H018017
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 05:59:46 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A2429BFDF3
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 06:00:17 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id HnGwzpdYbHEs2YKO for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 06:00:17 -0700 (PDT)
Message-Id: <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org>
In-Reply-To: <20080428103719.GA16030@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 28 Apr 2008 21:59:55 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

> On Mon, Apr 28, 2008 at 07:31:23PM +0900, Takashi Sato wrote:
>> + /* Initialize semaphore for freeze. */
>> + sema_init(&bdev->bd_freeze_sem, 1);
>
> The freezing process is already protected by bd_mount_sem, so I don't
> think there's need for another one.
>
[...]
>>  down(&bdev->bd_mount_sem);
>>  sb = get_super(bdev);
>
> I think the protection against double freezes would be better done by
> using a trylock on bd_mount_sem.

bd_mount_sem can protect against only freezes and cannot protect against
unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
bd_mount_sem might occur incorrectly.

> In fact after that it could be changed
> from a semaphore to a simple test_and_set_bit.

I will consider using test_and_set_bit.

>>  error = -ENOTTY;
>>  break;
>> +
>> + case FIFREEZE: {
>
> This would be better to split intot a small helper ala ioctl_fibmap()
>
>> + case FITHAW: {
>
> Same here.

OK.  I will split small helper functions.

Cheers, Takashi 
