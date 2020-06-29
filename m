Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011FBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15FD20776
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kg7lsmx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgF2XMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:12:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgF2XME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 19:12:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN7PYE041659;
        Mon, 29 Jun 2020 23:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9dai/RgjidNgVTNOPB2prrdQaQ/NALIcgpKRmWrXStI=;
 b=kg7lsmx+dvanwnJImUx3CPi2PYooquGAlo3hls6rNRGD4ItG9G5eLZmikXLD8kiZlrCb
 wZRaw4BUsIT2JCpcsklpYUqOwUJx3ascJ5XTh/wvAMOBLhRedWB5L2hYMl7HgUJrVG8A
 HDMx7R89HcVHtCe/k3+dHygbb+aHLJ6jya81XqhBvVaZeh66xq2vdhc5vqVCn2JNAYCV
 jsWEj6atGHM4ZDiLk1Lycx7SSOJkdYXJWB4NXZvLYLGdBmi/R/Q/Fw55t3D67ZPXhCy0
 tx8iQB1UHEAbANDVW9UdKSg39Vbp9Mj3pEVWJgd06aOPbVGwuhQ71Dy+XzlYKSW7Y7G+ Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31wwhrh73b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 23:11:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN8ecm003313;
        Mon, 29 Jun 2020 23:11:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg11mcws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 23:11:58 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05TNBwYx024896;
        Mon, 29 Jun 2020 23:11:58 GMT
Received: from localhost (/10.159.231.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 23:11:57 +0000
Date:   Mon, 29 Jun 2020 16:11:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: complain about ag header crc errors
Message-ID: <20200629231157.GU7606@magnolia>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835284.1065505.8957820680195453723.stgit@magnolia>
 <20200629122031.GA10449@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629122031.GA10449@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=5 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 29, 2020 at 08:20:31AM -0400, Brian Foster wrote:
> On Thu, Jun 25, 2020 at 01:52:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Repair doesn't complain about crc errors in the AG headers, and it
> > should.  Otherwise give the admin the wrong impression about the

"Otherwise, this gives the admin the wrong impression..."

I'll fix this before the next repost, though if the maintainer chooses
to pull it in before then, please make this minor correction.

> > state of the filesystem after a nomodify check.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/scan.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > 
> > diff --git a/repair/scan.c b/repair/scan.c
> > index 505cfc53..42b299f7 100644
> > --- a/repair/scan.c
> > +++ b/repair/scan.c
> > @@ -2441,6 +2441,8 @@ scan_ag(
> >  		objname = _("root superblock");
> >  		goto out_free_sb;
> >  	}
> > +	if (sbbuf->b_error == -EFSBADCRC)
> > +		do_warn(_("superblock has bad CRC for ag %d\n"), agno);
> 
> So salvage_buffer() reads the buf and passes along the verifier. If the
> verifier fails, we ignore the error and return 0 because of
> LIBXFS_READBUF_SALVAGE, but leave it set in bp->b_error so it should be
> accessible here. Looks Ok:

Yep.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D

> 
> >  	libxfs_sb_from_disk(sb, sbbuf->b_addr);
> >  
> >  	error = salvage_buffer(mp->m_dev,
> > @@ -2450,6 +2452,8 @@ scan_ag(
> >  		objname = _("agf block");
> >  		goto out_free_sbbuf;
> >  	}
> > +	if (agfbuf->b_error == -EFSBADCRC)
> > +		do_warn(_("agf has bad CRC for ag %d\n"), agno);
> >  	agf = agfbuf->b_addr;
> >  
> >  	error = salvage_buffer(mp->m_dev,
> > @@ -2459,6 +2463,8 @@ scan_ag(
> >  		objname = _("agi block");
> >  		goto out_free_agfbuf;
> >  	}
> > +	if (agibuf->b_error == -EFSBADCRC)
> > +		do_warn(_("agi has bad CRC for ag %d\n"), agno);
> >  	agi = agibuf->b_addr;
> >  
> >  	/* fix up bad ag headers */
> > 
> 
