Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id 1D50F7880
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 11:41:29 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgCKQmO (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 12:42:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCKQmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 12:42:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BGdtH7108790;
        Wed, 11 Mar 2020 16:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fVldC8M49mT69XgR03HjC8gWF3PHzPkPMgiEmPD9Pvo=;
 b=zIGXBGKpMqcpqdSvsSwjUMqRZsuygWu8iZxUN+qzebgEsW0TuLgy3ztTS4F08T+QwY4a
 gtMgQblj02+LkY6I2XeptIYJ5JWmz+YqxRnrz7SbGnqqgTBYJa4re09Z8ywJ4kZ4X1Hy
 Wl81WrYNTCUohv2vkgxLtxnKebyMhZzj0bfUg87NqTYUSEJJ9RdUmNib0d14nA/8ue+D
 Jih0+QBAzK6GEWwKtTa0f9LBWo0tfdqCeR0yTCsQ0YANPAN5qNwcYEqqh+oT3Lelqe13
 SSxK9CyBhJnAzKs3IldE7nrq3e1n7/MeH0309LX2+u3l+RPJzoNJLuKbaIghjgmNS+mo xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yp7hm97kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:42:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BGcSm0063058;
        Wed, 11 Mar 2020 16:42:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yp8qx4frs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:42:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02BGgARQ027231;
        Wed, 11 Mar 2020 16:42:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 09:42:10 -0700
Date:   Wed, 11 Mar 2020 09:42:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: add a function to deal with corrupt buffers
 post-verifiers
Message-ID: <20200311164209.GR1752567@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388763904.939165.1796274155705134706.stgit@magnolia>
 <20200311053559.GU10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311053559.GU10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 04:35:59PM +1100, Dave Chinner wrote:
> On Tue, Mar 10, 2020 at 05:47:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a helper function to get rid of buffers that we have decided are
> > corrupt after the verifiers have run.  This function is intended to
> > handle metadata checks that can't happen in the verifiers, such as
> > inter-block relationship checking.  Note that we now mark the buffer
> > stale so that it will not end up on any LRU and will be purged on
> > release.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> ....
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 11a97bc35f70..9d26e37f78f5 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -16,6 +16,8 @@
> >  #include "xfs_log.h"
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_buf_item.h"
> >  
> >  static kmem_zone_t *xfs_buf_zone;
> >  
> > @@ -1572,6 +1574,29 @@ xfs_buf_zero(
> >  	}
> >  }
> >  
> > +/*
> > + * Log a message about and stale a buffer that a caller has decided is corrupt.
> > + *
> > + * This function should be called for the kinds of metadata corruption that
> > + * cannot be detect from a verifier, such as incorrect inter-block relationship
> > + * data.  Do /not/ call this function from a verifier function.
> 
> So if it's called from a read verifier, the buffer will not have the
> XBF_DONE flag set on it. Maybe we should assert that this flag is
> set on the buffer? Yes, I know XBF_DONE will be set at write time,
> but most verifiers are called from both the read and write path so
> it should catch invalid use at read time...

<nod>

> 
> > + * The buffer must not be dirty prior to the call.  Afterwards, the buffer will
> 
> Why can't it be dirty?

There isn't a technical reason why this function cannot handle a dirty
buffer, but it seems like a mistake in data handling to dirty a buffer
and /then/ decide it's garbage.  That's what the lengthy assertion below
is about...

> > + * be marked stale, but b_error will not be set.  The caller is responsible for
> > + * releasing the buffer or fixing it.
> > + */
> > +void
> > +__xfs_buf_mark_corrupt(
> > +	struct xfs_buf		*bp,
> > +	xfs_failaddr_t		fa)
> > +{
> > +	ASSERT(bp->b_log_item == NULL ||
> > +	       !(bp->b_log_item->bli_flags & XFS_BLI_DIRTY));
> 
> XFS_BLI_DIRTY isn't a complete definition of a dirty buffer. What it
> means is "modifications to this buffer are not yet
> committed to the journal". It may have been linked into a
> transaction but not modified, but it can still be XFS_BLI_DIRTY
> because it is in the CIL. IOWs, transactions can cancel safely
> aborted even when the items in it are dirty as long as the
> transaction itself is clean and made no modifications to the object.
> 
> Hence I'm not sure what you are trying to protect against here?

...ah, ok, I'll just get rid of the assertion entirely then.

--D

> 
> The rest of the code looks fine.
> 
> Cheers,
> 
> Dave,
> -- 
> Dave Chinner
> david@fromorbit.com

