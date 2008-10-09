Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 03:11:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99AAvtT031189
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 03:10:57 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D98F13C6FCE
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 03:12:35 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id dZgHApEPYDa6A6eo for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 03:12:35 -0700 (PDT)
Message-ID: <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org> <48E0EA0B.7000701@sandeen.net>
In-Reply-To: <48E0EA0B.7000701@sandeen.net>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 9 Oct 2008 19:12:17 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Hi,

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Mon, Sep 29, 2008 at 09:36:04AM -0500, Eric Sandeen wrote:
>>> Christoph Hellwig wrote:
>>>> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
>>>>> I think that your concern is that the freezer cannot recognize the occurrence
>>>>> of a timeout and it continues the backup process and the backup data is
>>>>> corrupted finally.
>>>> What timeout should happen?  the freeze ioctl must not return until the
>>>> filesystem is a clean state and all writes are blocked.
>>> The suggestion was that *UN*freeze would return ETIMEDOUT if the
>>> filesystem had already unfrozen itself, I think.  That way you know that
>>> the snapshot you just took is worthless, at least.
>>
>> But why would the filesystem every unfreeze itself?  That defeats the
>> whole point of freezing it.
>
> I agree.  Was just trying to clarify the above point.
>
> But there have been what, 12 submissions now, with the unfreeze timeout
> in place so it's a persistent theme ;)
>
> Perhaps a demonstration of just how easy (or not easy) it is to deadlock
> a filesystem by freezing the root might be in order, at least.
>
> And even if it is relatively easy, I still maintain that it is the
> administrator's role to not inflict damage on the machine being
> administered.  There are a lot of potentially dangerous tools at root's
> disposal; why this particular one needs a nanny I'm still not quite sure.

I think we need the timeout for the case someone dirties so much data
with mmap, hence the freeze process is swapped out and cannot unfreeze.

Cheers, Takashi
