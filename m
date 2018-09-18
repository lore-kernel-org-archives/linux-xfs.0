Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729584AbeIRP56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 11:57:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8IAJDsG132740
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 06:26:00 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mjxe8u930-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 06:26:00 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 18 Sep 2018 11:25:58 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 06/19] Fix xfs/139 to work with 64k block size
Date: Tue, 18 Sep 2018 14:16:57 +0530
In-Reply-To: <20180917222918.GD4635@magnolia>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com> <20180912062626.14349-7-chandan@linux.vnet.ibm.com> <20180917222918.GD4635@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2186672.yIoWgs1fP6@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org

On Tuesday, September 18, 2018 3:59:18 AM IST Darrick J. Wong wrote:
> On Wed, Sep 12, 2018 at 11:56:13AM +0530, Chandan Rajendra wrote:
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
> > index 2a26635..9ab74c8 100755
> > --- a/tests/xfs/139
> > +++ b/tests/xfs/139
> > @@ -34,17 +34,20 @@ _require_cp_reflink
> >  
> >  rm -f $seqres.full
> >  
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +blksz=$(_get_block_size $SCRATCH_MNT)
> > +_scratch_unmount
> > +
> >  echo "Format and mount"
> > -_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
> > +_scratch_mkfs -d agsize=$((4400 * $blksz)) > $seqres.full 2>&1
> 
> Uh... how did this magic 4400 number come about?  I'd have expected
> 8192...?

Sorry, I should have added a comment describing the reasoning behind using 4400.
And now, I have forgotten the rational behind choosing 4400 blocks. Most likely
it was to keep the AG size smaller when using 64k block size. The test requires
that file1 occupy enough blocks to overflow an AG and then CoW-ing the same
would cause ENOSPC when expanding the per-AG refcntbt if a bug exists in
the Per-AG reservation.

I will post another version of this patchset which uses 8192 blocks as the 
AG size.

-- 
chandan
