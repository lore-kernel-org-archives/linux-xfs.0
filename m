Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HCeHea260256 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 07:40:17 -0500
Received: from shrek.krogh.cc (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5384E1C90B53
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 05:40:15 -0700 (PDT)
Received: from shrek.krogh.cc (2605ds1-ynoe.0.fullrate.dk [90.184.12.24]) by
	cuda.sgi.com with ESMTP id cRylKqs50wAZOASu for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 05:40:15 -0700 (PDT)
Message-ID: <e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
In-Reply-To: <20111011133448.GA10692@infradead.org>
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
Date: Mon, 17 Oct 2011 14:40:07 +0200 (CEST)
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
From: jesper@krogh.cc
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: aradford@gmail.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> On Tue, Oct 11, 2011 at 11:17:57AM +0200, Anders Ossowicki wrote:
>> Pid: 27512, comm: flush-8:32 Tainted: G        W   2.6.38.8 #1 Dell Inc.
>>  PowerEdge R815/04Y8PT
>> RIP: 0010:[<ffffffff810f8d71>]  [<ffffffff810f8d71>]
>> find_get_pages+0x61/0x110
>
> This is core VM code, and operates purely on on-stack variables except
> for the page cache radix tree nodes / pages.  So this either could be a
> core VM bug that no one has noticed yet, or memory corruption.  Can you
> run memtest86 on the box?

Over the weekend, we have run memtest for 4 hours (50% of the complete
tests according to memtest) and it didnt find anything.

We've also backpatched the raid-driver into 2.6.37 and the problem continued,
so it seems to be related to the driver and/or combinations with hardware.

Jesper
-- 
Jesper

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
