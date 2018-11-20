Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbeKTTYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 14:24:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAK8tlxq138384
        for <linux-xfs@vger.kernel.org>; Tue, 20 Nov 2018 03:56:33 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2nvbdshc24-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 20 Nov 2018 03:56:32 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 20 Nov 2018 08:56:27 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v1] xfs/050: make it passed for dax 2 MiB alignment test
Date: Tue, 20 Nov 2018 14:26:23 +0530
In-Reply-To: <1047154516.51611825.1542266350177.JavaMail.zimbra@redhat.com>
References: <1540522074-20036-1-git-send-email-xifeng@redhat.com> <20181104161554.GF12788@desktop> <1047154516.51611825.1542266350177.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2636273.fJmzGCklQ6@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiaoli Feng <xifeng@redhat.com>
Cc: Eryu Guan <guaneryu@gmail.com>, esandeen@redhat.com, jmoyer@redhat.com, fstests@vger.kernel.org, xzhou@redhat.com, linux-xfs@vger.kernel.org

On Thursday, November 15, 2018 12:49:10 PM IST Xiaoli Feng wrote:
> Hello all,
>   Any thoughts for this patch? Adding chandan@linux.vnet.ibm.com to cc list for review. 
> Because his patch "xfs/050: work with 64k block size" change the bsoft and bhard size.
> 
> Thanks.
> 
> ----- Original Message -----
> > From: "Eryu Guan" <guaneryu@gmail.com>
> > To: "XiaoLi Feng" <xifeng@redhat.com>
> > Cc: esandeen@redhat.com, jmoyer@redhat.com, fstests@vger.kernel.org, xzhou@redhat.com, linux-xfs@vger.kernel.org
> > Sent: Monday, November 5, 2018 12:15:54 AM
> > Subject: Re: [PATCH v1] xfs/050: make it passed for dax 2 MiB alignment test
> > 
> > On Fri, Oct 26, 2018 at 10:47:54AM +0800, Xiaoli Feng wrote:
> > > From: xiaoli feng <xifeng@redhat.com>
> > > 
> > > This case is failed for dax 2MiB alignment test. When test "push past
> > > the hard block limit" in this case, the quota bhard is 4000kb, and
> > > try to create 4096kb in dax fs.

It actually tries to create "1200 * 4096 = 4800kb" right?

> > > dax only create 2048kb because of 2MiB
> > > alignment.

Can you please explain how this could happen?

> > > But there is a check that the file size must > 3400kb(bhard
> > > * 85%). So there are two method to fix it. One is to decrease bhard
> > > size. Second is to descreate minimum size. The minimum is hard to define.
> > > So I choose first method.

> > 
> > Adding linux-xfs to cc list for review from xfs folks. Thanks a lot!
> > 
> > Eryu
> > 
> > > ---
> > >  tests/xfs/050     |  4 ++--
> > >  tests/xfs/050.out | 60
> > >  +++++++++++++++++++++++++++----------------------------
> > >  2 files changed, 32 insertions(+), 32 deletions(-)
> > > 
> > > diff --git a/tests/xfs/050 b/tests/xfs/050
> > > index 788ed7f..d2ca477 100755
> > > --- a/tests/xfs/050
> > > +++ b/tests/xfs/050
> > > @@ -43,8 +43,8 @@ _scratch_mount
> > >  bsize=$(_get_file_block_size $SCRATCH_MNT)
> > >  _scratch_unmount
> > >  
> > > -bsoft=$(( 200 * $bsize ))
> > > -bhard=$(( 1000 * $bsize ))
> > > +bsoft=$(( 100 * $bsize ))
> > > +bhard=$(( 500 * $bsize ))
> > >  isoft=4
> > >  ihard=10
> > >  
> > > diff --git a/tests/xfs/050.out b/tests/xfs/050.out
> > > index 725cd79..6a7af1a 100644
> > > --- a/tests/xfs/050.out
> > > +++ b/tests/xfs/050.out
> > > @@ -12,23 +12,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] =OK= 100 500 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** unmount
> > >  *** group
> > > @@ -44,23 +44,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] =OK= 100 500 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** unmount
> > >  *** uqnoenforce
> > > @@ -76,23 +76,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > >  
> > >  *** unmount
> > >  *** gqnoenforce
> > > @@ -108,23 +108,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > >  
> > >  *** unmount
> > >  *** pquota
> > > @@ -140,23 +140,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] =OK= 200 1000 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> > > +[NAME] =OK= 100 500 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> > >  
> > >  *** unmount
> > >  *** pqnoenforce
> > > @@ -172,22 +172,22 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > >  
> > >  *** report initial settings
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft inode limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the soft block limit
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > > +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard inode limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> > >  
> > >  *** push past the hard block limit (expect EDQUOT)
> > >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > > -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > > +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00
> > > [--------]
> > >  
> > >  *** unmount
> > > --
> > > 1.8.3.1
> > > 
> > 
> 
> 


-- 
chandan
