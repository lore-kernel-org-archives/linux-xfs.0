Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990B2C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD2422260
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hKkr3AoS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbgJIPVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 11:21:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388745AbgJIPVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 11:21:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099FKCvZ095901;
        Fri, 9 Oct 2020 15:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PVHKRQ3J4gMOqHuHGQGF2dTetDUrchuuMPi2MuW5MSM=;
 b=hKkr3AoSCtiHaOmZ5FD8WuNvGUoJ9+ulJ4Au1JZI2nfLTshhzPmlOODn4cmIBMPWY2UI
 aiIMTdCCnXu9rzdGOLMWCEeJuxLjrn+11yAVSP5E7ylSjGcOgoHlkPKCS2uhY1T0s9MC
 FeIdqPyKfDMk1YtbSKiNo7hL9RMlktkWuNm9xMkhXgEvyGLb83m+tgt9eNQv3cqPpw61
 +1NYLqD1c+nZ1uN72HFpglqMI9q4sdUL0kNmVxRYA3f9/YGF0IsNKBjE/2K0AMJ5AvKW
 tSTY/q9dw+jwuf8X4lLwPy6UtwirKSVB8ilIaj1MXzWHgMjKjzuifNkExDx/ztrcALyE lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3429juv4s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 09 Oct 2020 15:21:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099FL3aJ181614;
        Fri, 9 Oct 2020 15:21:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3429kbe3pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Oct 2020 15:21:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 099FLSfN012159;
        Fri, 9 Oct 2020 15:21:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Oct 2020 08:21:28 -0700
Date:   Fri, 9 Oct 2020 08:21:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH v2.2 2/3] xfs: make xfs_growfs_rt update secondary
 superblocks
Message-ID: <20201009152126.GS6540@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia>
 <160216933700.313389.9746852330724569803.stgit@magnolia>
 <20201008221905.GR6540@magnolia>
 <2785429.vsROyPpyBe@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2785429.vsROyPpyBe@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0
 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=5 lowpriorityscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010090114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 03:21:38PM +0530, Chandan Babu R wrote:
> On Friday 9 October 2020 3:49:05 AM IST Darrick J. Wong wrote:
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
> > v2.2: don't update on error, don't fail to free memory on error
> > ---
> >  fs/xfs/xfs_rtalloc.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 1c3969807fb9..f9119ba3e9d0 100644
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
> > @@ -1102,7 +1102,13 @@ xfs_growfs_rt(
> >  		if (error)
> >  			break;
> >  	}
> > +	if (error)
> > +		goto out_free;
> >  
> > +	/* Update secondary superblocks now the physical grow has completed */
> > +	error = xfs_update_secondary_sbs(mp);
> > +
> > +out_free:
> >  	/*
> >  	 * Free the fake mp structure.
> >  	 */
> > 
> 
> How about ...
> 
> if (!error) {
> 	/* Update secondary superblocks now the physical grow has completed */
> 	error = xfs_update_secondary_sbs(mp);
> }
> 
> /*
>  * Free the fake mp structure.
>  */
> ...
> ... 
> 
> With the above construct we can get rid of the goto label.

I'd rather not start doing that, because (a) we generally don't do that
in xfs and (b) in a cycle or two I'm going to add more in-memory state
changes between the secondary super update and freeing the fake mp, and
I'd prefer to start all that by having the error case jump to out_free.

--D

> -- 
> chandan
> 
> 
> 
