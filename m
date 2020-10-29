Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD02C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D39D920838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MeNduKps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJ2QrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:47:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgJ2Qpc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 12:45:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TGjQ9c047769;
        Thu, 29 Oct 2020 16:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5f+NODKZG2QyANjOuDDpQ0Ju9FLIiwynas7ucvKqYVY=;
 b=MeNduKpsMnBm2k3k1qozxIS4Vz6+RpgYMm+VFf3vtvlA5OZFelMAHY1zKjb+CEU6CbHY
 mR9V15V7eW12MVK0vHp+HBi1DT2SHpUxGgl+uDdHIy3Fc/mGtEiFRIZRxqN3y9+f4q5a
 dOaE9ehevADRze2w1/GRoLlD8ccvY1D+/1S/+IrMQM79ixrhJ281avg60h6Z+xzHaDZl
 u/w5qjXVB4/Mi7TvRFqSkA8h/DNnmiqszNEkRMdFSiJisF85vILnRnYoFMDfC+n543zQ
 27zPyI1Wf/75LcFzGzkYQw4pAgRTTglIKLkG7w0z3OZm+52WgMGYE4fIO5yEj2PwnNd7 dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m5wm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 16:45:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TGeBFY138449;
        Thu, 29 Oct 2020 16:45:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx60qdyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 16:45:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TGjSTt017854;
        Thu, 29 Oct 2020 16:45:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 09:45:27 -0700
Date:   Thu, 29 Oct 2020 09:45:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] repair: protect inode chunk tree records with a mutex
Message-ID: <20201029164526.GO1061252@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-4-david@fromorbit.com>
 <20201022060256.GO9832@magnolia>
 <20201022081505.GT7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022081505.GT7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 07:15:05PM +1100, Dave Chinner wrote:
> On Wed, Oct 21, 2020 at 11:02:56PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 22, 2020 at 04:15:33PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Phase 6 accesses inode chunk records mostly in an isolated manner.
> > > However, when it finds a corruption in a directory or there are
> > > multiple hardlinks to an inode, there can be concurrent access
> > > to the inode chunk record to update state.
> > > 
> > > Hence the inode record itself needs a mutex. This protects all state
> > > changes within the inode chunk record, as well as inode link counts
> > > and chunk references. That allows us to process multiple chunks at
> > > once, providing concurrency within an AG as well as across AGs.
> > > 
> > > The inode chunk tree itself is not modified in phase 6 - it's built
> > 
> > Well, that's not 100% true -- mk_orphanage can do that, but AFAICT
> > that's outside the scope of the parallel processing (and I don't see
> > much point in parallelizing that part) so I guess that's fine?
> 
> AFAICT, yes.

Ok, good, I'm confident I understand what's going on here. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> > > in phases 3 and 4  - and so we do not need to worry about locking
> > > for AVL tree lookups to find the inode chunk records themselves.
> > > hence internal locking is all we need here.
> > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > TBH I wonder if all the phase6.c code to recreate the root dir, the
> > orphanage, and the realtime inodes ought to get moved to another file,
> > particularly since the metadata directory patches add quite a bit more
> > stuff here?  But that's a topic for another patch...
> 
> Probably should and yes, spearate patch :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
