Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 03:56:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QAulKi021981
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:56:47 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0301F984422
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:58:22 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id JCykCMn1LgK8zg2V for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:58:22 -0700 (PDT)
Message-ID: <48DCC043.1020207@redhat.com>
Date: Fri, 26 Sep 2008 06:58:11 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
In-Reply-To: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Takashi Sato wrote:
> Hi,
>
> Ric Wheeler wrote:
>> Christoph Hellwig wrote:
>>> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>>>
>>>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>>>> when the freezer accesses a frozen filesystem. And new ioctl
>>>> to reset the timeout period is added to extend the timeout period.
>>>> For example, the freezer resets the timeout period to 10 seconds 
>>>> every 5
>>>> seconds.  In this approach, even if the freezer causes a deadlock by
>>>> accessing the frozen filesystem, it will be solved by the timeout
>>>> in 10 seconds and the freezer will be able to recognize that
>>>> at the next reset of timeout period.
>>>>
>>>
>>> And as with all previous posting I still fundamentally disagree about
>>> the need of this functionality.  We don't need a timeout for freezing.
>>
>> I agree with Christoph here, I think that the timeout is unneeded.
>
> I think that your concern is that the freezer cannot recognize the 
> occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.
> If the freezer can recognize it by the unfreeze ioctl's errono, will 
> your concern
> be solved?
> If so, I will implement it.
>
> Cheers, Takashi
>
I think that is certainly part a big part of my concern.

Also note that the timeout seems to be quite low relative to say the 
standard timeout for a SCSI device (30 seconds worst case).

In general, I am quite supportive of the patch series and think that 
this is a great addition.

Thanks!

Ric
