Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5982C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 16:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9E720674
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 16:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gB/mBe+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgERQxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 12:53:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERQxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 12:53:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IGpjZI172709;
        Mon, 18 May 2020 16:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iHq0ji4jtLpGGJ+BvmTQWBuORBZ1VqEGxce9/fswjxw=;
 b=gB/mBe+HpANpvGBUkdjgRKm2pok9c1BlHSZPYoqTWg9cuo3wH3bjExgVF97An64vNa9k
 HelX58LJVaJvzZnKlUgIi4z8/Tr6SJJsTgsd/0LdOcPMvGCC2l9rvcNQAbEelpYHyFuf
 BuRAHuOi9O42C8iGZj6EiIHX/QCWMfwvnfyN04pckd5pK2TgCscJGPJ9Khnfv130k/tv
 CbXePptdSQroKWF3qpPSE8HtnXkxN8Y/iDbw/iLKv92HG3Y2F4gTFdKSE1fRU9z5iu+X
 ZUXx5OQkYl6PLNvCmAFm8dBasJOqTgcoQKvv5RTlU9jal8fjKEBoSduZmFMQEdFZKmax 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284kr0hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 16:53:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IGr5u8184758;
        Mon, 18 May 2020 16:53:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxqtgaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:53:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04IGqvQN029396;
        Mon, 18 May 2020 16:52:57 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 09:52:57 -0700
Date:   Mon, 18 May 2020 09:52:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, david@fromorbit.com
Subject: Re: [PATCH v2] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200518165256.GD17627@magnolia>
References: <20200514165658.GC6714@magnolia>
 <20200518131625.GC10938@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518131625.GC10938@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 09:16:25AM -0400, Brian Foster wrote:
> On Thu, May 14, 2020 at 09:56:58AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> ...
> > 
> > Fix this by changing the ondisk dquot initialization function to use
> > ordered buffers to write out fresh dquot blocks if it detects that we're
> > running quotacheck.  If the system goes down before quotacheck can
> > complete, the CHKD flags will not be set in the superblock and the next
> > mount will run quotacheck again, which can fix uninitialized dquot
> > buffers.  This requires amending the defer code to maintaine ordered
> > buffer state across defer rolls for the sake of the dquot allocation
> > code.
> > 
> > For regular operations we preserve the current behavior since the dquot
> > items require properly initialized ondisk dquot records.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: rework the code comment explaining all this
> > ---
> >  fs/xfs/libxfs/xfs_defer.c |   10 +++++++
> >  fs/xfs/xfs_dquot.c        |   62 ++++++++++++++++++++++++++++++++++++---------
> >  2 files changed, 58 insertions(+), 14 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 52e0f7245afc..f60a8967f9d5 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> ...
> > @@ -238,11 +240,45 @@ xfs_qm_init_dquot_blk(
> ...
> > +
> > +	/*
> > +	 * When quotacheck runs, we use delayed writes to update all the dquots
> > +	 * on disk in an efficient manner instead of logging the individual
> > +	 * dquot changes as they are made.
> > +	 *
> > +	 * Hence if we log the buffer that we allocate here, then crash
> > +	 * post-quotacheck while the logged initialisation is still in the
> > +	 * active region of the log, we can lose the information quotacheck
> > +	 * wrote directly to the buffer. That is, log recovery will replay the
> > +	 * dquot buffer initialisation over the top of whatever information
> > +	 * quotacheck had written to the buffer.
> > +	 *
> > +	 * To avoid this problem, dquot allocation during quotacheck needs to
> > +	 * avoid logging the initialised buffer, but we still need to have
> > +	 * writeback of the buffer pin the tail of the log so that it is
> > +	 * initialised on disk before we remove the allocation transaction from
> > +	 * the active region of the log. Marking the buffer as ordered instead
> > +	 * of logging it provides this behaviour.
> > +	 *
> > +	 * If we crash before quotacheck completes, a subsequent quotacheck run
> > +	 * will re-allocate and re-initialize the dquot records as needed.
> > +	 */
> 
> I took a stab at condensing the comment a bit, FWIW (diff below). LGTM
> either way. Thanks for the update.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	if (!(mp->m_qflags & qflag))
> > +		xfs_trans_ordered_buf(tp, bp);
> > +	else
> > +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> >  }
> >  
> >  /*
> > 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index f60a8967f9d5..55b95d45303b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -254,26 +254,20 @@ xfs_qm_init_dquot_blk(
>  	xfs_trans_dquot_buf(tp, bp, blftype);
>  
>  	/*
> -	 * When quotacheck runs, we use delayed writes to update all the dquots
> -	 * on disk in an efficient manner instead of logging the individual
> -	 * dquot changes as they are made.
> +	 * quotacheck uses delayed writes to update all the dquots on disk in an
> +	 * efficient manner instead of logging the individual dquot changes as
> +	 * they are made. However if we log the buffer allocated here and crash
> +	 * after quotacheck while the logged initialisation is still in the
> +	 * active region of the log, log recovery can replay the dquot buffer
> +	 * initialisation over the top of the checked dquots and corrupt quota
> +	 * accounting.
>  	 *
> -	 * Hence if we log the buffer that we allocate here, then crash
> -	 * post-quotacheck while the logged initialisation is still in the
> -	 * active region of the log, we can lose the information quotacheck
> -	 * wrote directly to the buffer. That is, log recovery will replay the
> -	 * dquot buffer initialisation over the top of whatever information
> -	 * quotacheck had written to the buffer.
> -	 *
> -	 * To avoid this problem, dquot allocation during quotacheck needs to
> -	 * avoid logging the initialised buffer, but we still need to have
> -	 * writeback of the buffer pin the tail of the log so that it is
> -	 * initialised on disk before we remove the allocation transaction from
> -	 * the active region of the log. Marking the buffer as ordered instead
> -	 * of logging it provides this behaviour.
> -	 *
> -	 * If we crash before quotacheck completes, a subsequent quotacheck run
> -	 * will re-allocate and re-initialize the dquot records as needed.
> +	 * To avoid this problem, quotacheck cannot log the initialised buffer.
> +	 * We must still dirty the buffer and write it back before the
> +	 * allocation transaction clears the log. Therefore, mark the buffer as
> +	 * ordered instead of logging it directly. This is safe for quotacheck
> +	 * because it detects and repairs allocated but initialized dquot blocks
> +	 * in the quota inodes.

I think I like your revised comment better. :)

--D

>  	 */
>  	if (!(mp->m_qflags & qflag))
>  		xfs_trans_ordered_buf(tp, bp);
> 
