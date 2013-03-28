Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA1D27F52
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 20:38:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B315E30408C
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 18:38:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ahEq8Dpb3ihJVZdC for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 18:38:43 -0700 (PDT)
Date: Thu, 28 Mar 2013 12:38:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130328013841.GB6369@dastard>
References: <514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515082C3.2000006@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 25, 2013 at 01:00:51PM -0400, Dave Hall wrote:
> 
> Dave Hall
> Binghamton University
> kdhall@binghamton.edu
> 607-760-2328 (Cell)
> 607-777-4641 (Office)
> 
> 
> On 03/16/2013 03:21 AM, Dave Chinner wrote:
> >Using perf to profile the kernel while the cp -al workload is
> >running will tell use exactly where the CPU is being burnt. That
> >will confirm the analysis, or point us at some other issue that is
> >causing excessive CPU burn...
> >
> Dave,  which perf command(s) would you like me to run.  (I'm
> familiar with the concept behind this kind of tool, but I haven't
> worked with this one before).

Just run 'perf top -U' for 10s while the problem is occurring and
pastebin the output....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
