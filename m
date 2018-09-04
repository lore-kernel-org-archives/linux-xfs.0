Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727579AbeIDTwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 15:52:44 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w84FK4pI133574
        for <linux-xfs@vger.kernel.org>; Tue, 4 Sep 2018 11:27:08 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2m9ugkbs28-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Sep 2018 11:27:08 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 4 Sep 2018 16:27:05 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/16] Fix tests to work on non-4k block sized fs instances
Date: Tue, 04 Sep 2018 20:59:19 +0530
In-Reply-To: <20180901172158.GH3651@desktop>
References: <20180816072646.14490-1-chandan@linux.vnet.ibm.com> <20180901172158.GH3651@desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2571342.XK85Dr93Fb@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Saturday, September 1, 2018 10:51:58 PM IST Eryu Guan wrote:
> On Thu, Aug 16, 2018 at 12:56:30PM +0530, Chandan Rajendra wrote:
> > This patchset fixes tests (mostly XFS specific ones) to work on
> > variable block size. These patches now use the output of "od" utility
> > to verify the contents of the test files instead of the md5sum
> > utility.
> > 
> > The patchset modifies _filter_fiemap() filter function to optionally
> > print the file offset range in block size units.
> > 
> > Chandan Rajendra (16):
> >   Fix xfs/009 to work with 64k block size
> >   xfs/050: Fix "Push past soft inode limit" case
> >   Fix xfs/050 to work with 64k block size
> >   Fix xfs/074 to work with 64k block size
> >   Fix xfs/127 to work with 64k block size
> >   Fix xfs/139 to work with 64k block size
> >   Fix xfs/140 to work with 64k block size
> >   Fix xfs/190 to work with 64k block size
> >   Fix xfs/299 to work with 64k block size
> >   xfs/325: Inject free_extent error after CoW operation
> 
> I may need helps from XFS folks to review these changes.
> 
> But I noticed that you are getting fs block size all from TEST_DIR, even
> if the test is testing against $SCRATCH_MNT, e.g. xfs/139 xfs/140 (and
> other tests too). But the fs block size could be different on TEST_DEV
> and SCRATCH_DEV.

Sure, I will fix that up and send the next version of the patchset.

> 
> Also, I'd be very helpful if someone could help test this patchset on
> real hardware that supports mounting 64k blocksize XFS.
> 
> Thanks a lot!
> 
> Eryu
> 
> >   Fix generic/102 to work with 64k block size
> >   Fix generic/172 to work with 64k block size
> >   Filter fiemap output by FS block size
> >   Fix generic/177 to work with 64k block size
> >   Fix generic/230 to work with 64k block size
> >   Fix generic/235 to work with 64k block size
> > 
> >  common/punch          | 19 ++++++++---
> >  tests/generic/102     |  4 +--
> >  tests/generic/102.out | 20 +++++------
> >  tests/generic/172     |  4 +--
> >  tests/generic/177     | 20 ++++++-----
> >  tests/generic/177.out | 23 ++++++++-----
> >  tests/generic/230     | 24 ++++++++------
> >  tests/generic/230.out | 16 ++++-----
> >  tests/generic/235     |  2 +-
> >  tests/generic/235.out |  4 +--
> >  tests/xfs/009         | 92 ++++++++++++++++++++++++++++++++++++++++++---------
> >  tests/xfs/009.out     | 66 ++++++++++++++++++------------------
> >  tests/xfs/050         | 23 ++++++++-----
> >  tests/xfs/050.out     | 60 ++++++++++++++++-----------------
> >  tests/xfs/074         | 23 ++++++++++---
> >  tests/xfs/127         |  2 +-
> >  tests/xfs/139         | 12 +++----
> >  tests/xfs/139.out     |  8 +++--
> >  tests/xfs/140         |  9 ++---
> >  tests/xfs/190         | 44 +++++++++++++++++++-----
> >  tests/xfs/299         | 23 ++++++++-----
> >  tests/xfs/299.out     | 60 ++++++++++++++++-----------------
> >  tests/xfs/325         |  5 +--
> >  tests/xfs/325.out     |  2 +-
> >  24 files changed, 355 insertions(+), 210 deletions(-)
> > 
> 
> 


-- 
chandan
