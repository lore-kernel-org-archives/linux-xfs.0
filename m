Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66M4kTV171399 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 17:04:46 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98053179C4B7
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 15:04:44 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ZEZJ3cixhlRJkjtK
	for <xfs@oss.sgi.com>; Wed, 06 Jul 2011 15:04:44 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 54C066C119
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 17:04:44 -0500 (CDT)
Message-ID: <4E14DBFA.3040302@hardwarefreak.com>
Date: Wed, 06 Jul 2011 17:04:42 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS internal error (memory corruption)
References: <4E12A927.9020102@gmail.com>
	<20110705130932.GF1026@dastard>	<4E1313C1.6020309@gmail.com>
	<20110706040403.GW1026@dastard>	<20110706070756.GA25800@infradead.org>	<20110706072221.GZ1026@dastard>
	<20110706080505.GA2354@infradead.org>
In-Reply-To: <20110706080505.GA2354@infradead.org>
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

On 7/6/2011 3:05 AM, Christoph Hellwig wrote:
> On Wed, Jul 06, 2011 at 05:22:21PM +1000, Dave Chinner wrote:
>> Unless you have a good sized chunk of BBWC in front of your disks,
>> in which case internal logs are just as fast. In fact, internal logs
>> can are often faster in this case because an internal log on a 12
>> disk RAID6 array can sink a whole log more bandwidth than an external
>> log on a 2-disk RAID0 mirror.....
>>
>> At least, that's what my hardware tells me. ;)
> 
> Sure, a nice BBWC setup will give you good results.  But it's generally
> much more expensive than a simple setup with a raid5 or 6 and a mirror for
> the log device.

If you're talking consumer grade gear, well, sure, as there is no such
thing as a consumer hardware RAID card.  In the world of branded OEM
'enterprise' gear, you can get a BBWC RAID card solution for little more
than two drives.  Are most XFS admins running consumer or enterprise
grade gear?

LSI 9260-4i w/512MB BBWC     = $485 USD
Intel RES2SV24024P expander  = $280 USD
Total                        = $765 USD

2 HP 146GB 10kRPM SAS drives = $520 USD.

I threw in the expander as this LSI card is thoroughly limited with only
4 ports.  It's also cheaper going this route than buying the sister card
with 8 ports, yet with the same performance, and 12 more total ports.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
