Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BG85ID011014 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 11:08:05 -0500
Received: from shrek.krogh.cc (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D95D145F93D
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 09:15:19 -0700 (PDT)
Received: from shrek.krogh.cc (2605ds1-ynoe.0.fullrate.dk [90.184.12.24]) by
	cuda.sgi.com with ESMTP id qF2Dff0cgBbd9uQP for
	<xfs@oss.sgi.com>; Tue, 11 Oct 2011 09:15:19 -0700 (PDT)
Message-ID: <4E9469CC.4090507@krogh.cc>
Date: Tue, 11 Oct 2011 18:07:40 +0200
From: Jesper Krogh <jesper@krogh.cc>
MIME-Version: 1.0
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
	<20111011141338.GA11808@otto.nzcorp.net>
In-Reply-To: <20111011141338.GA11808@otto.nzcorp.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, aradford@gmail.com, xfs@oss.sgi.com

On 2011-10-11 16:13, Anders Ossowicki wrote:
> On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
>> This is core VM code, and operates purely on on-stack variables except
>> for the page cache radix tree nodes / pages.  So this either could be a
>> core VM bug that no one has noticed yet, or memory corruption.  Can you
>> run memtest86 on the box?
> Unfortunately not, as it is a production server. Pulling it out to memtest 256G
> properly would take too long. But it seems unlikely to me that it should be
> memory corruption. The machine has been running with the same (ecc) memory for
> more than a year and neither the service processor nor the kernel (according to
> dmesg) has caught anything before this. It would be a rare (though I admit not
> impossible) coincidence if we got catastrophic, undetected memory corruption a
> week after attaching a new raid controller with a new disk array.
A sidenote that Anders forgot.. the system was stable for very long time,
but on a 2.6.37 kernel. We upgraded to 2.6.38 to get the raid-controller
support and then it crashed.

Now we're trying to get the new hardware in the air on 2.6.37 with  
backpatched
megaraid driver for the RAID-controller.

-- 
Jesper

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
