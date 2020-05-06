Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0FCC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 18:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB5120736
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 18:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mW5uBEyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgEFSgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 14:36:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729757AbgEFSgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 14:36:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046IHous161164;
        Wed, 6 May 2020 18:36:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wBW022NxeN9piXXsYiD6MDCFdo+8IlMf6qEiD32jQMk=;
 b=mW5uBEyDVTXuhRquAsKtkhUEWgNH2+le9kpjgTTQv4W5ZDiSvMUxmPCvCFdajWxod0y+
 8i2HU3rXBi/ZOb3WaKOXz3JG02+j5EFwinr3oyzQxvXnCb3g0ScaYzUqeOVVrzTEsj+4
 8fQw2ip6cA1luYm2IdqEtbrK4yASdipmZFhDeLl6VrubJvpAIlVvFR4w/jUAJNywFGlG
 93Q2KH0K3exFnSckYy7SADIAzC6IuOnCV8XORJ+yBscHUYcDRE4XQs580k2Mfh6xQPYl
 v2qJuz81e8LkL7zeKHwZ03myi5vHo4pXJt44mpg+w/og/Re8+rGuAx6VE1WJxqVdetSv iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09rc45y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 18:36:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046Ia1LN147607;
        Wed, 6 May 2020 18:36:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r8f77t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 18:36:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046Ia5tR029314;
        Wed, 6 May 2020 18:36:05 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 11:36:05 -0700
Date:   Wed, 6 May 2020 11:36:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/28] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200506183603.GA6714@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864104502.182683.672673211897001126.stgit@magnolia>
 <20200506150324.GE7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506150324.GE7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=5
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=5
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:03:24AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:10:45PM -0700, Darrick J. Wong wrote:
> > +const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
> > +	.item_type		= XFS_LI_BUI,
> > +};
> > +
> > +const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
> > +	.item_type		= XFS_LI_BUD,
> > +};
> 
> Pretty much everything else in this file seems to use bui/bud names.
> The same also applies to the four other intent/done pairs and their
> shortnames.  Not really a major thing, but it might be worth fixing
> to fit the flow.

Ok.

> > +STATIC enum xlog_recover_reorder
> > +xlog_recover_buf_reorder(
> > +	struct xlog_recover_item	*item)
> > +{
> > +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> > +
> > +	if (buf_f->blf_flags & XFS_BLF_CANCEL)
> > +		return XLOG_REORDER_CANCEL_LIST;
> > +	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> > +		return XLOG_REORDER_INODE_BUFFER_LIST;
> > +	return XLOG_REORDER_BUFFER_LIST;
> > +}
> 
> While you split this out a comment explaining the reordering would
> be nice here.

Ok.

/*
 * Sort buffer items for log recovery.  Most buffer items should end up
 * on the buffer list and are recovered first, with the following
 * exceptions:
 *
 * 1. XFS_BLF_CANCEL buffers must be processed last because some log
 *    items might depend on the incor ecancellation record, and
 *    replaying a cancelled buffer item can remove the incore record.
 *
 * 2. XFS_BLF_INODE_BUF buffers are handled after most regular items so
 *    that we replay di_next_unlinked only after flushing the inode
 *    'free' state to the inode buffer.
 *
 * See xlog_recover_reorder_trans for more details.
 */

--D

> Otherwise this looks great:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
