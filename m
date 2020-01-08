Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D71FC282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3C6D205F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nkI2fj1O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgAHRWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:22:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729748AbgAHRWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 12:22:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008HJ0wB081445;
        Wed, 8 Jan 2020 17:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lmpd3GudUxaEZpwqwNUvLcjXeorT931cpobPy3OpZTM=;
 b=nkI2fj1O9jMOPpbf0Eo3SYFEvp4naJ9hWL1GjbXy4p+bt0IHqchHcVNjP6Uhily1P6rG
 Fx1k459HJeGTSntL11tJcKsl01Q47RujJ1k7rgnKuKRS6JkzjKTTEcC7rGLWiegWgozB
 ppk/UgXobrXXXi9pI3iIoHf0+yNEv8pVgbUCf+ZhdmgsjKjH9/dSsnYNRszpSAGDUfTL
 rzBrNmvtJOp1/qLfxHdAysHC1OlcLNErqIwdm5zDxxpo4vQQ96+Ww1rJdR3KVtGu70y3
 ndpsanD6MNXd7usX01XEKf+kkVj622nDvhN6nuKbvkqKRYdtLh9uSOkmNz9HbKl//70g Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xakbqw8vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 17:22:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008HJEmG045696;
        Wed, 8 Jan 2020 17:22:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpct3yxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 17:22:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 008HMkM6002563;
        Wed, 8 Jan 2020 17:22:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 09:22:46 -0800
Date:   Wed, 8 Jan 2020 09:22:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: complain if anyone tries to create a too-large
 buffer log item
Message-ID: <20200108172243.GJ5552@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845709897.84011.1433283906403215456.stgit@magnolia>
 <20200108085131.GB12889@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108085131.GB12889@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 12:51:31AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 07, 2020 at 08:18:19PM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 3984779e5911..bfbe8a5b8959 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -761,18 +761,25 @@ xfs_buf_item_init(
> >  	 * buffer. This makes the implementation as simple as possible.
> >  	 */
> >  	error = xfs_buf_item_get_format(bip, bp->b_map_count);
> > -	ASSERT(error == 0);
> > -	if (error) {	/* to stop gcc throwing set-but-unused warnings */
> > -		kmem_cache_free(xfs_buf_item_zone, bip);
> > -		return error;
> > +	if (error) {
> > +		xfs_err(mp, "could not allocate buffer item, err=%d", error);
> > +		goto err;
> >  	}
> 
> The error handling here is weird, as xfs_buf_item_get_format can't fail
> to start with.  I'd rather see a prep patch removing the bogus check
> for the kmem_zalloc and change the return value from
> xfs_buf_item_get_format to void.
> 
> Otherwise the patch looks good.

Ok.

--D
