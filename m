Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229A5C38BFF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB21C21927
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDnvBlZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBXW1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:27:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgBXW1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:27:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OMIuBY164850;
        Mon, 24 Feb 2020 22:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MYL5pZeVn13putx8li9Wcobo4LAxRpiHzz+7Qr9yWKs=;
 b=YDnvBlZshSr3rcqmMuV6ZdkZZOtcOAgEk6xNxfRKEdJe3URw4FsioxYfMs97xgbooBP7
 d2mjG9qN5PbmTuasJb61hq6gCWac0ToSJR44TBczmMWxGJuGNCZE5/J2tWzQz6zSJXks
 Arkj39+7eZ65RAb8VXX5EMGqgRupdJkv1G0r6JQFBxlsUMbRbqptQz4KaF91FB1TVcsZ
 hGSfTWSv1stMv0qlu39hj9sQ7UWLNwoen/YXRsOVkJGkgv9RcpNqkWjFfFD0zHEQDpBK
 nH+GaCSMl9dfcyN9dpUS6IImKloI8hSUpC3sR3aXHZ/O65pMLeq1k5DDy01n1IlJNYaX XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yavxrjdta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 22:27:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OMQcCn182279;
        Mon, 24 Feb 2020 22:27:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduvat7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 22:27:39 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OMRcYF008872;
        Mon, 24 Feb 2020 22:27:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 14:27:38 -0800
Date:   Mon, 24 Feb 2020 14:27:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224222737.GB6740@magnolia>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
 <20200224221931.GA6740@magnolia>
 <20200224222118.GA681@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224222118.GA681@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:21:18PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 02:19:31PM -0800, Darrick J. Wong wrote:
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Any chance we can pick this up for 5.6 to unbreak arm OABI?
> > 
> > Yeah, I can do that.  Is there a Fixes: tag that goes with this?
> 
> I'm not sure what to add.  I think the problem itself has actually
> always been around since adding v5 fs support.  But the build break
> was only caused by the addition of the BUILD_BUG_ON.

Hmm.  That's tricky, since in theory this should go all the way back to
the introduction of the v5 format in 3.x, but that's going to require
explicit backporting to get past all the reorganization and other things
that have happened.  We might just have to hand-backport it to the
stable kernels seeing how the macro name change will probably cause all
sorts of problems with AI backports. :/

> > Also, will you have a chance to respin the last patch for 5.7?
> 
> Last patch in this series?

Yes.  From the discussion of patch 6/6,

"+   __xfs_sb_from_disk(&sb, bp->b_addr, false);

"why not dsb here

"Yes, this should just pass dsb."

--D

