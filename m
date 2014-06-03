Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 509377F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 08:09:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCBBCAC003
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 06:09:46 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id NSWY1HLQXSXOrsCa for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 06:09:44 -0700 (PDT)
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20140602233212.GA2060@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<20140602153124.GH30598@thunk.org> <538CB085.5000502@zytor.com>
	<20140602222954.GA29690@thunk.org> <538CFB83.20703@zytor.com>
	<20140602233212.GA2060@thunk.org>
Date: Tue, 03 Jun 2014 14:09:43 +0100
Message-Id: <1401800983.6065.272.camel@montana.filmlight.ltd.uk>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, geert@linux-m68k.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Chuck Lever <chuck.lever@oracle.com>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lftan@altera.com, tglx@linutronix.de, joseph@codesourcery.com


On Mon, 2014-06-02 at 19:32 -0400, Theodore Ts'o wrote:

> Linux's time(2) can return (time_t) -1 and set errno to EFAULT, per
> the Posix specification:
> 
> SYSCALL_DEFINE1(time, time_t __user *, tloc)
> {
> 	time_t i = get_seconds();
> 
> 	if (tloc) {
> 		if (put_user(i,tloc))
> 			return -EFAULT;
> 	}
> 	force_successful_syscall_return();
> 	return i;
> }

get_seconds() returns an unsigned long so there's potential for overflow
here.

--
Roger



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
