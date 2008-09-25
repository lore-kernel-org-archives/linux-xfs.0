Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 14:05:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PL57Dw013784
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:05:07 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3843D1288275
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:06:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id lSlB368S82QrQcyT for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:06:40 -0700 (PDT)
Message-ID: <48DBFD42.6030307@redhat.com>
Date: Thu, 25 Sep 2008 17:06:10 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org>
In-Reply-To: <20080908171119.GB22521@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>   
>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>> when the freezer accesses a frozen filesystem. And new ioctl
>> to reset the timeout period is added to extend the timeout period.
>> For example, the freezer resets the timeout period to 10 seconds every 5
>> seconds.  In this approach, even if the freezer causes a deadlock by
>> accessing the frozen filesystem, it will be solved by the timeout
>> in 10 seconds and the freezer will be able to recognize that
>> at the next reset of timeout period.
>>     
>
> And as with all previous posting I still fundamentally disagree about
> the need of this functionality.  We don't need a timeout for freezing.
>
>   

I agree with Christoph here, I think that the timeout is unneeded.

Regards,

Ric
