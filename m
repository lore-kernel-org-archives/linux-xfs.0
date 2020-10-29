Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4C2C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9ED520790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hF4Pf3b+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgJ2BDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:03:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39236 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729951AbgJ2BDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 21:03:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0jxJY044625;
        Thu, 29 Oct 2020 01:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8131klkizT4jC62dBxTgIhn3i3ABvASoY+tMsR1o6QY=;
 b=hF4Pf3b+5spdUWxMVm0VEvSSknKAN/bjhRSaeBn1aLjKBLS9m0VIe0YvGpxX1IKjWYRn
 iHcQwBEobbtkprJtRudIYEQ5jRIBXTQOBQw4Zot8Hi+kRRK0hrx1H1prJ534gOdzzctl
 BZAysf5MQE+hhhHE9Gr9Vq8Z7Dz9QQ0xjVsJRSEhAXEDT9IFwCnqpGcODznd/5p0D5zp
 UcmbnN7Ff+lI+8j8dUYMjz3vZIG4cqpTioBXN6G7fbVRIBfC3Hl6CF2k0vfCdEEIfuui
 nTU/Q5uCk1LzvTCrEovrLE1575BWf2hvdpPhx3i/KUdp0GPy0rsJXizxVHEjgp5F7l4s bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb2g3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 01:03:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0kNgV192967;
        Thu, 29 Oct 2020 01:01:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1smy8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 01:01:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09T11GG4020933;
        Thu, 29 Oct 2020 01:01:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 18:01:16 -0700
Date:   Wed, 28 Oct 2020 18:01:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs_repair: check inode btree block counters in AGI
Message-ID: <20201029010115.GH1061252@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375522427.880355.15446960142376313542.stgit@magnolia>
 <20201028172959.GE1611922@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028172959.GE1611922@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=5 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=5
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 01:29:59PM -0400, Brian Foster wrote:
> On Mon, Oct 26, 2020 at 04:33:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that both inode btree block counters in the AGI are correct.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/scan.c |   38 +++++++++++++++++++++++++++++++++++---
> >  1 file changed, 35 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/repair/scan.c b/repair/scan.c
> > index 2a38ae5197c6..c826af7dee86 100644
> > --- a/repair/scan.c
> > +++ b/repair/scan.c
> ...
> > @@ -2022,6 +2029,17 @@ scan_inobt(
> >  			return;
> >  	}
> >  
> > +	switch (magic) {
> > +	case XFS_FIBT_MAGIC:
> > +	case XFS_FIBT_CRC_MAGIC:
> > +		ipriv->fino_blocks++;
> > +		break;
> > +	case XFS_IBT_MAGIC:
> > +	case XFS_IBT_CRC_MAGIC:
> > +		ipriv->ino_blocks++;
> > +		break;
> > +	}
> > +
> 
> Is this intentionally not folded into the earlier magic switch
> statement?

I'd originally thought that we wouldn't want to count the block if it's
obviously bad, but the tree and the agi counter are supposed to be
consistent with each other, so yes, we should always bump the counter
when we are pointed towards a block.

> >  	/*
> >  	 * check for btree blocks multiply claimed, any unknown/free state
> >  	 * is ok in the bitmap block.
> ...
> > @@ -2393,6 +2414,17 @@ validate_agi(
> >  		}
> >  	}
> >  
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		if (be32_to_cpu(agi->agi_iblocks) != priv.ino_blocks)
> > +			do_warn(_("bad inobt block count %u, saw %u\n"),
> > +					priv.ino_blocks,
> > +					be32_to_cpu(agi->agi_iblocks));
> 
> These two params are backwards (here and below), no?

Oops.  Good catch!

--D

> Brian
> 
> > +		if (be32_to_cpu(agi->agi_fblocks) != priv.fino_blocks)
> > +			do_warn(_("bad finobt block count %u, saw %u\n"),
> > +					priv.fino_blocks,
> > +					be32_to_cpu(agi->agi_fblocks));
> > +	}
> > +
> >  	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
> >  		do_warn(_("agi_count %u, counted %u in ag %u\n"),
> >  			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);
> > 
> 
