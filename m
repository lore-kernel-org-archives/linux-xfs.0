Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q497ao0Q079759 for <xfs@oss.sgi.com>; Wed, 9 May 2012 02:36:50 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id gwZQPNuRIcmuuimW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 May 2012 00:36:49 -0700 (PDT)
Message-ID: <4FAA1E89.2050509@profihost.ag>
Date: Wed, 09 May 2012 09:36:41 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard>
In-Reply-To: <20120509070450.GP5091@dastard>
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
Cc: Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 09.05.2012 09:04, schrieb Dave Chinner:
>> So the best solution to your current problem, and one that will save you
>> disk space and thus $$, is to use a backup solution that makes use of
>> both tar and gzip/bzip2.
> 
> Why use the slow method? xfsdump will be much faster than tar. :)
I tried to use it in this special case but it is hanging on dumping
directories for 3 hours now or is this normal?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
