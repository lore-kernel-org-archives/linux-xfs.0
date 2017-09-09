Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43363 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751383AbdIIGk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 02:40:56 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v896djnr137328
        for <linux-xfs@vger.kernel.org>; Sat, 9 Sep 2017 02:40:56 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cux2u3q4k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 02:40:55 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 9 Sep 2017 16:40:53 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v896eoSV40108250
        for <linux-xfs@vger.kernel.org>; Sat, 9 Sep 2017 16:40:50 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v896eoQI021893
        for <linux-xfs@vger.kernel.org>; Sat, 9 Sep 2017 16:40:50 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical sectorsize
Date: Sat, 09 Sep 2017 12:11:35 +0530
In-Reply-To: <81dc9410-c9d1-20d3-65a6-6763d31b64b7@sandeen.net>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com> <81dc9410-c9d1-20d3-65a6-6763d31b64b7@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2418689.2OC4k4y5ao@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Friday, September 8, 2017 10:25:26 PM IST Eric Sandeen wrote:
> On 9/5/17 12:44 AM, Chandan Rajendra wrote:
> > Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > physical sector size of loop devices. On ppc64, this causes loop devices
> > to have 64k as the physical sector size.
> > 
> > With these changes, mkfs.xfs now prints error messages when filesystem
> > blocksize (4k) is less than underlying device's physical
> > sectorsize (64k). These messages (printed on stderr) now cause several
> > xfstests to fail on ppc64 machine since xfstests' _filter_mkfs() isn't
> > able to filter out stderr.
> > 
> > Also, the messages themselves describe a possible sub-optimal setup. But
> > the setup is still usable.
> > 
> > Hence this commit removes the calls to fprintf() used to print the
> > messages.
> 
> So, it looks like the loop change is getting reverted, right ... still -
> 
> Although I suggested this change, I'm rethinking it.  I'm not a fan
> of the warning for a default situation; the user can get this warning
> with nothing but a bare mkfs, which is not good IMHO.
> 
> (dchinner OTOH thinks we should warn about this suboptimal situation
> in any case - but I really don't think it's mkfs's job to be warning
> about every suboptimal geometry - there are a lot of them out there!)
> 
> What I'd now propose is that we change this warning into a failure,
> but only if a too-small block size was actually /specified/, i.e.
> bsflag is set.  If we're adjusting sector size based on device geometry
> and /default/ blocksize, I think we should just shut up about it.
> 
> i.e. something like:
> 
>                 if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {

I agree with your changes from a system administrator's perspective. But
without these messages, the sectorsize change for the loop device would 
most likely not have been noticed.

> 			if (bsflag) {

Just FYI, We should also be checking blflag's value.

>                                 fprintf(stderr,
> _("specified blocksize %d cannot be less than device physical sector size %d\n"),
>                                         blocksize, ft.psectorsize);
>                                 usage();
>                         }
>                         sectorsize = ft.lsectorsize ? ft.lsectorsize :
>                                                       XFS_MIN_SECTORSIZE;
>                 }
> 
> Thoughts?
> 

-- 
chandan

