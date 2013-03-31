Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EBB9C7F77
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 21:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8D6C304043
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 19:04:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zfni2cdKZZ4I47Yc for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 19:04:51 -0700 (PDT)
Date: Sun, 31 Mar 2013 13:04:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Help with XFS in VMs on VMFS
Message-ID: <20130331020449.GM6369@dastard>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
	<20130328214550.GA3771@pirx.askja.de>
	<5154E6AC.9020402@hardwarefreak.com>
	<CAJoqCq_afu4d++fgkGGMDC55pcz62V3qyai906ihQ2d=eiyhhQ@mail.gmail.com>
	<20130329202735.GX22182@sgi.com>
	<51573924.2020304@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51573924.2020304@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Ben Myers <bpm@sgi.com>, Jan Perci <jperci@gmail.com>, xfs@oss.sgi.com

On Sat, Mar 30, 2013 at 02:12:36PM -0500, Stan Hoeppner wrote:
> On 3/29/2013 3:27 PM, Ben Myers wrote:
> > Hi Jan,
> > 
> > On Thu, Mar 28, 2013 at 11:30:01PM -0400, Jan Perci wrote:
> >> Back to XFS, in this context, is there any benefit in tuning some
> >> parameters to get better performance, or will it all just be overshadowed
> >> by poor performance of the VMDKs that tuning isn't worthwhile?
> > 
> > At least get your stripe unit and width correct.
> > http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance
> 
> Is this really a good idea given that XFS sits atop a virtual disk which
> consists of multiple concatenated 2TB sparse files sitting on the VMFS
> filesystem, which, IIRC, has a 1MB sector size?  Thus can one rely on
> XFS being able to properly align to the physical RAID stripe, even if
> the math is done 'properly' (if that's even possible here)?

No, because VMFS doesn't do any specific alignment to the underlying
storage geometry.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
