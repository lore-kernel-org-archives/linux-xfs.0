Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7C3E7F5A
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 14:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56026AC008
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 12:06:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SpUhdk0qfeuYybix
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 12:06:46 -0700 (PDT)
Message-ID: <54231653.7050600@hardwarefreak.com>
Date: Wed, 24 Sep 2014 14:06:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>	<54222763.40107@sandeen.net>	<5422285B.6010306@evermeet.cx>	<542234F6.4080000@hardwarefreak.com>
	<5422376D.3000204@evermeet.cx>	<542243E6.1040302@hardwarefreak.com>
	<5422E912.1000708@evermeet.cx>
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
To: Helmut Tessarek <tessarek@evermeet.cx>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On 09/24/2014 10:53 AM, Helmut Tessarek wrote:
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

No.  The XFS stripe unit size (chunk size) must/should equal the
underlying RAID stripe unit size (chunk).  As Eric said, all this does
is help XFS align allocations to the underlying RAID geometry in an
attempt to get more full chunk/stripe writes on the disks.

Note we both said allocation.  The XFS sunit/swidth settings have no
affect with file appends or writing into preallocated files.

> I'm asking because data is usually written in page/extent sizes for
> databases. Even if I have a container with 50GB, I might only have to
> read/write a 4k page.

db operations are going to be append or modify-in-place.  Neither will
benefit from aligning XFS to the RAID geometry.  Appending the db logs
is also not allocation.  So in practical terms, you simply would not use
the "-d" striping options during mkfs.xfs.  Use the defaults.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
