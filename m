Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC28C3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5BB20716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hiz09OkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCESIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:08:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726682AbgCESIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EdD5yan0Cp0/+7ntg47ZPus3kpol60A5eosxH46GuuQ=;
        b=Hiz09OkBajS2Kf5HIO+0eE6weKuwvCqnliafQNBc3Snrb/nW1H77jQYNmPEjgn279Tz2G9
        bp8E3BeW3BRMFfX4yfXDXU/rZXHVm7o8UD7hHFErX4u5FyHAkDmyLshr5jMEyTiJdDa9ec
        FGZMW9xXSteE3YvSdH8hK/SFO3+aSRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-zeLFyRzqPRCh9LFSyPOw7Q-1; Thu, 05 Mar 2020 13:08:18 -0500
X-MC-Unique: zeLFyRzqPRCh9LFSyPOw7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7569A18A6EC2;
        Thu,  5 Mar 2020 18:08:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2519C60BE0;
        Thu,  5 Mar 2020 18:08:17 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:08:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: remove some stale comments from the log code
Message-ID: <20200305180815.GJ28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-11-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:54:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 71 ++++++++++++++----------------------------------
>  1 file changed, 20 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a687c20dd77d..89956484848f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -477,14 +477,6 @@ xfs_log_reserve(
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
> @@ -1968,7 +1960,7 @@ xlog_dealloc_log(
>  	log->l_mp->m_log = NULL;
>  	destroy_workqueue(log->l_ioend_workqueue);
>  	kmem_free(log);
> -}	/* xlog_dealloc_log */
> +}
>  
>  /*
>   * Update counters atomically now that memcpy is done.
> @@ -2511,14 +2503,6 @@ xlog_write(
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
>  /*
>   * An iclog has just finished IO completion processing, so we need to update
>   * the iclog state and propagate that up into the overall log state. Hence we
> @@ -2887,8 +2871,8 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log, aborted);	/* also cleans log */
> -}	/* xlog_state_done_syncing */
> +	xlog_state_do_callback(log, aborted);
> +}
>  
>  
>  /*
> @@ -3008,14 +2992,14 @@ xlog_state_get_iclog_space(
>  
>  	*logoffsetp = log_offset;
>  	return 0;
> -}	/* xlog_state_get_iclog_space */
> -
> -/* The first cnt-1 times through here we don't need to
> - * move the grant write head because the permanent
> - * reservation has reserved cnt times the unit amount.
> - * Release part of current permanent unit reservation and
> - * reset current reservation to be one units worth.  Also
> - * move grant reservation head forward.
> +}
> +
> +/*
> + * The first cnt-1 times a ticket goes through here we don't need to move the
> + * grant write head because the permanent reservation has reserved cnt times the
> + * unit amount.  Release part of current permanent unit reservation and reset
> + * current reservation to be one units worth.  Also move grant reservation head
> + * forward.
>   */
>  STATIC void
>  xlog_regrant_reserve_log_space(
> @@ -3047,7 +3031,7 @@ xlog_regrant_reserve_log_space(
>  
>  	ticket->t_curr_res = ticket->t_unit_res;
>  	xlog_tic_reset_res(ticket);
> -}	/* xlog_regrant_reserve_log_space */
> +}
>  
>  
>  /*
> @@ -3096,11 +3080,11 @@ xlog_ungrant_log_space(
>  }
>  
>  /*
> - * This routine will mark the current iclog in the ring as WANT_SYNC
> - * and move the current iclog pointer to the next iclog in the ring.
> - * When this routine is called from xlog_state_get_iclog_space(), the
> - * exact size of the iclog has not yet been determined.  All we know is
> - * that every data block.  We have run out of space in this log record.
> + * This routine will mark the current iclog in the ring as WANT_SYNC and move
> + * the current iclog pointer to the next iclog in the ring.  When this routine
> + * is called from xlog_state_get_iclog_space(), the exact size of the iclog has
> + * not yet been determined.  All we know is that every data block.  We have run
> + * out of space in this log record.
>   */
>  STATIC void
>  xlog_state_switch_iclogs(
> @@ -3143,7 +3127,7 @@ xlog_state_switch_iclogs(
>  	}
>  	ASSERT(iclog == log->l_iclog);
>  	log->l_iclog = iclog->ic_next;
> -}	/* xlog_state_switch_iclogs */
> +}
>  
>  /*
>   * Write out all data in the in-core log as of this exact moment in time.
> @@ -3397,14 +3381,6 @@ xlog_state_want_sync(
>  	}
>  }
>  
> -
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
> @@ -3562,13 +3538,6 @@ xlog_ticket_alloc(
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
> @@ -3654,7 +3623,7 @@ xlog_verify_tail_lsn(
>  	if (blocks < BTOBB(iclog->ic_offset) + 1)
>  		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
>      }
> -}	/* xlog_verify_tail_lsn */
> +}
>  
>  /*
>   * Perform a number of checks on the iclog before writing to disk.
> @@ -3757,7 +3726,7 @@ xlog_verify_iclog(
>  		}
>  		ptr += sizeof(xlog_op_header_t) + op_len;
>  	}
> -}	/* xlog_verify_iclog */
> +}
>  #endif
>  
>  /*
> -- 
> 2.24.0.rc0
> 

