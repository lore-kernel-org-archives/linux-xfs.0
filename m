Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAF097F63
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:35:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF99C304032
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 04:35:44 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id 5GTKO5dskDJIPMKA for
	<xfs@oss.sgi.com>; Mon, 02 Jun 2014 04:35:42 -0700 (PDT)
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20140602002822.GQ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
	<5507340.nVBP5LFtqn@wuerfel> <20140601002437.GL14410@dastard>
	<20140602002822.GQ14410@dastard>
Date: Mon, 02 Jun 2014 12:35:41 +0100
Message-Id: <1401708941.6065.51.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, geert@linux-m68k.org, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, lftan@altera.com, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com


On Mon, 2014-06-02 at 10:28 +1000, Dave Chinner wrote:

> 
> The 32 bit second counters in timestamps are too small to represent
> time beyond the unix epoch (jan 2038) correctly. Extend the on-disk
> format for a timestamp to include an 8-bit epoch counter so that we
> can extend time for up to 255 Unix epochs. This should be good for
> representing timestamps from 1970 to somewhere around 19,000 A.D....
> 

I assume you're using an 'epoch' variable and not simply using the
padding byte as an eight-bit prefix to the existing 32-bit counter
because the existing counter is signed ?

For long term sanity it might make more sense for the eight-bit value to
be a simple (sign-extended) prefix from 1970.

So if the feature bit is set it's a 40-bit signed time, which is good
for 1970 +/- 17400 years or so.

--
Roger





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
