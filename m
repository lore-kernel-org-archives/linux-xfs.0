Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41CAC7F55
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 05:58:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE706AC002
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 03:58:47 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id ewGtbK39YG1xu7BM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 03:58:45 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 12:56:42 +0200
Message-ID: <4178301.j9kWdGCRLC@wuerfel>
In-Reply-To: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
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
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Sunday 01 June 2014 21:36:26 Nicolas Pitre wrote:
> 
> > For actually running kernels beyond 2038, the best idea I've seen so
> > far is to disallow all broken code at compile time. I don't see
> > a choice but to audit the entire kernel for invalid uses on both
> > 32 and 64 bit in the next few years. A lot of code will get changed
> > in the process so we can actually keep running 32-bit kernels and
> > file systems, but other code will likely go away:
> > 
> > * any system calls that pass a time_t, timeval or timespec on
> >   32-bit systems return -ENOSYS, to ensure all user land uses
> >   the replacements we will put into place
> > * The definition of 'time_t', 'timval' and 'timespec' can be hidden
> >   from the kernel, and all code using it left out.
> > * ext2 and ext3 file system code will have to be disabled, but that's
> >   file since ext4 can mount old file systems.
> 
> Syscalls and libs can be "fixed".  Existing filesystem content might 
> not.  So if you need to mount some old media in read-write mode after 
> 2038 and that happens to content an ext2 or similarly limited filesystem 
> then it'd better just "work".  Having the kernel refuse to modify the 
> filesystem would be unacceptable.

I think you misunderstood what I suggested: the intent is to avoid
seeing things break in 2038 by making them break much earlier. We have
a solution for ext2 file systems, it's called ext4, and we just need
to ensure that everybody knows they have to migrate eventually.

At some point before the mid 2030ies, you should no longer be able to
build a kernel that has support for ext2 or any other module that will
run into bugs later. Until then (rather sooner than later), I'd like
to get to the point where you can choose whether to include those
modules at build time or not, and then get everybody to turn off that
option and fix the bugs they run into. You wouldn't need that for a
2014-generation long-term support disto (rhel 7, sles 12, debian 7,
ubuntu 14.04, ...), but perhaps for the next generation, or the
one after that.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
