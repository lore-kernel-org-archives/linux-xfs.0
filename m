Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2199IpY095742 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 03:09:18 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id q0TMtHGHa1QFwlu5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 01:09:17 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133059288714096@bugs.debian.org>
From: Goswin von Brederlow <goswin-v-b@web.de>
References: <20120301081409.3103.43155.reportbug@frosties.localnet>
	<20120301083345.GA24409@infradead.org>
Date: Thu, 01 Mar 2012 10:07:55 +0100
In-Reply-To: <20120301083345.GA24409@infradead.org> (Christoph Hellwig's
	message of "Thu, 1 Mar 2012 03:33:45 -0500")
Message-ID: <87r4xcy9hw.fsf@frosties.localnet>
MIME-Version: 1.0
Reply-To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
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
Cc: 661580@bugs.debian.org, Goswin von Brederlow <goswin-v-b@web.de>

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Mar 01, 2012 at 09:14:09AM +0100, Goswin von Brederlow wrote:
>> And I can confirm that the sector size detection is still broken in
>> 3.1.7.
>
> That's a known bug that Carlos wanted to look into.  If you really can't
> accept smaller I/O without major pain make sure to use a larger logical
> blocksize, which should be handled fine by everything.

Tried that too. Setting a locigal block size of 4096 makes all access
aligned to 4096 byte and makes mkfs.xfs detect a sector size of 4096
too.

But that breaks partitioning support for example. Linux simply won't
read the partition table on /dev/nbd0 anymore. Not sure why. Plus that
doesn't solve the problem for real harddisks.

MfG
        Goswin


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
