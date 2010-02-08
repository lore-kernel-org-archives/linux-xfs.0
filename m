Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18AF9FZ123766 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 04:15:10 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E39A21CADBD3
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 02:16:20 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id YJpdCase28lZYDp5 for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 02:16:20 -0800 (PST)
Message-ID: <4B6FE47A.7070208@news-service.com>
Date: Mon, 08 Feb 2010 11:16:26 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31 xfs_fs_destroy_inode:
	cannot reclaim)
References: <89c4f90c0910270341r7833f490g60810f2817eb0950@mail.gmail.com>	<89c4f90c0910280519k759230c1r7b1586932ac792f7@mail.gmail.com>	<20091030101601.GA11142@infradead.org>	<4AF0422D.1070104@news-service.com>	<20091114162126.GB17658@infradead.org>	<4B0A8075.8080008@news-service.com>	<20091211115932.GA20632@infradead.org>	<4B3F9F88.9030307@news-service.com>	<20100107110446.GA13802@discord.disaster>	<4B45CFAC.4000607@news-service.com>	<20100108113114.GA8654@discord.disaster>	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
In-Reply-To: <4B6706CE.1020207@news-service.com>
Content-Type: multipart/mixed; boundary="------------020806050006070405000203"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020806050006070405000203
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

We had another crash on the same server last weekend. Looks the same to me.

Thanks for looking into this.

-Patrick

On 1-2-2010 17:52, Patrick Schreurs wrote:
> Hello Dave,
>
> I'm afraid we had another crash a few days ago. Have a look at the
> screenshot. Can you make anything out of it? This server is running
> 2.6.32.3 with your inode-reclaim patch applied and XFS_DEBUG still enabled.
>
> Thanks for looking into this.
>
> -Patrick
>
> On 15-1-2010 12:01, Patrick Schreurs wrote:
>> Hi Dave,
>>
>> I think it's save to consider this issue fixed. We have currently 9
>> servers operational with these patches and they have been stable so far.
>> For a 100% certainty we'll have to test/wait a little bit longer, but
>> considering the frequency of crashes we saw earlier i think it's save to
>> come to a conclusion.
>>
>> I hope these patches will be included in 2.6.33 and will be back ported
>> to at least 2.6.32.
>>
>> Many thanks to Dave and to Christoph for fixing this apparently rare and
>> seldom triggered condition.
>>
>> -Patrick
>>
>> Dave Chinner wrote:
>>> Hi Patrick,
>>>
>>> I've attached two compendium patches that will hopefully fix
>>> the inode reclaim problems you've been seeing - one is for 2.6.31,
>>> the other is for 2.6.32. I've cc'd this to the XFS list ѕo that
>>> anyone else who has been seeing crashes, assert failures and
>>> general nastiness around inode reclaim can test them as well.
>>>
>>> These are not final patches - there's a few changes that Christoph
>>> has picked up on during review - so there'll be another round of
>>> patches before checkins and -stable backports can be requested.
>>>
>>> I'm hoping that these patches fix your problem, because with them
>>> I can't make my machines fall over anymore....
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>>
>>> ------------------------------------------------------------------------
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--------------020806050006070405000203
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020806050006070405000203--
