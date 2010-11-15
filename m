Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAF48Mxl021906 for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 22:08:22 -0600
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68F0813BBAF8
	for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 20:09:52 -0800 (PST)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id gwgSnnfxJu7vFveL for
	<xfs@oss.sgi.com>; Sun, 14 Nov 2010 20:09:52 -0800 (PST)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1082)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20101114110559.GB22876@dastard>
Date: Sun, 14 Nov 2010 20:09:35 -0800
Message-Id: <87214B07-148B-4580-84F2-792266DE2C55@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCD3CE6.8060407@hardwarefreak.com>
	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
	<201011121422.28993@zmi.at>
	<BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
	<20101114110559.GB22876@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On Nov 14, 2010, at 3:05 AM, Dave Chinner wrote:

> On Fri, Nov 12, 2010 at 03:01:47PM -0800, Eli Morris wrote:
>> 
>> On Nov 12, 2010, at 5:22 AM, Michael Monnerie wrote:
>> 
>>> On Freitag, 12. November 2010 Eli Morris wrote:
>>>> The filesystem must be pointing to files that don't exist, or
>>>> something like that. Is there a way to fix that, to say, remove
>>>> files that don't exist anymore, sort of command? I thought that
>>>> xfs_repair would do that, but apparently not in this case.
>>> 
>>> The filesystem is not optimized for "I replace part of the disk contents 
>>> with zeroes" and find that errors. You will have to look in each file if 
>>> it's contents are still valid, or maybe bogus.
> ....
>> Let me see if I can give you and everyone else a little more
>> information and clarify this problem somewhat. And if there is
>> nothing practical that can be done, then OK. What I am looking for
>> is the best PRACTICAL outcome here given our resources and if
>> anyone has an idea that might be helpful, that would be awesome. I
>> put practical in caps, because that is the rub in all this. We
>> could send X to a data recovery service, but there is no money for
>> that. We could do Y, but if it takes a couple of months to
>> accomplish, it might be better to do Z, even though Z is riskier
>> or deletes some amount of data, because it is cheap and only takes
>> one day to do..
> 
> Well, the best thing you can do is work out where in the block
> device the zeroed range was, and then walk the entire filesystem
> running xfs_bmap on every file to work out where their physical
> extents are. i.e. build a physical block map of the good and bad
> regions, then find what files have bits in the bad regions.
> I've seen this done before with a perl script, and shouldn't take
> more than a few hours to write and run....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com


Thanks a lot Dave,

I think that's a really good suggestion. I was thinking along those same lines myself. I understand how I would find where the files are located using xfs_bmap. Do you know which command I would use to find where the 'bad region' is located, so I can compare them to the file locations?

 

thanks again,

Eli


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
