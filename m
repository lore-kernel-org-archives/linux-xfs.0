Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15HKK18056307 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 11:20:21 -0600
Received: from geotraceuk2.Geotrace.com (ip-87-86-166-5.easynet.co.uk
	[87.86.166.5]) by cuda.sgi.com with ESMTP id 6U8Kg6JOCON2PwBC
	for <xfs@oss.sgi.com>; Sun, 05 Feb 2012 09:20:19 -0800 (PST)
From: Ron Yorston <rmy@tigress.co.uk>
Message-Id: <201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
Date: Sun, 05 Feb 2012 17:19:19 +0000
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
In-Reply-To: <4F2EB017.5090006@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@redhat.com, rmy@tigress.co.uk
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

OK, I tried it out for my use case of flinging VM filesystem images around
on ext4 and it seems to do the job.  I don't have any 64-bit systems
here at home so I used my feeble 32-bit netbook.  Since sizeof(off_t) !=
sizeof(long long) the debug output was all wrong:

   punching at 8989607068975104 len -4635819229210214401

but the image file and the host filesystem both survived the ordeal.

Ron

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
