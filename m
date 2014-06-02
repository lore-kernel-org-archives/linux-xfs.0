Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B7607F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 12:16:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07C4C8F8084
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 10:15:56 -0700 (PDT)
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.10]) by
	cuda.sgi.com with ESMTP id AGykstRPflDvlhcp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 10:15:55 -0700 (PDT)
Message-ID: <538CB085.5000502@zytor.com>
Date: Mon, 02 Jun 2014 10:12:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<20140602153124.GH30598@thunk.org>
In-Reply-To: <20140602153124.GH30598@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Chuck Lever <chuck.lever@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>, Dave Chinner <david@fromorbit.com>, LKML Kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, joseph@codesourcery.com, john.stultz@linaro.org, Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Linux NFS Mailing List <linux-nfs@vger.kernel.org>

On 06/02/2014 08:31 AM, Theodore Ts'o wrote:
> 
> I wonder if it would make sense to try to promulgate via the Austin
> group, and possibly the C standards committee the concept of a bit
> pattern (that might commonly be INT_MAX or UINT_MAX) that means "time
> unknown", or "time indefinite" or "we couldn't encode the time".
> 

(time_t)-1 already has this meaning for some calls (e.g. time(2)).
However, this also means Wed Dec 31 23:59:59 UTC 1969, and unfortunately
something similar applies to all possible bit patterns, certainly within
the range of an int.

> We would then teach gmtime(3) and asctime(3) to print some appropriate
> message, and we could teach programs like find (with the -mtime)
> option, make, tmpwatch, et. al., that they can't make any presumption
> about the comparibility of any timestamp which has a value of
> TIME_UNDEFINIED.
> 
> It would be problematic for time(2) or gettimeofday(2) to return
> TIME_UNDEFINED, since there are programs that care about time ticking
> forward, but I could imagine a new interface which would be permitted
> to return a flag indicating that we don't know the current time
> (because the CMOS battery had run down, etc.) so instead we're going
> to be counting the number of seconds since the system was booted.

This assumes that we actually know that that is the case, which may be
an aggressive assumption.

	-hpa


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
