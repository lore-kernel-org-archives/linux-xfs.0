Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9KBMYBB102397 for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 06:22:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XgHvnk2HzcM9F6AZ for
	<xfs@oss.sgi.com>; Sat, 20 Oct 2012 04:24:14 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9KBOEn0008259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 07:24:14 -0400
Received: from andromeda.usersys.redhat.com ([10.3.113.16])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q9KBO6HQ027780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 07:24:13 -0400
Date: Sat, 20 Oct 2012 08:24:05 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfstests 250 fail on newer kernels
Message-ID: <20121020112405.GA652@andromeda.usersys.redhat.com>
References: <20121019173730.GA23018@andromeda.usersys.redhat.com>
	<20121019215343.GX2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121019215343.GX2739@dastard>
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
To: xfs@oss.sgi.com

On Sat, Oct 20, 2012 at 08:53:43AM +1100, Dave Chinner wrote:
> On Fri, Oct 19, 2012 at 02:37:30PM -0300, Carlos Maiolino wrote:
> > Hi,
> > 
> > reviewing a patch to xfstests250, I ran it against newer kernels (3.6.0+ and
> > 3.7.0-rc1) and noticed it is failing. i.e. btree is getting corrupted. 
> 
> It's been failing on mainline kernels for a long time. In fact, i
> think it's been failing since it was created. But it's not failing
> due to btree corruption - it's failing because mkfs is not leaving
> enough space in the AG that contains the log for sanity checks to
> pass. i.e. that there are always a minimum of 4 blocks of freespace
> in an AG.
> 
> This is not actually a problem - the log takes the entire AG, so
> allocation will never occur in it, so having less than 4 blocks of
> free space in the AG is just noise in this case. It's never bubbled
> to the top of my list to fix...
> 
> > I'm going to take a look at it, but let me know if anybody has already
> > found/fixed it.
> 
> If it is failing the check_scratch_fs stage, then it is most likely
> the above issue. The corrupted btree problem that the test was
> writen for caused the system to ASSERT fail or crash - i.e. it
> didn't even run to the point of checking the fs....
> 
Yep, that was my point, it's failing on check_scratch_fs stage. The btree
problem has been fixed since it is not triggering the ASSERT. Didn't know it is
failing since its creation :)

I can add it to my todo list if you want some stuff out of yours

> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
