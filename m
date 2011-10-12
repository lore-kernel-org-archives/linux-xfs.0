Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9CNETSQ109356 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 18:14:29 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2B9B1E8FF88
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 16:14:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vLpsbpdqBv2Gr3Sj for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 16:14:27 -0700 (PDT)
Date: Thu, 13 Oct 2011 10:14:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Help with xfs and Fedora 8
Message-ID: <20111012231424.GK3159@dastard>
References: <CADDFK--585nmGJMuVhbhyO5S7tvCxR0Ur_1qxX73AvpAgau8Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDFK--585nmGJMuVhbhyO5S7tvCxR0Ur_1qxX73AvpAgau8Ew@mail.gmail.com>
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
To: Ram Natarajan <ram@arohisystems.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 11, 2011 at 06:23:41PM -0700, Ram Natarajan wrote:
> I have a bunch of Fedora 8 machines running Kernel 2.6.23.1.
> I am noticing that the xfs partitions on these machines 'freeze up' once in
> a while. I have  to manually run xfs_repair on these partitions to get them
> going again. Note that SMART does not report any hard disk errors - these
> are purely xfs related. I also see some xfs kernel module messages in the
> kernel logs. My question is this:
> Can I move to the latest xfs by recompiling xfs kernel module and xfs
> support code for 2.6.23.

The userspace code (xfsprogs, etc) is simple - just download the
latest and compile it.

>
> For various technical reasons, I cannot move to a
> later kernel, but it would be great if I can build the latest xfs modules
> and xfs support code for 2.6.23. Does anybody know if this is possible, and
> if it is possible, will it work reliably?

The kernel code is not so simple. Indeed, if you're not a kernel
programmer and familiar with the XFS code, then I'd put it in the
impossible basket. It'll take at least 3 months to do the backport
and adequately test it for production use, and that's if you pay an
expert to do it.

It's far, far simpler to just upgrade your machines to a more recent
distribution that it is to backport code to kernels that old....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
