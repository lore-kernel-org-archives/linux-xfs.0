Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0VJF2bI121859 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 13:15:02 -0600
Date: Mon, 31 Jan 2011 14:17:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110131191720.GA2327@infradead.org>
References: <4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
	<4D42056E.2050505@hardwarefreak.com>
	<alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
	<20110128135629.GX21311@dastard>
	<alpine.DEB.2.00.1101281119250.17579@asgard.lang.hm>
	<20110129054021.GB21311@dastard>
	<alpine.DEB.2.00.1101282201260.29659@asgard.lang.hm>
	<20110129073554.GC21311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110129073554.GC21311@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: david@lang.hm, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>, Stan Hoeppner <stan@hardwarefreak.com>

On Sat, Jan 29, 2011 at 06:35:54PM +1100, Dave Chinner wrote:
> Just because we can't do it right now doesn't mean it is not
> possible. Array/raid controller vendors need to implement the SCSI
> block limit VPD page, and if they do then stripe unit/stripe width
> may be exposed for the device in sysfs. However, I haven't seen any
> devices except for md and dm that actually export values that
> reflect sunit/swidth in the files:

I have access to a few big vendor arrays that export it, but I think
they are still running beta firmware versions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
