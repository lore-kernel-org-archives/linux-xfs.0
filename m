Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E938C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 18:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4EF20772
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 18:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="otiIuYB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgGBSej (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:34:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgGBSei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 14:34:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062IIGf1119098;
        Thu, 2 Jul 2020 18:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QQ0EtODhDIIMAVoxeXob9iGx9Az7cgSP7ufMcPnaEro=;
 b=otiIuYB3hoygfE4lI8ik1Duf3NIaZy8f/3SqzIzl4C8ZyJdwmTaxvq2Kefu8X3qWnjBA
 1eOXUzS2BLSyYHQGPLtqL+OU5Y+z0msN4/cwuVMY8aA9wb+zAPbwGYeWapVwNzfsAoSt
 IyPg2OjPT/0qMZ5raXigAcDeekst6T1OLSYQ8CPziQlP3n/ZRkJ21GHUCHR53UQuHKF2
 GKbxekz6LhJfh3siPX7Yq20k38a8e7XITzzdr0nzMKiXtDZMTYGrHNhTRxw/FV1Po+YM
 YTZZ4mutmCV7qmFfBPNaHS+sZrgwZU6L25xG+c4rTK/9172CRjOwT2m2dZFpp7CBgHcx qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrnj20e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 18:34:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062IWopI062886;
        Thu, 2 Jul 2020 18:34:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg1a01ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 18:34:34 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 062IYTil016090;
        Thu, 2 Jul 2020 18:34:29 GMT
Received: from localhost (/10.159.237.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 18:34:29 +0000
Date:   Thu, 2 Jul 2020 11:34:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: don't clear the "dinode core" in
 xfs_inode_alloc
Message-ID: <20200702183426.GD7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-2-hch@lst.de>
 <20200630175849.GM7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630175849.GM7606@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 10:58:49AM -0700, Darrick J. Wong wrote:
> On Sat, Jun 20, 2020 at 09:10:48AM +0200, Christoph Hellwig wrote:
> > The xfs_icdinode structure just contains a random mix of inode field,
> > which are all read from the on-disk inode and mostly not looked at
> > before reading the inode or initializing a new inode cluster.  The
> > only exceptions are the forkoff and blocks field, which are used
> > in sanity checks for freshly allocated inodes.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me thinks this looks ok, though I'm leaning on Chandan probably having
> done a more thorough examination than I did...

...which I should not have done, because this is not correct.

Prior to this patch, xfs_inode_alloc would always zero ip->i_d before
loading the inode in from disk.  xfs_inode_from_disk, in turn, didn't
have to worry about zeroing fields if it was reading in a v2 inode.
Hence it does nothing about i_diflags2 or i_crtime.

Unfortunately, this opens a crash vector.  Let's say you mount a V5 fs,
create some reflinked files, and unmount the V5 fs.  Next, you mount a
V4 fs, and if the slab reuses the incore inodes, the next
xfs_inode_alloc won't clear the v3inode fields, and neither will
xfs_inode_from_disk.  The xfs_is_reflink_inode helper will see the
REFLINK flag set in i_diflags2 (remember, nobody cleared it) and try to
do CoW things, and kaboom.

We could (should?) probably fix the helper, but we definitely cannot be
leaving nuggets like this around in memory from the previous occupants.

I suspect the (v3inode && IGET_CREATE && !MOUNT_IKEEP) case could also
be a (theoretical) future landmine.

FWIW I found this by running fstests with 'MKFS_OPTIONS="-m crc=0"' and
then running xfs/096 and then generic/456 in that order, though I think
reproducibility here depends on the luck of the draw wrt slab caches.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Withdrawn, for now...

--D

> 
> --D
> 
> > ---
> >  fs/xfs/xfs_icache.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 0a5ac6f9a58349..660e7abd4e8b76 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -66,7 +66,8 @@ xfs_inode_alloc(
> >  	memset(&ip->i_df, 0, sizeof(ip->i_df));
> >  	ip->i_flags = 0;
> >  	ip->i_delayed_blks = 0;
> > -	memset(&ip->i_d, 0, sizeof(ip->i_d));
> > +	ip->i_d.di_nblocks = 0;
> > +	ip->i_d.di_forkoff = 0;
> >  	ip->i_sick = 0;
> >  	ip->i_checked = 0;
> >  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
> > -- 
> > 2.26.2
> > 
