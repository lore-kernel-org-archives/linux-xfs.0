Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E15C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 06:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D399420714
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 06:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgDAGHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 02:07:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731741AbgDAGHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 02:07:46 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03164nKd052151
        for <linux-xfs@vger.kernel.org>; Wed, 1 Apr 2020 02:07:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfgfyt8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 02:07:45 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 1 Apr 2020 07:07:27 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 07:07:24 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03166a6s33358136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 06:06:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 973E5AE045;
        Wed,  1 Apr 2020 06:07:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB6EDAE04D;
        Wed,  1 Apr 2020 06:07:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.52.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 06:07:37 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: xfs metadata corruption since 30 March
Date:   Wed, 01 Apr 2020 11:40:39 +0530
Organization: IBM
In-Reply-To: <20200401044528.GE56958@magnolia>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw> <FDCFF269-C30C-42A8-B926-A8731E110848@lca.pw> <20200401044528.GE56958@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040106-0020-0000-0000-000003BF6A9D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040106-0021-0000-0000-000022180E96
Message-Id: <72081949.TPG3Dqxxrz@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=56 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, April 1, 2020 10:15 AM Darrick J. Wong wrote: 
> On Wed, Apr 01, 2020 at 12:15:32AM -0400, Qian Cai wrote:
> > 
> > 
> > > On Apr 1, 2020, at 12:14 AM, Chandan Rajendra <chandan@linux.ibm.com> wrote:
> > > 
> > > On Wednesday, April 1, 2020 3:27 AM Qian Cai wrote: 
> > >> Ever since two days ago, linux-next starts to trigger xfs metadata corruption
> > >> during compilation workloads on both powerpc and arm64,
> > > 
> > > Can you please provide the filesystem geometry information?
> > > You can get that by executing "xfs_info <mount-point>" command.
> > > 
>

I wasn't able to recreate this issue on my P8 kvm guest. Can you provide,
1. The build command line you are using.
2. The number of online CPUs and amount of system memory.
2. As Darrick pointed out, Can you please provide the kconfig used (especially
   the one used for powerpc build).

> Hmm.   Do the arm/ppc systems have 64k pages?  kconfigs might be a good
> starting place.  Also, does the xfs for-next branch exhibit this
> problem, or is it just the big -next branch that Stephen Rothwell puts
> out?
> 
> 
> --D
> 
> > == arm64 ==
> > # xfs_info /home/
> > meta-data=/dev/mapper/rhel_hpe--apollo--cn99xx--11-home isize=512    agcount=4, agsize=113568256 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1
> > data     =                       bsize=4096   blocks=454273024, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=221813, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > 
> > == powerpc ==
> > # xfs_info /home/
> > meta-data=/dev/mapper/rhel_ibm--p9wr--01-home isize=512    agcount=4, agsize=118489856 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1
> > data     =                       bsize=4096   blocks=473959424, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=231425, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > == x86 (not yet reproduced)  ==
> > meta-data=/dev/mapper/rhel_hpe--dl380gen9--01-home isize=512    agcount=16, agsize=3283776 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1
> > data     =                       bsize=4096   blocks=52540416, imaxpct=25
> >          =                       sunit=64     swidth=64 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=25664, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 


-- 
chandan



