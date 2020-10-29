Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB4CC4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 15:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA642087E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 15:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="on3dmDnb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgJ2Pm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:42:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52486 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgJ2Pm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 11:42:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TFPIjs129039;
        Thu, 29 Oct 2020 15:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2Dl4cv0hBWptQ9KmPaIaNDVbMpcW94x4z0N0sMcGuDs=;
 b=on3dmDnbKDdGtUXUTmMRtlXeyXCQD1Un7JeBVpCp/azLP2I7NrxG/Dc+3MguZpF+U11k
 uJt45jcvEKlr1QEQZkC7bI6SANBG7X7pS8szx5Xur5m0lJHVGl0YhCa7SzVDawob9RKq
 7DBXW+PcUuW9ULG2TkG20V1hag8TnI4vsLRyPfMVUl1+c1Vls+UhlzXoLZW80Il5gyRB
 FTRylFh0+t9LXJk/10toH0mQgvhHgqlCtNLZ8qD5lyc/1cc4OCQMrkpim1w+OTOB5usI
 8wQCOw4lZAcOu8oW7IELz0/u7q3nFf+eob52Ae0d1K4HKDLXmlZO4Ss/8GC/8EexhKFZ dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb5r4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 15:42:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TFQBrW063155;
        Thu, 29 Oct 2020 15:42:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx60nbt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 15:42:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TFgp5a018112;
        Thu, 29 Oct 2020 15:42:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 08:42:51 -0700
Date:   Thu, 29 Oct 2020 08:42:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <20201029154250.GL1061252@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
 <20201028172925.GD1611922@bfoster>
 <20201029000332.GG1061252@magnolia>
 <20201029120905.GA1657878@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029120905.GA1657878@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 08:09:05AM -0400, Brian Foster wrote:
> On Wed, Oct 28, 2020 at 05:03:32PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 28, 2020 at 01:29:25PM -0400, Brian Foster wrote:
> > > On Mon, Oct 26, 2020 at 04:33:38PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Enable users to upgrade their filesystems to support inode btree block
> > > > counters.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  db/sb.c              |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-
> > > >  db/xfs_admin.sh      |    4 ++-
> > > >  man/man8/xfs_admin.8 |   16 +++++++++++
> > > >  3 files changed, 94 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> ...
> > > > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > > > index 8afc873fb50a..65ca6afc1e12 100644
> > > > --- a/man/man8/xfs_admin.8
> > > > +++ b/man/man8/xfs_admin.8
> ...
> > > > @@ -103,6 +105,20 @@ The filesystem label can be cleared using the special "\c
> > > >  " value for
> > > >  .IR label .
> > > >  .TP
> > > > +.BI \-O " feature"
> > > > +Add a new feature to the filesystem.
> > > > +Only one feature can be specified at a time.
> > > > +Features are as follows:
> > > > +.RS 0.7i
> > > > +.TP
> > > > +.B inobtcount
> > > > +Upgrade the filesystem to support the inode btree counters feature.
> > > > +This reduces mount time by caching the size of the inode btrees in the
> > > > +allocation group metadata.
> > > > +Once enabled, the filesystem will not be writable by older kernels.
> > > > +The filesystem cannot be downgraded after this feature is enabled.
> > > 
> > > Any reason for not allowing the downgrade path? It seems like we're
> > > mostly there implementation wise and that might facilitate enabling the
> > > feature by default.
> > 
> > Downgrading will not be easy for bigtime, since we'd have to scan the
> > whole fs to see if there are any timestamps past 2038.  For other
> > features it might not be such a big deal, but in general I don't want to
> > increase our testing burden even further.
> > 
> 
> Well it's not something I'd say we should necessarily support for every
> feature. TBH, I wasn't expecting an upgrade mechanism for inobtcount in
> the first place since I thought we didn't tend to do that for v5
> filesystems.

We've not been especially consistent with that -- I think you can
"upgrade" to meta_uuid; at one point Christoph had a series to make it
possible to upgrade to reflink; but all the other features don't support
upgrades.

I picked inobtcount for the initial v5 upgrade support because it seemed
like a small enough feature that people could theoretically backport the
feature to old kernels.  That was supposed to go in ahead of y2038
support (which is my real motivation for allowing some upgrades) but
then they both landed at the same time. ;)

> ISTM it's simple enough to support and perhaps that's good
> enough reason to do so, but if we're going to move the "test burden"
> line anyways it seems rather arbitrary to me to support one direction
> and not the other when they are presumably of comparable complexity.
> Just my .02 of course, and I don't feel strongly about whether we
> support upgrade, downgrade, or neither...

I think the only features that we've supported downgrading are attr2 ->
attr1 and (in the old days) unwritten extents.

--D

> Brian
> 
> > I'll ask the ext4 folks if they know of people downgrading filesystems
> > with tune2fs, but AFAIK it's not generally done.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > +.RE
> > > > +.TP
> > > >  .BI \-U " uuid"
> > > >  Set the UUID of the filesystem to
> > > >  .IR uuid .
> > > > 
> > > 
> > 
> 
