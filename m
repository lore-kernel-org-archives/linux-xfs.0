Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C480C47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 03:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0E2206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 03:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QwSGRsq/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJJDFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:05:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfJJDFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 23:05:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A34FSY092825;
        Thu, 10 Oct 2019 03:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tN8Rnr2mCzbLUIDgu6y4W/ytSHUcSyRZvmEHkou5ry8=;
 b=QwSGRsq/CWctR2Bd1Bi86GGarpPPwE95nVtTK2Br9mJernPHhiC6UMjyACnNqSnH8A3A
 qI1rq/2e4Fvs8YgngwPtzujZPQ6KbYNPlMlJEOcorhEvk3/QYGgjA6zG/R6Zc747dutx
 0dnioHisMYwnWqKz+aXLV7+sqZhk02bvxsLjI31kOmhVSLCa2YNq6H3gbFdlvJX6FbRn
 Lca72hMMvlx5XNFb+rsz/O3whiEgqVHCXmAM3MY8Fsp+23dqZ8fUJASX/SjNpZoGmwYW
 AtCW8Tc+G3xRbTAf1ZMkO36gSU7bA9/fZJmPKL8Wy+rTRzg0658WSvmSIhnpnXd9/B98 Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vektrr33c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:05:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A33nKQ095941;
        Thu, 10 Oct 2019 03:05:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vhhsnsjre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:05:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A35m1E010594;
        Thu, 10 Oct 2019 03:05:48 GMT
Received: from localhost (/10.159.141.211)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 20:05:47 -0700
Date:   Wed, 9 Oct 2019 20:05:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs_scrub: fix per-thread counter error
 communication problems
Message-ID: <20191010030547.GB13098@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
 <156944725787.297677.340556438029903962.stgit@magnolia>
 <2eff88dc-29bc-5164-c9a3-cc293c1bfc3b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eff88dc-29bc-5164-c9a3-cc293c1bfc3b@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:46:36PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:34 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix all the places in the per-thread counter functions either we fail to
> > check for runtime errors or fail to communicate them properly to
> > callers.  Then fix all the callers to report the error messages instead
> > of hiding them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/counter.c     |   33 ++++++++++++++++++---------------
> >  scrub/counter.h     |    6 +++---
> >  scrub/phase3.c      |   23 +++++++++++++++++------
> >  scrub/progress.c    |   12 +++++++++---
> >  scrub/read_verify.c |    9 ++++++---
> >  5 files changed, 53 insertions(+), 30 deletions(-)
> 
> ...
> 
> > @@ -282,5 +282,8 @@ uint64_t
> >  read_verify_bytes(
> >  	struct read_verify_pool		*rvp)
> >  {
> > -	return ptcounter_value(rvp->verified_bytes);
> > +	uint64_t			ret;
> > +
> > +	ptcounter_value(rvp->verified_bytes, &ret);
> > +	return ret;
> >  }
> 
> IMHO this is a confusing use of "ret" which is normally return status but
> here it is the sum?  And errors are ignored? We just get a ret ("sum") of zero?

For now, yes.  The patch "xfs_scrub: fix read-verify pool error
communication problems" in the next series will fix a bunch of error
handling problems in the read_verify.c functions.

(I'm trying only to change the direct ptvar.c callers in this patch...)

--D
