Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EDCDA7F3F
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 04:46:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9620304043
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 02:46:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F2RtIjPte8QvdiyF for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 02:46:52 -0700 (PDT)
Date: Wed, 22 May 2013 19:46:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: XFS rootfs corruption
Message-ID: <20130522094648.GJ29466@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<2132292786.4417784.1369195807747.JavaMail.root@redhat.com>
	<2013798179.4502334.1369212536770.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2013798179.4502334.1369212536770.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, May 22, 2013 at 04:48:56AM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "CAI Qian" <caiqian@redhat.com>
> > To: "Eric Sandeen" <sandeen@sandeen.net>
> > Cc: xfs@oss.sgi.com
> > Sent: Wednesday, May 22, 2013 12:10:07 PM
> > Subject: Re: 3.9.0: XFS rootfs corruption
> > 
> > OK, this has never been reproduced in 3.9-rc1 so far. It may because the
> > rootfs became full after crash dump testing though.
> > CAI Qian
> Oops, it is still there,

Have you run xfs_repair -n  <dev>  to determine what is corrupted on
disk? Can you post the output when you do?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
