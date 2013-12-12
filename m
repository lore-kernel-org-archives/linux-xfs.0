Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A58B67F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 18:20:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34A7DAC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:20:00 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id eYy64dxzumhlNc9K
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:19:54 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131211185746.GA11861@redhat.com>
Date: Wed, 11 Dec 2013 17:19:52 -0700
Message-Id: <2A0A637F-7ED6-4743-8791-E57E22306139@colorremedies.com>
References: <20131211172725.GA4606@redhat.com>
	<68DD7157-6ACE-4548-A466-C1EBD31B6DEB@colorremedies.com>
	<20131211185746.GA11861@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: xfs@oss.sgi.com


On Dec 11, 2013, at 11:57 AM, Dave Jones <davej@redhat.com> wrote:

> On Wed, Dec 11, 2013 at 11:52:51AM -0700, Chris Murphy wrote:
>> 
>> On Dec 11, 2013, at 10:27 AM, Dave Jones <davej@redhat.com> wrote:
>>> 
>>> Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)
>> 
>> It may reveal nothing useful, but please report the results from 'smartctl -x /dev/sda' and if not found install smartmontools package.
> 
> 
> I meant it when I said 'old' and 'crappy'.
> It doesn't even support the interesting SMART commands.


Oh well, was worth a shot. The Available_Reservd_Space and Media_Wearout_Indicator could be useful, but I don't know how trustworthy they are when both say they're at 100 which is normally where these values start. Yet they have high, and without reference, meaningless, raw values. The Available_Reservd_Space value is currently 100 but its worst value was 48 which is sorta interesting that it dipped down at one point. That seems to imply it gave up some reserved sectors. I'd expect that once replaced that'd be it, and this value should only go down.

I suspect we've only just begun to see the myriad ways in which SSDs could fail. I ran across this article earlier today:
http://techreport.com/review/25681/the-ssd-endurance-experiment-testing-data-retention-at-300tb

What I thought was eye opening was a hashed file failing multiple times in a row with *different* hash values, being allowed to rest unpowered for five days and then passing. Eeek. Talk about a great setup for a lot of weird transient problems with that kind of reversal. What I can't tell is if there were read errors report to the SATA driver, or if (different) bad data from a particular page was sent to the driver.

Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
