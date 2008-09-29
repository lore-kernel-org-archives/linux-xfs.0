Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 04:10:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TBAQHA001599
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 04:10:26 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D997799FB10
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 04:12:01 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id OwpCAj0oEnXjZUNT for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 04:12:01 -0700 (PDT)
Message-ID: <CB0D828755EF47B78DA10F72C80BC436@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <48DCC043.1020207@redhat.com>
In-Reply-To: <48DCC043.1020207@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 20:11:41 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Hi Ric and Christoph,

Ric Wheeler wrote:
>>>> And as with all previous posting I still fundamentally disagree about
>>>> the need of this functionality.  We don't need a timeout for freezing.
>>>
>>> I agree with Christoph here, I think that the timeout is unneeded.
>>
>> I think that your concern is that the freezer cannot recognize the occurrence
>> of a timeout and it continues the backup process and the backup data is
>> corrupted finally.
>> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>> be solved?
>> If so, I will implement it.
>>
>> Cheers, Takashi
>>
> I think that is certainly part a big part of my concern.
>
> Also note that the timeout seems to be quite low relative to say the standard timeout for a SCSI 
> device (30 seconds worst case).
>
> In general, I am quite supportive of the patch series and think that this is a great addition.

Thank you for your comments.
Christoph, do you have any comments about this solution?

If it's OK, I will change the freeze patch so that the unfreeze ioctl sets
ETIMEDOUT to errno when the timeout occurs.

Cheers, Takashi
