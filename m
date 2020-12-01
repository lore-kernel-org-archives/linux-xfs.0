Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A5DC64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3557C208C3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:23:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DPE+hShp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgLAQXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:23:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgLAQXV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:23:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5PvJ099486;
        Tue, 1 Dec 2020 16:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RL6VMbuxC9UM2Pde0Y/pxqPlpdUWB1H0ygRfJitYqAU=;
 b=DPE+hShpFhnhz1Y9MToh37g6PVFVQDVxQkdi2DY7Fy6XwsWLktlBF4L1txVWn3kxoPi+
 hDVb0Hgck9EGeQMFnhey/VkbATI15I5oguV2MoTn7p21wRuUiHnIfa4EnvTblH4k/MdN
 tVfjMVJp5+SKL6t47HVuCKv/rADwFvZ7s7+EQZHv4usqmo7NVQ2FKAmw1hPK3U5MLni5
 kMgS21mKINRpnoW/ZZBlwlp5zm4J63owML6P0au+zhUzYfJdV3b5ACTHGr8vWoItdR8e
 BWHDSqmKPAqU1vBsCzc8MsbKzfOQ/wVWpzBRQYyWj96vTOu/ra3nwuCiaU/MmM1Q8Tei Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqkg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:22:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G6H9S053970;
        Tue, 1 Dec 2020 16:22:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540askmfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:22:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GMaSX028434;
        Tue, 1 Dec 2020 16:22:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:22:36 -0800
Date:   Tue, 1 Dec 2020 08:22:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Message-ID: <20201201162235.GC143049@magnolia>
References: <3275346.ciGmp8L3Sz@garuda>
 <20201130192605.GB143049@magnolia>
 <20201130220347.GI2842436@dread.disaster.area>
 <2114686.IuJF2Ahm34@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2114686.IuJF2Ahm34@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 06:42:51PM +0530, Chandan Babu R wrote:
> On Tue, 01 Dec 2020 09:03:47 +1100, Dave Chinner  wrote:
> > On Mon, Nov 30, 2020 at 11:26:05AM -0800, Darrick J. Wong wrote:
> > > On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> > > > I have come across a "log reservation" calculation issue when
> > > > increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> > > 
> > > Hmm.  That will increase the size of the btree cursor structure even
> > > farther.  It's already gotten pretty bad with the realtime rmap and
> > > reflink patchsets since the realtime volume can have 2^63 blocks, which
> > > implies a theoretical maximum rtrmapbt height of 21 levels and a maximum
> > > rtrefcountbt height of 13 levels.
> > 
> > The cursor is dynamically allocated, yes? So what we need to do is
> > drop the idea that the btree is a fixed size and base it's size on
> > the actual number of levels iwe calculated for that the btree it is
> > being allocated for, right?
> > 
> > > (These heights are absurd, since they imply a data device of 2^63
> > > blocks...)
> > > 
> > > I suspect that we need to split MAXLEVELS into two values -- one for
> > > per-AG btrees, and one for per-file btrees,
> > 
> > We already do that. XFS_BTREE_MAXLEVELS is supposed to only be for
> > per-AG btrees.  It is not used for BMBTs at all, they use
> > mp->m_bm_maxlevels[] which have max height calculations done at
> > mount time.
> > 
> > The problem is the cursor, because right now max mp->m_bm_maxlevels
> > fits within the XFS_BTREE_MAXLEVELS limit for the per-AG trees as
> > well, because everything is limited to less than 2^32 records...
> > 
> > > and then refactor the btree
> > > cursor so that the level data are a single VLA at the end.  I started a
> > > patchset to do all that[1], but it's incomplete.
> > > 
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=btree-dynamic-depth&id=692f761838dd821cd8cc5b3d1c66d6b1ac8ec05b
> >
> 
> Darrick, I will rebase my "Extend data fork extent count field" patches on top
> your patch with required fixes applied. Please let me know if you have any
> objection to it.

You might want to wait a day or two, because I decided to get rid of
XFS_BTREE_MAXLEVELS entirely as part of making the cursors dynamically
sized.

--D

> > Yeah, this, along with dynamic sizing of the rmapbt based
> > on the physical AG size when refcount is enabled...
> > 
> > And then we just don't have to care about the 1kB block size case at
> > all....
> > 
> 
> -- 
> chandan
> 
> 
> 
