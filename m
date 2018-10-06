Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbeJFNvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 09:51:13 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w966ehUY063920
        for <linux-xfs@vger.kernel.org>; Sat, 6 Oct 2018 02:49:03 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mxq73hp4u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 06 Oct 2018 02:49:03 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 6 Oct 2018 07:49:02 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V5 06/20] Fix xfs/139 to work with 64k block size
Date: Sat, 06 Oct 2018 12:21:22 +0530
In-Reply-To: <20181006003338.GC6311@dastard>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com> <20180924151942.8220-7-chandan@linux.vnet.ibm.com> <20181006003338.GC6311@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3892653.Ddf5GiE5O6@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

On Saturday, October 6, 2018 6:03:38 AM IST Dave Chinner wrote:
> On Mon, Sep 24, 2018 at 08:49:28PM +0530, Chandan Rajendra wrote:
> > For 64k block size, the agsize provided in the test causes mkfs.xfs to
> > fail due to insufficient log space. Hence this commit computes agsize
> > based on block size of the filesystem.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  tests/xfs/139     | 15 +++++++++------
> >  tests/xfs/139.out |  8 ++++++--
> >  2 files changed, 15 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tests/xfs/139 b/tests/xfs/139
> > index 2a26635..c074273 100755
> > --- a/tests/xfs/139
> > +++ b/tests/xfs/139
> > @@ -34,17 +34,20 @@ _require_cp_reflink
> >  
> >  rm -f $seqres.full
> >  
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +blksz=$(_get_file_block_size $SCRATCH_MNT)
> > +_scratch_unmount
> > +
> >  echo "Format and mount"
> > -_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
> > +_scratch_mkfs -d agsize=$((8192 * $blksz)) > $seqres.full 2>&1
> 
> This breaks 512 byte and 1k block size filesystems.
> 
> $ head -3 139.full
> Invalid value 8388608 for -d agsize option. Value is too small.
> Usage: mkfs.xfs
> /* blocksize */         [-b size=num]
> $
> 
> Minimum AG size is 16MB. There are more changes to other tests in
> this series that also demonstrate this regression.

Thanks for mentioning this fact about the minimum AG size. I will verify
all the tests once again. 

Also, for xfs/139, 512 byte block size does not apply since reflink feature
requires CRC to be enabled. Nevertheless, I will make sure that mkfs.xfs
actually does succeed for other tests where 512 bytes block size is applicable.

-- 
chandan
