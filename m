Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59881CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0F9206DD
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 15:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mv2InQP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgELPxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 11:53:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbgELPxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 11:53:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFr2bE022331;
        Tue, 12 May 2020 15:53:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a+EYRU2WDc/BQELx3QzEo7aq6lQZvCD6lYdW+gkEXDg=;
 b=Mv2InQP/VJc36QRaX1/ODPcLtjBbT14V/XcGIdnFNl6/9wD6LODtM+B1Ap8elCMPZJJM
 g2oe41FQC+ksTzRBLvnkkr29OB1/3yNImne1QoxvhllRHSwbBtkudNvyLe5ZphbuJ9wM
 0vM/fo9pTrWIbxuhYVOKEW7sdyEuukUtW4Bh6bxkBNkezrjZRtS8W1Kct7fBHRwlOToy
 P3u3Org43zt9wlgiSiSnCHcYzjNdlwvbK7yYPpTEHZbB5/jgx3XJwbW5nOOwZiAsA3SE
 UZ3F5JB9+HmeujrxhJ+Mn3/psQoVY+iyetyejKACNAqyhnYxMgh3y+EmYu4ggkSxmEt9 uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30x3gskuv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 15:53:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFqZ19165134;
        Tue, 12 May 2020 15:53:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30xbgk356v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 15:53:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CFrLbr011543;
        Tue, 12 May 2020 15:53:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 08:53:21 -0700
Date:   Tue, 12 May 2020 08:53:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3
 leaf block
Message-ID: <20200512155320.GD6714@magnolia>
References: <20200511185016.33684-1-bfoster@redhat.com>
 <20200512081037.GB28206@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512081037.GB28206@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 01:10:37AM -0700, Christoph Hellwig wrote:
> On Mon, May 11, 2020 at 02:50:16PM -0400, Brian Foster wrote:
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > What do folks think of something like this? We have a user report of a
> > corresponding read verifier failure while processing unlinked inodes.
> > This presumably means the attr fork was put in this state because the
> > format conversion and xattr set are not atomic. For example, the
> > filesystem crashed after the format conversion transaction hit the log
> > but before the xattr set transaction. The subsequent recovery succeeds
> > according to the logic below, but if the attr didn't hit the log the
> > leaf block remains empty and sets a landmine for the next read attempt.
> > This either prevents further xattr operations on the inode or prevents
> > the inode from being removed from the unlinked list due to xattr
> > inactivation failure.
> > 
> > I've not confirmed that this is how the user got into this state, but
> > I've confirmed that it's possible. We have a couple band aids now (this
> > and the writeback variant) that intend to deal with this problem and
> > still haven't quite got it right, so personally I'm inclined to accept
> > the reality that an empty attr leaf block is an expected state based on
> > our current xattr implementation and just remove the check from the
> > verifier (at least until we have atomic sets). I turned it into a
> > warning/comment for the purpose of discussion. Thoughts?
> 
> If the transaction is not atomic I don't think we should even
> warn in this case, even if it is unlikely to happen..

I was gonna say, I think we've messed this up enough that I think we
just have to accept empty attr leaf blocks. :/

I also think we should improve the ability to scan for and invalidate
incore buffers so that we can invalidate and truncate the attr fork
extents directly from an extent walk loop.  It seems a little silly that
we have to walk the dabtree just to find out where multiblock remote
attr value structures might be hiding.

--D
