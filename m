Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 19:10:01 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T29x1N018509
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 19:09:59 -0700
Message-ID: <48E03951.5010704@sgi.com>
Date: Mon, 29 Sep 2008 12:11:29 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Clean up dquot pincount code
References: <48DC6102.2040602@sgi.com> <48E02E3D.3000104@sgi.com>
In-Reply-To: <48E02E3D.3000104@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Peter Leckie wrote:
> This is a fix for patch " Clean up dquot pincount code"
> which introduced a build breakage due to a missing & in
> xfs_qm_dquot_logitem_pin.
> 
> 
> Signed-off-by: Peter Leckie <pleckie@sgi.com>
> 
> Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
> ===================================================================
> --- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot_item.c
> +++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
> @@ -96,7 +96,7 @@ xfs_qm_dquot_logitem_pin(
>        xfs_dquot_t *dqp = logitem->qli_dquot;
> 
>        ASSERT(XFS_DQ_IS_LOCKED(dqp));
> -       atomic_inc(dqp->q_pincount);
> +       atomic_inc(&dqp->q_pincount);
> }
> 
> /*

Looks good Peter,

seems we all missed this in review :(

Don
