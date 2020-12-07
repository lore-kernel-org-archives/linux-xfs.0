Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E1EC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B3323888
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgLGSaJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:30:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGSaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 13:30:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7I9vog005465;
        Mon, 7 Dec 2020 18:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xICJTN9E1DSLsry8nWCDj2UVUJt3tRl1sjLjHcvUp2s=;
 b=vDIlHJ9f5E4A8z6eJJjDgzPuZBljXMOaTnNi/2h/gvgJDOvshISNyKXo/QogSC9ALrX9
 hNwVmiTE+Jlyz9b0B4tL1EdR7ab6TE4gDpY/J/cctKKG22o+8tYj4/uMGzxpVyP7S/+H
 CizB3olqGYG7017DxW/faESWefSiY6Nq7zRoQRB7bgcv1L1gnUenLAI6TQkOTGWVWdV1
 0Yr38r1XhSAUUFeVsCsoYLXMg/j/tkdf6kCTnsf9ciVGdYAIbi06NDaBnRzHzVMG8I7L
 gqXMO7k2iIzat+9qtEcr0K6M07ywO8pfbFWh9LJtslzNxG1sV2DBM2b2KVVFx/rXStpJ Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqptng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 18:29:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IAcGu138707;
        Mon, 7 Dec 2020 18:27:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 358kyrpjhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 18:27:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7IRMGh003153;
        Mon, 7 Dec 2020 18:27:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 10:27:22 -0800
Date:   Mon, 7 Dec 2020 10:27:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: trace log intent item recovery failures
Message-ID: <20201207182721.GS629293@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
 <160729624812.1607103.14927905190925127101.stgit@magnolia>
 <20201207172847.GA1598552@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207172847.GA1598552@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070118
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 12:28:47PM -0500, Brian Foster wrote:
> On Sun, Dec 06, 2020 at 03:10:48PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a trace point so that we can capture when a recovered log intent
> > item fails to recover.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log_recover.c |    5 ++++-
> >  fs/xfs/xfs_trace.h       |   18 ++++++++++++++++++
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 86951652d3ed..8fdb51eac1af 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -103,6 +103,24 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
> >  DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
> >  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
> >  
> > +TRACE_EVENT(xlog_intent_recovery_failed,
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
> > +	TP_printk("dev %d:%d error %d function %pS",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->error, __entry->caller_ip)
> > +);
> > +
> 
> Nit: I'd still swap out all of the caller_ip naming for clarity, but
> otherwise LGTM:

Ok will do, thanks for reviewing!

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  DECLARE_EVENT_CLASS(xfs_perag_class,
> >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
> >  		 unsigned long caller_ip),
> > 
> 
