Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88BF07F4E
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 19:41:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F9058F8039
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 17:41:45 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id dLPqulljWX5k39Ze
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 17:41:41 -0800 (PST)
Message-ID: <52B64351.4040806@hardwarefreak.com>
Date: Sat, 21 Dec 2013 19:41:37 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
	memory footprint
References: <52B102FF.8040404@pzystorm.de>	<52B2FE9E.50307@hardwarefreak.com>	<52B41B67.9030308@pzystorm.de>	<201312202343.47895.arekm@maven.pl>
	<52B57912.5080000@hardwarefreak.com>
In-Reply-To: <52B57912.5080000@hardwarefreak.com>
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
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/21/2013 5:18 AM, Stan Hoeppner wrote:
...
> For example, I assisted a user with 5x Intel SSDs back in January and
> his system required 4096, or 80MB of RAM for stripe cache, to reach
> maximum write throughput of the devices.  This yielded 600MB/s or 60%
> greater throughput than 2048, or 40MB RAM for cache.  In his case 60MB
> more RAM than the default was well worth the increase as the machine was
> an iSCSI target server with 8GB RAM.

Correction here.  I said above that 80MB was 60MB greater than the
default for his 5 drives.  This should have said 75MB greater than the
default which is 1MB per member device, or 5MB for 5 drives.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
