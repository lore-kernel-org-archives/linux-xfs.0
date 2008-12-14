Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBENaP2O030393
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 17:36:25 -0600
Date: Mon, 15 Dec 2008 10:36:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Message-ID: <20081214233617.GD32301@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<493A9BE7.3090001@sandeen.net>
	<alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>
	<200812131826.25280.Martin@lichtvoll.de>
	<4943F37B.8080405@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4943F37B.8080405@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-raid@vger.kernel.orgxfs@oss.sgi.com

On Sat, Dec 13, 2008 at 11:40:11AM -0600, Eric Sandeen wrote:
> Martin Steigerwald wrote:
> 
> > At the moment it appears to me that disabling write cache may often give 
> > more performance than using barriers. And this doesn't match my 
> > expectation of write barriers as a feature that enhances performance. 
> 
> Why do you have that expectation?  I've never seen barriers advertised
> as enhancing performance.  :)
> 
> I do wonder why barriers on, write cache off is so slow; I'd have
> thought the barriers were a no-op.  Maybe I'm missing something.

Barriers still enforce ordering in this case, so it affects the
elevator algorithm....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
