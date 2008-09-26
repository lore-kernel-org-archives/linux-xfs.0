Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:51:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8pItN029953
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:51:19 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1520B1210821
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:52:53 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id EjYAafGg5yunGVwL for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:52:53 -0700 (PDT)
Message-ID: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com>
In-Reply-To: <48DBFD42.6030307@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 26 Sep 2008 17:52:35 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Hi,

Ric Wheeler wrote:
> Christoph Hellwig wrote:
>> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>>
>>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>>> when the freezer accesses a frozen filesystem. And new ioctl
>>> to reset the timeout period is added to extend the timeout period.
>>> For example, the freezer resets the timeout period to 10 seconds every 5
>>> seconds.  In this approach, even if the freezer causes a deadlock by
>>> accessing the frozen filesystem, it will be solved by the timeout
>>> in 10 seconds and the freezer will be able to recognize that
>>> at the next reset of timeout period.
>>>
>>
>> And as with all previous posting I still fundamentally disagree about
>> the need of this functionality.  We don't need a timeout for freezing.
>
> I agree with Christoph here, I think that the timeout is unneeded.

I think that your concern is that the freezer cannot recognize the occurrence
of a timeout and it continues the backup process and the backup data is
corrupted finally.
If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
 be solved?
If so, I will implement it.

Cheers, Takashi
