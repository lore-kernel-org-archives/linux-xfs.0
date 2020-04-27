Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FF9C82A00
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 22:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B8E20575
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 22:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tyec2B1Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgD0WGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 18:06:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgD0WGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 18:06:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RM2lFP190941;
        Mon, 27 Apr 2020 22:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=izlqrJ0CK9RODZXQrmAxQtWoDporb/zUuXL476iSC4g=;
 b=Tyec2B1ZQqWZm6O0zoMctTRXkrMs29o1P7dMpVTdVEqneDBrchc8bTuzAcplABwW2Q+a
 TQlEH7GKPTvnkGhUiiLf38bgMy5RC6poLQYtSKlcOtRicqxFCG/09O0au1qH5BaW7iZH
 HwpEl6bvg1PAiI1qXbvO1Zc8vwqJ1AmWx1yEYgxfQMUbK+8VXNuG9/W+/tibBRrJfpf5
 txb/UFEdbCcaMseCf74E/pZZuxd8Ew7LIlC2SfJDkRCIrtZWO7vYO8qIn3rd+Mk0o33z
 6EtEHScLiOoJ+icF2TK/k8pOOpu5HcAyktLODuLMlyKTAqQHxM7ISRkY/qmAIjcrU5Ng Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucfvbn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:06:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RM2tHR037859;
        Mon, 27 Apr 2020 22:04:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0arndx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:04:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RM4DbW007335;
        Mon, 27 Apr 2020 22:04:13 GMT
Received: from localhost (/10.159.157.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 15:04:13 -0700
Date:   Mon, 27 Apr 2020 15:04:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/19] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200427220412.GY6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752117554.2140829.4901314701479350791.stgit@magnolia>
 <20200425181307.GA16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200425181307.GA16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:13:07AM -0700, Christoph Hellwig wrote:
> > +
> > +/* Sorting hat for log items as they're read in. */
> > +enum xlog_recover_reorder {
> > +	XLOG_REORDER_UNKNOWN,
> > +	XLOG_REORDER_BUFFER_LIST,
> > +	XLOG_REORDER_CANCEL_LIST,
> > +	XLOG_REORDER_INODE_BUFFER_LIST,
> > +	XLOG_REORDER_INODE_LIST,
> 
> XLOG_REORDER_INODE_LIST seems a bit misnamed as it really is the
> "misc" or "no reorder" list.  I guess the naming comes from the
> local inode_list variable, but maybe we need to fix that as well?

Yes, thanks for the series fixing that.

> > +typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
> > +		struct xlog_recover_item *item);
> 
> This typedef doesn't actually seem to help with anything (neither
> with just thіs patch nor the final tree).

Fair enough.

> > +
> > +struct xlog_recover_item_type {
> > +	/*
> > +	 * These two items decide how to sort recovered log items during
> > +	 * recovery.  If reorder_fn is non-NULL it will be called; otherwise,
> > +	 * reorder will be used to decide.  See the comment above
> > +	 * xlog_recover_reorder_trans for more details about what the values
> > +	 * mean.
> > +	 */
> > +	enum xlog_recover_reorder	reorder;
> > +	xlog_recover_reorder_fn		reorder_fn;
> 
> I'd just use reorder_fn and skip the simple field.  Just one way to do
> things even if it adds a tiny amount of boilerplate code.

<nod>

> > +	case XFS_LI_INODE:
> > +		return &xlog_inode_item_type;
> > +	case XFS_LI_DQUOT:
> > +		return &xlog_dquot_item_type;
> > +	case XFS_LI_QUOTAOFF:
> > +		return &xlog_quotaoff_item_type;
> > +	case XFS_LI_IUNLINK:
> > +		/* Not implemented? */
> 
> Not implemented!  I think we need a prep patch to remove this first.

The thing I can't tell is if XFS_LI_IUNLINK is a code point reserved
from some long-ago log item that fell out, or reserved for some future
project?

Either way, this case doesn't need to be there.

> > @@ -1851,41 +1890,34 @@ xlog_recover_reorder_trans(
> >  
> >  	list_splice_init(&trans->r_itemq, &sort_list);
> >  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> > -		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
> > +		enum xlog_recover_reorder	fate = XLOG_REORDER_UNKNOWN;
> > +
> > +		item->ri_type = xlog_item_for_type(ITEM_TYPE(item));
> 
> I wonder if just passing the whole item to xlog_item_for_type would
> make more sense.  It would then need a different name, of course.

xlog_set_item_type(item); yes.

> > +		if (item->ri_type) {
> > +			if (item->ri_type->reorder_fn)
> > +				fate = item->ri_type->reorder_fn(item);
> > +			else
> > +				fate = item->ri_type->reorder;
> > +		}
> 
> I think for the !item->ri_type we should immediately jump to what
> currently is the XLOG_REORDER_UNKNOWN case, and thus avoid even
> adding XLOG_REORDER_UNKNOWN to the enum.  The added benefit is that
> any item without a reorder_fn could then be treated as on what
> currently is the inode_list, but needs a btter name.

Ok.

--D
