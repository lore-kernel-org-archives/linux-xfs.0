Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 12:13:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UJDp4p015058
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 12:13:53 -0700
Message-ID: <46D716FC.9030905@sandeen.net>
Date: Thu, 30 Aug 2007 14:14:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ZFS, XFS, and EXT4 compared
References: <1188454611.23311.13.camel@toonses.gghcwest.com>	 <1188457666.24970.94.camel@edge.yarra.acx>	 <20070830132002.GA4086@infradead.org>  <46D71318.2050604@sandeen.net> <1188500941.8980.20.camel@toonses.gghcwest.com>
In-Reply-To: <1188500941.8980.20.camel@toonses.gghcwest.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Jeffrey W. Baker wrote:
> On Thu, 2007-08-30 at 13:57 -0500, Eric Sandeen wrote:

>> barrier seems to hurt badly on xfs, too.  Note: barrier is off by
>> default on ext[34], so if you want apples to apples there, you need to
>> change one or the other filesystem's mount options.  If your write cache
>> is safe (battery backed?) you may as well turn barriers off.  I'm not
>> sure offhand who will react more poorly to an evaporating write cache
>> (with no barriers), ext4 or xfs...
> 
> I didn't compare the safety of the three filesystems, 

Understood

> but I did have
> disk caches disabled 

Oh, so for the SW raid tests the individual disks had no write cache?f

> and only battery-backed caches enabled.  Do you
> need barriers without volatile caches?

As far as I understand it, then nope, you don't need it, and you're
hurting performance with it.

-Eric
