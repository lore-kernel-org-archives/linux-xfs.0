Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C9CC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 20:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397262085B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 20:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IIdGr1d+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgD1Uyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 16:54:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgD1Uyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 16:54:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SKrHAv127609;
        Tue, 28 Apr 2020 20:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=neO2+02o3SnZfV8fOKY08zgAcN0Foo5QprfltUyrjzQ=;
 b=IIdGr1d+3dnfBTru78GHS5oYCkZ51s5fZZpIEDPy37fsFH8RH7yBzLWUO94/8o+MH/sD
 /KRzyz6kcrERDahCF3JI7f95QT0BFPZScpEGViiWhndgJEwLD7NhxyYaIRM2+MJ4YtBh
 bfldtJgX6i0h1hqj+xuB2t6rcCCr/ijWTe13pdo6OFPatstEAM1lwMKY2Drp2tGVlqUl
 7KGScVgYN/Fu0/ggV9sl/t5yId9lgmhRwHCSRi5MWVs5htvLq8odx9qoK0b53mmWNy6h
 pZY6VF256c3lxsZ5s6MeGfFxC0YgUwgpoj1qYUFa05PMP5MzsHamk0l57QMlcSdfcTKQ 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01nrvfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 20:54:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SKpubD172007;
        Tue, 28 Apr 2020 20:54:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30mxx0rmbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 20:54:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SKsQ6c011103;
        Tue, 28 Apr 2020 20:54:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 13:54:26 -0700
Date:   Tue, 28 Apr 2020 13:54:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/19] xfs: refactor log recovery item dispatch for pass2
 readhead functions
Message-ID: <20200428205424.GG6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752118180.2140829.13805128567366066982.stgit@magnolia>
 <20200425181929.GB16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425181929.GB16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=935 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=988 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:19:29AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:06:21PM -0700, Darrick J. Wong wrote:
> >  typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
> >  		struct xlog_recover_item *item);
> > +typedef void (*xlog_recover_ra_pass2_fn)(struct xlog *log,
> > +		struct xlog_recover_item *item);
> 
> Same comment for this one - or the other two following.

<nod> I'll skip the typedefs.

> > +/*
> > + * This structure is used during recovery to record the buf log items which
> > + * have been canceled and should not be replayed.
> > + */
> > +struct xfs_buf_cancel {
> > +	xfs_daddr_t		bc_blkno;
> > +	uint			bc_len;
> > +	int			bc_refcount;
> > +	struct list_head	bc_list;
> > +};
> > +
> > +struct xfs_buf_cancel *xlog_peek_buffer_cancelled(struct xlog *log,
> > +		xfs_daddr_t blkno, uint len, unsigned short flags);
> 
> None of the callers moved in this patch even needs the xfs_buf_cancel
> structure, it just uses the return value as a boolean.  I think they
> all should be switched to use xlog_check_buffer_cancelled instead, which
> means that struct xfs_buf_cancel and xlog_peek_buffer_cancelled can stay
> private in xfs_log_recovery.c (and later xfs_buf_item.c).

They now all use your new xlog_buf_readahead function.

> > +STATIC void
> > +xlog_recover_buffer_ra_pass2(
> > +	struct xlog                     *log,
> > +	struct xlog_recover_item        *item)
> > +{
> > +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> > +	struct xfs_mount		*mp = log->l_mp;
> > +
> > +	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
> > +			buf_f->blf_len, buf_f->blf_flags)) {
> > +		return;
> > +	}
> > +
> > +	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
> > +				buf_f->blf_len, NULL);
> 
> Why not:
> 
> 	if (!xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
> 			buf_f->blf_len, buf_f->blf_flags)) {
> 		xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
> 				buf_f->blf_len, NULL);
> 	}
> 
> > +STATIC void
> > +xlog_recover_dquot_ra_pass2(
> > +	struct xlog			*log,
> > +	struct xlog_recover_item	*item)
> > +{
> > +	struct xfs_mount	*mp = log->l_mp;
> > +	struct xfs_disk_dquot	*recddq;
> > +	struct xfs_dq_logformat	*dq_f;
> > +	uint			type;
> > +	int			len;
> > +
> > +
> > +	if (mp->m_qflags == 0)
> 
> Double empty line above.
> 
> > +	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
> > +		return;
> > +
> > +	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
> > +			  &xfs_dquot_buf_ra_ops);
> 
> Same comment as above, no real need for the early return here.
> 
> > +	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
> > +		return;
> > +
> > +	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
> > +				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
> 
> Here again.

Changed to xlog_buf_readahead.

> 
> > -	unsigned short			flags)
> > +	unsigned short		flags)
> 
> Spurious whitespace change.
> 
> >  		case XLOG_RECOVER_PASS2:
> > -			xlog_recover_ra_pass2(log, item);
> > +			if (item->ri_type && item->ri_type->ra_pass2_fn)
> > +				item->ri_type->ra_pass2_fn(log, item);
> 
> Shouldn't we ensure eatly on that we always have a valid ->ri_type?

Item sorting will bail out on unrecognized log item types, in which case
we will discard the transaction (and all its items) and abort the mount,
right?  That should suffice to ensure that we always have a valid
ri_type long before we get to starting readahead for pass 2.

--D
