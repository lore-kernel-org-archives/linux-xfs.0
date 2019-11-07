Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F012C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 15:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D84D921D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 15:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIBo68pa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfKGPra (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 10:47:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfKGPra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 10:47:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7FiLJk098681;
        Thu, 7 Nov 2019 15:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vhW6vFtxiTH41EjYH+R2f3JTeUkCjy/ZF5RhByUsxCM=;
 b=RIBo68paK81Mr7LUwKrcBJgEQ0wu0AjUihYGUO7+AJGxFeolI8kNkk5pL3BJ+bIc7OtB
 ow66tb6y9IwLNusrK5zSbyMwEZoZFiaRaG/LQXX8N3M3P9IiGMQIk6trVTCKMiXCmmED
 J/HxjcppQX/rB66QAhYDBf8y41wfZg0COmPrULSwiUuqlJ/w+/Ln9c1TdRC8pcDdxZsx
 o5bXNhxpPF4YSfky5AR2jxvLlEJ1PI2iq1E+E/7dqyTeALgEpeBk5gHUu+TauyLhVpMx
 6YuTf82P5t1R0NSzy4NbpYDz3pPl9lyfftjQgB5GO9nMnotLqYKD6lfBx2K9gUh56nUf bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w0y3gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 15:47:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7FgVp0099130;
        Thu, 7 Nov 2019 15:47:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41wa3jn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 15:47:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7FlNWJ001486;
        Thu, 7 Nov 2019 15:47:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 07:47:22 -0800
Date:   Thu, 7 Nov 2019 07:47:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: annotate functions that trip static checker
 locking checks
Message-ID: <20191107154721.GC6219@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309574505.46520.7461860244690955225.stgit@magnolia>
 <20191107083158.GA6729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107083158.GA6729@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 12:31:58AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 06, 2019 at 07:02:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add some lock annotations to helper functions that seem to have
> > unbalanced locking that confuses the static analyzers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_log.c      |    1 +
> >  fs/xfs/xfs_log_priv.h |    5 ++++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index d7d3bfd6a920..1b4e37bbce53 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2808,6 +2808,7 @@ xlog_state_do_iclog_callbacks(
> >  	struct xlog		*log,
> >  	struct xlog_in_core	*iclog,
> >  	bool			aborted)
> > +	__releases(&log->l_icloglock) __acquires(&log->l_icloglock)
> 
> The indentation looks really awkward.  I think this should be be:
> 
> 	bool                    aborted)
> 		__releases(&log->l_icloglock)
> 		__acquires(&log->l_icloglock)
> 
> > +static inline void
> > +xlog_wait(
> > +	struct wait_queue_head	*wq,
> > +	struct spinlock		*lock) __releases(lock)
> >  {
> >  	DECLARE_WAITQUEUE(wait, current);
> 
> Same here.

Will change both.

(I find both awkward, but not enough to push back all that hard. :P)

--D
