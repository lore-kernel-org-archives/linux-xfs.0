Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7CB97F47
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 11:18:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7E6A8F8039
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 09:18:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ldo6vJ5Kmyp0BW7H for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 09:18:17 -0700 (PDT)
Message-ID: <5422EECA.10301@sandeen.net>
Date: Wed, 24 Sep 2014 11:18:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>
	<54222763.40107@sandeen.net>	<5422285B.6010306@evermeet.cx>
	<542234F6.4080000@hardwarefreak.com> <5422376D.3000204@evermeet.cx>
	<542243E6.1040302@hardwarefreak.com> <5422E912.1000708@evermeet.cx>
In-Reply-To: <5422E912.1000708@evermeet.cx>
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
To: Helmut Tessarek <tessarek@evermeet.cx>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 9/24/14 10:53 AM, Helmut Tessarek wrote:
> On 2014-09-24 0:09, Stan Hoeppner wrote:
>> If you create any striped arrays, especially parity arrays, with md make
>> sure to manually specify chunk size and match it to your workload.  The
>> current default is 512KB.  This is too large for a great many workloads,
>> specifically those that are metadata heavy or manipulate many small
>> files.  512KB wastes space and with parity arrays causes RMW, hammering
>> throughput and increasing latency.
> 
> Thanks again for the valueable information.
> 
> I used to work with databases on storage subsystems, so placing GBs of
> database containers for tableapaces on arrays with a larger stripe size
> was actually beneficial.
> For log files and other data I usually used different cache settings and
> strip sizes.
> 
> So how does this work with SW RAID?
> 
> Does the XFS chunk size equal the amount of data touched by a single r/w
> operation?

It has more to do with where allocations start, so that allocations
don't cross stripe boundaries if possible.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
