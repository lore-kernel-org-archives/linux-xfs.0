Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DED447F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:16:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 796DEAC010
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:16:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id chBgODHcOOpBgUhu
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:16:34 -0700 (PDT)
Message-ID: <515361B5.8050603@hardwarefreak.com>
Date: Wed, 27 Mar 2013 16:16:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
In-Reply-To: <515082C3.2000006@binghamton.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Hall <kdhall@binghamton.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 3/25/2013 12:00 PM, Dave Hall wrote:
> On 03/16/2013 03:21 AM, Dave Chinner wrote:
>> Using perf to profile the kernel while the cp -al workload is
>> running will tell use exactly where the CPU is being burnt. That
>> will confirm the analysis, or point us at some other issue that is
>> causing excessive CPU burn...
>>
> Dave,  which perf command(s) would you like me to run.  (I'm familiar
> with the concept behind this kind of tool, but I haven't worked with
> this one before).

I'll let Dave answer this one.

> Also, what would you like me to do with the xfs_db freesp output for 26
> agroups?

A pastebin link should be fine.  Only a couple of people will be looking
at it.  I don't see value in free space maps of 26 AGs being archived.

FWIW, it's probably best to reply-all instead of just to the list.
Sometimes posts get lost in the noise.  Not sure if that's the case
here, but it's been a couple of days with no response from Dave C, and
the answers to these questions are very short.  Thus I'm guessing he
missed your post, so I'm CC'ing him here.

-- 
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
