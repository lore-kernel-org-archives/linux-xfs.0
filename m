Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RE3mjX172879 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 09:03:48 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7gxzAC16rWTTTPHQ
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 07:03:47 -0700 (PDT)
Message-ID: <4F9AA743.7020709@hardwarefreak.com>
Date: Fri, 27 Apr 2012 09:03:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<1335363423.4586.431.camel@montana.filmlight.ltd.uk>
	<CAAxjCEyni5=OG=AU+UMO-jfnP3q6MUanki2Nk7p=_mxdqveqwA@mail.gmail.com>
In-Reply-To: <CAAxjCEyni5=OG=AU+UMO-jfnP3q6MUanki2Nk7p=_mxdqveqwA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, Linux fs XFS <xfs@oss.sgi.com>

On 4/25/2012 11:23 AM, Stefan Ring wrote:
>> Result (seems reasonably consistent):
>>
>> Operations performed:  0 Read, 127458 Write, 0 Other = 127458 Total
>> Read 0b  Written 995.77Mb  Total transferred 995.77Mb  (66.337Mb/sec)
>>  8491.11 Requests/sec executed]
> 
> Holy moly, this is an entirely different game you're playing here! I
> suppose that you're using a battery backed write cache?

He's running a 20 data spindle RAID60, across two decent hardware RAID
cards each with 512MB write cache, so of course it's going to be much
faster than your 4 data spindle RAID6, even with slightly slower spindles.

Note that 8x 15K drives in RAID10 on your P410i should slightly surpass
Roger's RAID60 performance, ~70MB/s vs 66MB/s.  3x fewer drives for
roughly equal performance, but obviously less capacity.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
