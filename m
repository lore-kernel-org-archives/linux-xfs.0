Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 165867F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 17:30:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFF24304064
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 15:30:40 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 99taoVq9DHHpJ91d (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 15:30:38 -0700 (PDT)
Date: Mon, 2 Jun 2014 18:29:54 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602222954.GA29690@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<20140602153124.GH30598@thunk.org> <538CB085.5000502@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538CB085.5000502@zytor.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Chuck Lever <chuck.lever@oracle.com>, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On Mon, Jun 02, 2014 at 10:12:37AM -0700, H. Peter Anvin wrote:
> > It would be problematic for time(2) or gettimeofday(2) to return
> > TIME_UNDEFINED, since there are programs that care about time ticking
> > forward, but I could imagine a new interface which would be permitted
> > to return a flag indicating that we don't know the current time
> > (because the CMOS battery had run down, etc.) so instead we're going
> > to be counting the number of seconds since the system was booted.
> 
> This assumes that we actually know that that is the case, which may be
> an aggressive assumption.

We won't know if the RTC clock is wrong, true --- but the kernel will
know if (a) the hardware doesn't have RTC clock at all, or if (b) the
RTC clock is ticking some time that can't be encoded using the current
time_t type.  So in that case, the fallback would be to be for the
kernel to tick starting with time_t == 0 when the system is initially
booted, and the "time indefinite flag" would be set.

Now assume that we have a new system call, gettimestampofday(2), which
returns a new timestamp structure which has a 64-bit ts_sec field, the
ts_nsec field (ala struct timespec), and a ts_flags field, where the
kernel could signal things like "time invalid", or "time can't be
encoded in the legacy time_t type", or "I'm not sure if the time is
correct" --- i.e., because the RTC battery isn't working.

Not all hardware might be able to support the last, of course, but if
the battery is low, or the system has been exposed to very low
temperatures (or large amounts of cosmic radiation, etc.)  the RTC
time may just be plain wrong.  No system is going to be perfect, but
it should be possible to make htings better, at for certain classes of
hardware.

And since we are already returning (time_t) -1 in some cases, we might
as well try to make things a bit more formal.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
