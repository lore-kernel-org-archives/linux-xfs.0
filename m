Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q67S44201724 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 01:07:28 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6F871BC719D
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 23:09:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CddRv2uUGzsV0Wq3
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 23:09:10 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 8ABC86C3ED
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 01:09:09 -0500 (CDT)
Message-ID: <4BAC4F84.9010005@hardwarefreak.com>
Date: Fri, 26 Mar 2010 01:09:08 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 128TB filesystem limit?
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>	<20100325235433.GM3335@dastard>	<alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>	<20100326003511.GN3335@dastard>	<alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>	<4BAC3990.30403@sandeen.net>
	<alpine.DEB.2.00.1003252152350.16138@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1003252152350.16138@asgard.lang.hm>
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
To: xfs@oss.sgi.com

david@lang.hm put forth on 3/25/2010 11:56 PM:

>>> the next fun thing is figuring out what sort of stride, etc parameters I
>>> should have used for this filesystem.
>>
>> mkfs.xfs should suss that out for you automatically based on talking
>> to md;
>> of course you'd want to configure md to line up well with the hardware
>> alignment.
> 
> in this case md thinks it's working with 10 12.8TB drives, I really
> doubt that it's going to do the right thing.
> 
> I'm not exactly sure what the right thing is in this case. the hardware
> raid is useing 64K chunks across 16 drives (so 14 * 64K worth of data
> per stripe), but there are 10 of these stripes before you get back to
> hitting the same drive again.

It would be helpful if you told us the primary application(s) that will be
writing to this large multi-level RAID setup.  Primarily large files or
small?  Database?  ??

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
