Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977F0C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6283F2070A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rg6+/djM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCXUm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:42:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgCXUm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:42:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKdICh078304;
        Tue, 24 Mar 2020 20:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VdvOC6InHBAzVSQjCiKKNrySoUTCQI16gVazMpDlV5s=;
 b=Rg6+/djM1x8K3gIoL2abD/Qw5HDlfDfk5FnazrhajNCkpHaLxP9eGhyDJFrIwjSZqBHh
 GaGSXrsdS2rrd+AppX0zQvmvhHGIQsRpo1MCxA69vJNrkYIliXT3Mg4KBeSv3aleLrrV
 cs71coAuGCudTo3HIJeVz4FAY2Ke3I5SiZPJWzjABb76PV742EmDMDQonhgl+lQ/Eazp
 KZItTsLIaG/haGcIuvZ/D6Wl5kNmnIk2++Lw1RYxDmXiogaHd3yNCN7/x5nMgMIGYHhX
 F6FKehOa77T3S3oeytP89sbnmhRNSXAbnLymllNhWpD4HOnM1vJ2n0673d1ALoxgJEVj +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ywavm6k66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:42:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKci3u038173;
        Tue, 24 Mar 2020 20:42:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4q0usk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:42:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OKgKSo009723;
        Tue, 24 Mar 2020 20:42:20 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:42:19 -0700
Date:   Tue, 24 Mar 2020 13:42:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: remove some stale comments from the log code
Message-ID: <20200324204216.GO29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:59PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 59 +++++++++++-------------------------------------
>  1 file changed, 13 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1d6ed696f717..521fe77e3aaa 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -463,14 +463,6 @@ xfs_log_reserve(
>  	return error;
>  }
>  
> -
> -/*
> - * NOTES:
> - *
> - *	1. currblock field gets updated at startup and after in-core logs
> - *		marked as with WANT_SYNC.
> - */
> -
>  /*
>   * Write out an unmount record using the ticket provided. We have to account for
>   * the data space used in the unmount ticket as this write is not done from a
> @@ -1910,7 +1902,7 @@ xlog_dealloc_log(
>  	log->l_mp->m_log = NULL;
>  	destroy_workqueue(log->l_ioend_workqueue);
>  	kmem_free(log);
> -}	/* xlog_dealloc_log */
> +}
>  
>  /*
>   * Update counters atomically now that memcpy is done.
> @@ -2454,14 +2446,6 @@ xlog_write(
>  	return error;
>  }
>  
> -
> -/*****************************************************************************
> - *
> - *		State Machine functions
> - *
> - *****************************************************************************
> - */
> -
>  static void
>  xlog_state_activate_iclog(
>  	struct xlog_in_core	*iclog,
> @@ -2822,7 +2806,7 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log);	/* also cleans log */
> +	xlog_state_do_callback(log);
>  }
>  
>  /*
> @@ -2942,13 +2926,14 @@ xlog_state_get_iclog_space(
>  
>  	*logoffsetp = log_offset;
>  	return 0;
> -}	/* xlog_state_get_iclog_space */
> +}
>  
>  /*
> - * The first cnt-1 times through here we don't need to move the grant write head
> - * because the permanent reservation has reserved cnt times the unit amount.
> - * Release part of current permanent unit reservation and reset current
> - * reservation to be one units worth.  Also move grant reservation head forward.
> + * The first cnt-1 times a ticket goes through here we don't need to move the
> + * grant write head because the permanent reservation has reserved cnt times the
> + * unit amount.  Release part of current permanent unit reservation and reset
> + * current reservation to be one units worth.  Also move grant reservation head
> + * forward.
>   */
>  void
>  xlog_ticket_regrant(
> @@ -3030,12 +3015,8 @@ xlog_ticket_done(
>  }
>  
>  /*
> - * Mark the current iclog in the ring as WANT_SYNC and move the current iclog
> - * pointer to the next iclog in the ring.
> - *
> - * When called from xlog_state_get_iclog_space(), the exact size of the iclog
> - * has not yet been determined, all we know is that we have run out of space in
> - * the current iclog.
> + * This routine will mark the current iclog in the ring as WANT_SYNC and move
> + * the current iclog pointer to the next iclog in the ring.
>   */
>  STATIC void
>  xlog_state_switch_iclogs(
> @@ -3080,7 +3061,7 @@ xlog_state_switch_iclogs(
>  	}
>  	ASSERT(iclog == log->l_iclog);
>  	log->l_iclog = iclog->ic_next;
> -}	/* xlog_state_switch_iclogs */
> +}
>  
>  /*
>   * Write out all data in the in-core log as of this exact moment in time.
> @@ -3287,13 +3268,6 @@ xfs_log_force_lsn(
>  	return ret;
>  }
>  
> -/*****************************************************************************
> - *
> - *		TICKET functions
> - *
> - *****************************************************************************
> - */
> -
>  /*
>   * Free a used ticket when its refcount falls to zero.
>   */
> @@ -3450,13 +3424,6 @@ xlog_ticket_alloc(
>  	return tic;
>  }
>  
> -
> -/******************************************************************************
> - *
> - *		Log debug routines
> - *
> - ******************************************************************************
> - */
>  #if defined(DEBUG)
>  /*
>   * Make sure that the destination ptr is within the valid data region of
> @@ -3542,7 +3509,7 @@ xlog_verify_tail_lsn(
>  	if (blocks < BTOBB(iclog->ic_offset) + 1)
>  		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
>      }
> -}	/* xlog_verify_tail_lsn */
> +}
>  
>  /*
>   * Perform a number of checks on the iclog before writing to disk.
> @@ -3645,7 +3612,7 @@ xlog_verify_iclog(
>  		}
>  		ptr += sizeof(xlog_op_header_t) + op_len;
>  	}
> -}	/* xlog_verify_iclog */
> +}
>  #endif
>  
>  /*
> -- 
> 2.25.1
> 
