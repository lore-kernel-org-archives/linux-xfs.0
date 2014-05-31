Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A503B7F78
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 03:45:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58D04AC001
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 01:45:02 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	OK3ggF6tBivwh4F6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 May 2014 01:45:00 -0700 (PDT)
Message-ID: <538995D4.9050702@zytor.com>
Date: Sat, 31 May 2014 01:41:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
	<20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com>
	<20140531011450.GJ14410@dastard>
	<c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
	<20140531055457.GK14410@dastard>
In-Reply-To: <20140531055457.GK14410@dastard>
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
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On 05/30/2014 10:54 PM, Dave Chinner wrote:
> 
> If we are changing the in-kernel timestamp to have a greater dynamic
> range that anything we current support on disk, then we need support
> for all filesystems for similar translation and constraint. The
> filesystems need to be able to tell the kernel what they timestamp
> range they support, and then the kernel needs to follow those
> guidelines. And if the filesystem is mounted on a kernel that
> doesn't support the current filesystem's timestamp format, then at
> minimum that filesystem cannot do anything that writes a
> timestamp....
> 
> Put simply: the filesystem defines the timestamp range that can be
> used safely, not the userspace API. If the filesystem can't support
> the date it is handed then that is an out-of-range error. Since
> when have we accepted that it's OK to handle out-of-range data with
> silent overflows or corruption of the data that we are attempting to
> store? We're defining a new API to support a wider date range -
> there is nothing that prevents us from saying ERANGE can be returned
> to a timestamp that the file cannot store correctly....
> 

I'm still puzzled.

Are you saying that you want a program that does:

	/* Deliberately simplified */
	gettimeofdayns(&now ...);
	utimensat(... now);

... to suddenly start failing on Jan 19, 2038 (for a filesystem with
32-bit timestamps), or would you propose some ways for the filesystems
in question to extend the range of the timestamps?

What you seem to propose also seems to imply that on Jan 19, 2038
anything that writes a timestamp with the current date (which logically
ends up being almost every write operation) would be dead and frozen on
such a filesystem -- pretty much meaning the filesystem would become
readonly if not in reality than in practice.

I strongly suspect that that would be a more catastrophic failure than
incorrect timestamps, as you suddenly have all kinds of machines
embedded in $DEITY knows what places just stop and refuse to run.

If that is not what you mean I genuinely like to understand the
situation better.

	-hpa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
