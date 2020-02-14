Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76BAC35242
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 04:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DDB2168B
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 04:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KCAI7uBo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBNEYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 23:24:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbgBNEYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 23:24:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01E4MoNQ036281;
        Fri, 14 Feb 2020 04:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fHuJA1eykLrHlF3PdFmOKE15WLBsVcc26SFOatpZ3ms=;
 b=KCAI7uBoHMbhsE1kRIbZY16XfOotAUZF0P9BImPgKWICFswIEDo6Ymm3XqLOIcuPRX17
 yvzRXWTA5YQVwapCxx4g7iuVRSOZqnm6H1XWUxepMk2GuDWzUUtbv21TboMNAMuUtow8
 d+3TQRHHlEIPvgoeFfsWx9B9NeyedJlot4codRCfAJQ8awl8872ch4aPzxw+nWVNG5YB
 /1mwnFIvs8zbYfioBAh7Ku4WCCEm+HyZlLlNX4FElbFYIeFa4omkwIYn35zSfWKHmFQT
 IHCeht7z5eUfFleoNX4U+MEOK9zu0FWKUWcsbTpZ4K5Qpg863Hm9/ZFSuBp95EqHJ0Ao Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y2jx6puj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 04:24:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01E4LtEq053945;
        Fri, 14 Feb 2020 04:24:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y4k8172m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 04:24:38 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01E4ObeW006630;
        Fri, 14 Feb 2020 04:24:37 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Feb 2020 20:24:37 -0800
Date:   Thu, 13 Feb 2020 20:24:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: refactor attr root block pointer check
Message-ID: <20200214042438.GH6870@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086358798.2079557.6562544272527988911.stgit@magnolia>
 <dc1d5144-4438-2d3c-61b8-70ff80c0fa33@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1d5144-4438-2d3c-61b8-70ff80c0fa33@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 05:14:57PM -0600, Eric Sandeen wrote:
> On 2/4/20 6:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In process_longform_attr, replace the agcount check with a call to the
> > fsblock verification function in libxfs.  Now we can also catch blocks
> > that point to static FS metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/attr_repair.c |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > index 9a44f610..7b26df33 100644
> > --- a/repair/attr_repair.c
> > +++ b/repair/attr_repair.c
> > @@ -980,21 +980,21 @@ process_longform_attr(
> >  	*repair = 0;
> >  
> >  	bno = blkmap_get(blkmap, 0);
> > -
> > -	if ( bno == NULLFSBLOCK ) {
> > +	if (bno == NULLFSBLOCK) {
> >  		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> >  				be16_to_cpu(dip->di_anextents) == 0)
> >  			return(0); /* the kernel can handle this state */
> >  		do_warn(
> >  	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
> >  			ino);
> > -		return(1);
> > +		return 1;
> >  	}
> > +
> >  	/* FIX FOR bug 653709 -- EKN */
> > -	if (mp->m_sb.sb_agcount < XFS_FSB_TO_AGNO(mp, bno)) {
> > +	if (!xfs_verify_fsbno(mp, bno)) {
> >  		do_warn(
> >  	_("agno of attribute fork of inode %" PRIu64 " out of regular partition\n"), ino);
> 
> I'll change this to
> 
> "block in attribute fork of inode %" PRIu64 " is not valid"

Sounds good!

--D

> ok?
> 
> > -		return(1);
> > +		return 1;
> >  	}
> >  
> >  	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> > 
