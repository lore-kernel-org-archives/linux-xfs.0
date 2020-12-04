Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05378C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 19:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A8322955
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 19:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgLDT6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 14:58:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgLDT6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 14:58:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Jn918077017;
        Fri, 4 Dec 2020 19:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iMwtR+1QmisOeRmStW0oIOKVnqKPgap6t4jPYCCk/Lk=;
 b=kcn9F4QchdXEVOVIGTAGwbZZOJsMu3jtP/aXcQUaV5TXIyosso8BgdfPkP8IKfHblcs8
 k0tDaa8rjhPxrC1enYViVY9+7Wfgh/bIQjjLf3ZxKZKHxW1zQ0rixKruyrvDgDIIr6op
 rn/JgMsV8bkXoEM77msjlYsrgdc26JVL5czRkktbOrisf1vqcpdwllAmIbDKIgbkpAEO
 AKCeXb6NC/ssGDrWGZ5mANN6nvfJMOCx8HHKpnn1c9ur2Y/DE3KT3wOyUtvtS4xuZ/DV
 oSAWi4671lJfsgJPt7FNVHgd/uuFLlVS4DLzxKHsVYa4JcqzTl77pxu7CiQQIaXqQoT1 Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm4vd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 19:57:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JoRZC083286;
        Fri, 4 Dec 2020 19:57:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540ayj2fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 19:57:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4JvZp9028540;
        Fri, 4 Dec 2020 19:57:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 11:57:35 -0800
Date:   Fri, 4 Dec 2020 11:57:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: trace log intent item recovery failures
Message-ID: <20201204195734.GF629293@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435695.734470.320027217185016602.stgit@magnolia>
 <20201204140052.GL1404170@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204140052.GL1404170@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 09:00:52AM -0500, Brian Foster wrote:
> On Thu, Dec 03, 2020 at 05:12:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a trace point so that we can capture when a recovered log intent
> > item fails to recover.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log_recover.c |    5 ++++-
> >  fs/xfs/xfs_trace.h       |   19 +++++++++++++++++++
> >  2 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 87886b7f77da..ed92c72976c9 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2559,8 +2559,11 @@ xlog_recover_process_intents(
> >  		spin_unlock(&ailp->ail_lock);
> >  		error = lip->li_ops->iop_recover(lip, &capture_list);
> >  		spin_lock(&ailp->ail_lock);
> > -		if (error)
> > +		if (error) {
> > +			trace_xfs_error_return(log->l_mp, error,
> > +					lip->li_ops->iop_recover);
> >  			break;
> > +		}
> >  	}
> >  
> >  	xfs_trans_ail_cursor_done(&cur);
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 86951652d3ed..99383b1acd49 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -103,6 +103,25 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
> >  DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
> >  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
> >  
> > +TRACE_EVENT(xfs_error_return,
> 
> xfs_error_return seems rather vague of a name given the current use.

Yeah, I'll change it to xlog_intent_recovery_failed.

> > +	TP_PROTO(struct xfs_mount *mp, int error, void *caller_ip),
> > +	TP_ARGS(mp, error, caller_ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(int, error)
> > +		__field(void *, caller_ip)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->error = error;
> > +		__entry->caller_ip = caller_ip;
> > +	),
> > +	TP_printk("dev %d:%d error %d caller %pS",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->error, __entry->caller_ip)
> > +
> 
> Extra whitespace. Also, using the text "caller" here is a bit misleading
> IMO. I'd suggest just calling it "function" or some such, but not that
> big of a deal.

Fixed, thanks.

--D

> Brian
> 
> > +);
> > +
> >  DECLARE_EVENT_CLASS(xfs_perag_class,
> >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
> >  		 unsigned long caller_ip),
> > 
> 
