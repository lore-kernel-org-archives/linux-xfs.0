Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAA2C04EBE
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 14:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05A621974
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 14:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ixND7iS4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgJHOsF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 10:48:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730717AbgJHOsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 10:48:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Ee0Aq026496;
        Thu, 8 Oct 2020 14:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=69WzQxWkjh+/MW/FrtcmF+6D7ugDOh7J1/UY46rNXSk=;
 b=ixND7iS45W9D/vNHvekZmlyHJwXL4d2OPbAtbfgPW/efbcTTWgvLMg1y7JX1MUHrxpj9
 B59Il+BMRewJzbX4rbtEo/L3SDFsY+06W1Y0GfDmMmEuWXpkcWdJvzfzXM/AApSivYDx
 b6AWnr/BQFI8soLJbefzdP3IqjJ4OoKgo5QIdUgK+uc0lCB+HoqqXt7LfYs8IWYubqjO
 tUYm2HuxjtkhCeUcXLDEAcju/g/jRwk6iC62xaOikd3bCO50EPxTcZd9J7XbREnk7ptr
 nQIDZnKPZ8cPVoVht5rxFcjCerYAUpu3qqICR3r8pVY+UqFIJFr00GlaO9Rr6emg8gCP VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34w7jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 14:48:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098EfFQW148989;
        Thu, 8 Oct 2020 14:48:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 341xnbsff4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 14:47:59 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098Elx5K002776;
        Thu, 8 Oct 2020 14:47:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 07:47:58 -0700
Date:   Thu, 8 Oct 2020 07:47:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 2/2] xfs: make xfs_growfs_rt update secondary superblocks
Message-ID: <20201008144758.GK6540@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia>
 <160212937238.248573.3832120826354421788.stgit@magnolia>
 <4070961.BB4q84YiFQ@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4070961.BB4q84YiFQ@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=5 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080112
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 01:01:59PM +0530, Chandan Babu R wrote:
> On Thursday 8 October 2020 9:26:12 AM IST Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we call growfs on the data device, we update the secondary
> > superblocks to reflect the updated filesystem geometry.  We need to do
> > this for growfs on the realtime volume too, because a future xfs_repair
> > run could try to fix the filesystem using a backup superblock.
> > 
> > This was observed by the online superblock scrubbers while running
> > xfs/233.  One can also trigger this by growing an rt volume, cycling the
> > mount, and creating new rt files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 1c3969807fb9..5b2e68d9face 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -18,7 +18,7 @@
> >  #include "xfs_trans_space.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_rtalloc.h"
> > -
> > +#include "xfs_sb.h"
> >  
> >  /*
> >   * Read and return the summary information for a given extent size,
> > @@ -1108,6 +1108,11 @@ xfs_growfs_rt(
> >  	 */
> >  	kmem_free(nmp);
> >  
> > +	/* Update secondary superblocks now the physical grow has completed */
> > +	error = xfs_update_secondary_sbs(mp);
> > +	if (error)
> > +		return error;
> > +
> 
> If any of the operations in the previous "for" loop causes "error" to be set
> and the loop to be exited, the call to xfs_update_secondary_sbs() would
> overwrite this error value. In the worst case it might set error to 0 and
> hence return a success status to the caller when the growfs operation
> had actually failed.

Oops, good catch!

--D

> -- 
> chandan
> 
> 
> 
