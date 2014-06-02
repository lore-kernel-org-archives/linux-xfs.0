Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59D7F29DF8
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 20:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 323B1304032
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 18:36:30 -0700 (PDT)
Received: from mail-qa0-f50.google.com (mail-qa0-f50.google.com
	[209.85.216.50]) by cuda.sgi.com with ESMTP id GfWKUm6dN3jx97Bz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 01 Jun 2014 18:36:28 -0700 (PDT)
Received: by mail-qa0-f50.google.com with SMTP id j15so1831444qaq.23
	for <xfs@oss.sgi.com>; Sun, 01 Jun 2014 18:36:28 -0700 (PDT)
Date: Sun, 1 Jun 2014 21:36:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
In-Reply-To: <8618458.1EVJCoVbkH@wuerfel>
Message-ID: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<538995D4.9050702@zytor.com>
	<alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
	<8618458.1EVJCoVbkH@wuerfel>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Sun, 1 Jun 2014, Arnd Bergmann wrote:

> On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
> > > readonly if not in reality than in practice.
> > 
> > For those (legacy) filesystems with a signed 32-bit timestamps, any 
> > attempt to create a timestamp past Jan 19 03:14:06 2038 UTC should be 
> > (silently) clamped to 0x7fffffff and that value (the last representable 
> > time) used as an overflow indicator.  The filesystem driver should 
> > convert that value into a corresponding overflow value for whatever 
> > kernel internal time representation being used when read back, and this 
> > should be propagated up to user space.  It should not be a hard error 
> > otherwise, as you rightfully stated, everything non read-only would come 
> > to a halt on that day.
> 
> I don't think there is much of a difference between not being able to
> write at all and all newly written files having the same timestamp,
> causing random things to break differently.

Well, in one case you have a crash certitude. In the other case you have 
some probability that your system might still be usable.

> The clamp to the maximum supported time stamp sounds like a reasonable
> choice for 'utimens' and related syscalls for the case of someone
> setting an arbitrary future date beyond what the file system can
> represent. Then again, I don't see a reason why that shouldn't just
> cause an error to be returned.

Resiliance is better than outright failure.

> For actually running kernels beyond 2038, the best idea I've seen so
> far is to disallow all broken code at compile time. I don't see
> a choice but to audit the entire kernel for invalid uses on both
> 32 and 64 bit in the next few years. A lot of code will get changed
> in the process so we can actually keep running 32-bit kernels and
> file systems, but other code will likely go away:
> 
> * any system calls that pass a time_t, timeval or timespec on
>   32-bit systems return -ENOSYS, to ensure all user land uses
>   the replacements we will put into place
> * The definition of 'time_t', 'timval' and 'timespec' can be hidden
>   from the kernel, and all code using it left out.
> * ext2 and ext3 file system code will have to be disabled, but that's
>   file since ext4 can mount old file systems.

Syscalls and libs can be "fixed".  Existing filesystem content might 
not.  So if you need to mount some old media in read-write mode after 
2038 and that happens to content an ext2 or similarly limited filesystem 
then it'd better just "work".  Having the kernel refuse to modify the 
filesystem would be unacceptable.


Nicolas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
