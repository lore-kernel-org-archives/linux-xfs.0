Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2B6C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 18:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AF6207E8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 18:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LwpE1cnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgI1SlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 14:41:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57524 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1SlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 14:41:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SIe3we075687;
        Mon, 28 Sep 2020 18:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1WNI4P384ItvhilTEO/M0OFoE39RXM4z1RLl4KTEX/Y=;
 b=LwpE1cnOvVuTjaVKHnWhJ65RMwgWQTWjCiYKzq8SX6HISjncKFcEPg42+9EiVhdNyN+f
 i0qjm4WCy64vOYRj0G+aBfYXLn6Phf9rWkwXqw/l0gGI11LAcEFB2SPek6kjuEgyYyRk
 qcUkmI0DBgI+URB/loySZPb8qnX2d+tV249YbZAGGz1D+raINjAeXNmerpicJQ+tv+Eh
 054oUvA3kvJHcdAF6ZzQK2tZOFUyZsV1dk3Y0RtMYSYzlzYpQWxDaujgEJ3xG47UOESi
 IVF6WLPa9B2tN3LPmxeB5xlXSA5FPp7/xWski5FU7NEgl6f24OY6sGwT0yAVlgtOGvbX AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33su5apt4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 18:41:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SIehBB047312;
        Mon, 28 Sep 2020 18:41:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdqkh0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 18:41:04 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SIf3sI027603;
        Mon, 28 Sep 2020 18:41:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 11:41:03 -0700
Date:   Mon, 28 Sep 2020 11:41:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsdump: rename worker threads
Message-ID: <20200928184102.GF49547@magnolia>
References: <144faa13-75be-4742-11cf-81cf30ae71b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144faa13-75be-4742-11cf-81cf30ae71b8@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 01:30:15PM -0500, Eric Sandeen wrote:
> xfsdump's use of "slave," while largely understood in technical circles,
> poses a barrier for inclusion to some potential members of the development
> and user community, due to the historical context of masters and slaves,
> particularly in the United States.
> 
> As these entities are already controlled by "managers" in the code,
> simply rename them to "workers," which is a more natural fit in any
> case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/common/drive.h b/common/drive.h
> index ee53aeb..973108a 100644
> --- a/common/drive.h
> +++ b/common/drive.h
> @@ -584,7 +584,7 @@ struct drive_ops {
>  				 */
>  	void (*do_quit)(drive_t *drivep);
>  				/* tells the drive manager to de-allocate
> -				 * resources, INCLUDING the slave process.
> +				 * resources, INCLUDING the worker process.
>  				 */
>  };
>  
> diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
> index 55aa8b0..0cbf235 100644
> --- a/common/drive_minrmt.c
> +++ b/common/drive_minrmt.c
> @@ -186,7 +186,7 @@ struct drive_context {
>  			 * to media without error. includes media file header
>  			 * record. this is incremented when the actual I/O is
>  			 * done. dc_reccnt is different, indicating what has
> -			 * been seen by client. slave may have read ahead /
> +			 * been seen by client. worker may have read ahead /
>  			 * written behind.
>  			 */
>  	int dc_fd;
> @@ -211,7 +211,7 @@ struct drive_context {
>  			 * compression
>  			 */
>  	bool_t dc_singlethreadedpr;
> -			/* single-threaded operation (no slave)
> +			/* single-threaded operation (no worker)
>  			 */
>  	bool_t dc_errorpr;
>  			/* TRUE if error encountered during reading or writing.
> @@ -687,7 +687,7 @@ do_init(drive_t *drivep)
>  	return BOOL_TRUE;
>  }
>  
> -/* wait here for slave to complete initialization.
> +/* wait here for worker to complete initialization.
>   * set drive capabilities flags. NOTE: currently don't make use of this
>   * feature: drive initialization done whenever block/record sizes unknown.
>   */
> @@ -2514,7 +2514,7 @@ do_quit(drive_t *drivep)
>  	if (ringp) {
>  		display_ring_metrics(drivep, MLOG_VERBOSE);
>  
> -		/* tell slave to die
> +		/* tell worker to die
>  		 */
>  		mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
>  		      "ring op: destroy\n");
> @@ -3873,10 +3873,10 @@ display_ring_metrics(drive_t *drivep, int mlog_flags)
>  	      bufszbuf,
>  	      bufszsfxp,
>  	      contextp->dc_ringpinnedpr ? _("pinned ") : "",
> -	      ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
> -	      ringp->r_slave_msgcnt,
> -	      percent64(ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
> -			 ringp->r_slave_msgcnt),
> +	      ringp->r_worker_msgcnt - ringp->r_worker_blkcnt,
> +	      ringp->r_worker_msgcnt,
> +	      percent64(ringp->r_worker_msgcnt - ringp->r_worker_blkcnt,
> +			 ringp->r_worker_msgcnt),
>  	      (double)(ringp->r_all_io_cnt)
>  	      *
>  	      (double)tape_recsz
> diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
> index 452a16a..878a5d7 100644
> --- a/common/drive_scsitape.c
> +++ b/common/drive_scsitape.c
> @@ -188,7 +188,7 @@ struct drive_context {
>  			 * to media without error. includes media file header
>  			 * record. this is incremented when the actual I/O is
>  			 * done. dc_reccnt is different, indicating what has
> -			 * been seen by client. slave may have read ahead /
> +			 * been seen by client. worker may have read ahead /
>  			 * written behind.
>  			 */
>  	int dc_fd;
> @@ -231,7 +231,7 @@ struct drive_context {
>  			 * compression
>  			 */
>  	bool_t dc_singlethreadedpr;
> -			/* single-threaded operation (no slave)
> +			/* single-threaded operation (no worker)
>  			 */
>  	bool_t dc_errorpr;
>  			/* TRUE if error encountered during reading or writing.
> @@ -800,7 +800,7 @@ do_init(drive_t *drivep)
>  	return BOOL_TRUE;
>  }
>  
> -/* wait here for slave to complete initialization.
> +/* wait here for worker to complete initialization.
>   * set drive capabilities flags. NOTE: currently don't make use of this
>   * feature: drive initialization done whenever block/record sizes unknown.
>   */
> @@ -2752,7 +2752,7 @@ do_quit(drive_t *drivep)
>  	if (ringp) {
>  		display_ring_metrics(drivep, MLOG_VERBOSE);
>  
> -		/* tell slave to die
> +		/* tell worker to die
>  		 */
>  		mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
>  		      "ring op: destroy\n");
> @@ -5156,10 +5156,10 @@ display_ring_metrics(drive_t *drivep, int mlog_flags)
>  	      bufszbuf,
>  	      bufszsfxp,
>  	      contextp->dc_ringpinnedpr ? _("pinned ") : "",
> -	      ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
> -	      ringp->r_slave_msgcnt,
> -	      percent64(ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
> -			 ringp->r_slave_msgcnt),
> +	      ringp->r_worker_msgcnt - ringp->r_worker_blkcnt,
> +	      ringp->r_worker_msgcnt,
> +	      percent64(ringp->r_worker_msgcnt - ringp->r_worker_blkcnt,
> +			 ringp->r_worker_msgcnt),
>  	      (double)(ringp->r_all_io_cnt)
>  	      *
>  	      (double)tape_recsz
> diff --git a/common/main.c b/common/main.c
> index cb2caf7..1db07d4 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -625,10 +625,10 @@ main(int argc, char *argv[])
>  
>  	/* now do the second and third passes of drive initialization.
>  	 * allocate per-stream write and read headers. if a drive
> -	 * manager uses a slave process, it should be created now,
> -	 * using cldmgr_create(). each drive manager may use the slave to
> +	 * manager uses a worker process, it should be created now,
> +	 * using cldmgr_create(). each drive manager may use the worker to
>  	 * asynchronously read the media file header, typically a very
> -	 * time-consuming chore. drive_init3 will synchronize with each slave.
> +	 * time-consuming chore. drive_init3 will synchronize with each worker.
>  	 */
>  	if (!init_error) {
>  #ifdef DUMP
> @@ -1465,7 +1465,7 @@ childmain(void *arg1)
>  	exitcode = content_stream_restore(stix);
>  #endif /* RESTORE */
>  
> -	/* let the drive manager shut down its slave thread
> +	/* let the drive manager shut down its worker thread
>  	 */
>  	drivep = drivepp[stix];
>  	(*drivep->d_opsp->do_quit)(drivep);
> diff --git a/common/ring.c b/common/ring.c
> index 87152dd..7c6b499 100644
> --- a/common/ring.c
> +++ b/common/ring.c
> @@ -33,7 +33,7 @@
>  #include "cldmgr.h"
>  #include "ring.h"
>  
> -static int ring_slave_entry(void *ringctxp);
> +static int ring_worker_entry(void *ringctxp);
>  
>  ring_t *
>  ring_create(size_t ringlen,
> @@ -72,14 +72,14 @@ ring_create(size_t ringlen,
>  	ringp->r_active_in_ix = 0;
>  	ringp->r_active_out_ix = 0;
>  	ringp->r_client_cnt = 0;
> -	ringp->r_slave_cnt = 0;
> +	ringp->r_worker_cnt = 0;
>  
>  	/* initialize the meters
>  	 */
>  	ringp->r_client_msgcnt = 0;
> -	ringp->r_slave_msgcnt = 0;
> +	ringp->r_worker_msgcnt = 0;
>  	ringp->r_client_blkcnt = 0;
> -	ringp->r_slave_blkcnt = 0;
> +	ringp->r_worker_blkcnt = 0;
>  	ringp->r_first_io_time = 0;
>  	ringp->r_all_io_cnt = 0;
>  
> @@ -120,11 +120,11 @@ ring_create(size_t ringlen,
>  		}
>  	}
>  
> -	/* kick off the slave thread
> +	/* kick off the worker thread
>  	 */
> -	ok = cldmgr_create(ring_slave_entry,
> +	ok = cldmgr_create(ring_worker_entry,
>  			    drive_index,
> -			    _("slave"),
> +			    _("worker"),
>  			    ringp);
>  	assert(ok);
>  
> @@ -233,7 +233,7 @@ ring_reset(ring_t *ringp, ring_msg_t *msgp)
>  		assert(ringp->r_client_cnt == 1);
>  	}
>  
> -	/* tell the slave to abort
> +	/* tell the worker to abort
>  	 */
>  	msgp->rm_op = RING_OP_RESET;
>  	ring_put(ringp, msgp);
> @@ -263,7 +263,7 @@ ring_reset(ring_t *ringp, ring_msg_t *msgp)
>  	ringp->r_active_in_ix = 0;
>  	ringp->r_active_out_ix = 0;
>  	ringp->r_client_cnt = 0;
> -	ringp->r_slave_cnt = 0;
> +	ringp->r_worker_cnt = 0;
>  	for (mix = 0; mix < ringp->r_len; mix++) {
>  		ring_msg_t *msgp = &ringp->r_msgp[mix];
>  		msgp->rm_mix = mix;
> @@ -290,7 +290,7 @@ ring_destroy(ring_t *ringp)
>  	 */
>  	msgp = ring_get(ringp);
>  
> -	/* tell the slave to exit
> +	/* tell the worker to exit
>  	 */
>  	msgp->rm_op = RING_OP_DIE;
>  	ring_put(ringp, msgp);
> @@ -308,7 +308,7 @@ ring_destroy(ring_t *ringp)
>  					ringp->r_len;
>  	} while (msgp->rm_stat != RING_STAT_DIEACK);
>  
> -	/* the slave is dead.
> +	/* the worker is dead.
>  	 */
>  	qsem_free(ringp->r_ready_qsemh);
>  	qsem_free(ringp->r_active_qsemh);
> @@ -317,19 +317,19 @@ ring_destroy(ring_t *ringp)
>  
>  
>  static ring_msg_t *
> -ring_slave_get(ring_t *ringp)
> +ring_worker_get(ring_t *ringp)
>  {
>  	ring_msg_t *msgp;
>  
> -	/* assert slave currently holds no messages
> +	/* assert worker currently holds no messages
>  	 */
> -	assert(ringp->r_slave_cnt == 0);
> +	assert(ringp->r_worker_cnt == 0);
>  
> -	/* bump slave message count and note if slave needs to block
> +	/* bump worker message count and note if worker needs to block
>  	 */
> -	ringp->r_slave_msgcnt++;
> +	ringp->r_worker_msgcnt++;
>  	if (qsemPwouldblock(ringp->r_active_qsemh)) {
> -		ringp->r_slave_blkcnt++;
> +		ringp->r_worker_blkcnt++;
>  	}
>  
>  	/* block until msg available on active queue ("P")
> @@ -358,23 +358,23 @@ ring_slave_get(ring_t *ringp)
>  	 */
>  	msgp->rm_loc = RING_LOC_SLAVE;
>  
> -	/* bump the count of messages held by the slave
> +	/* bump the count of messages held by the worker
>  	 */
> -	ringp->r_slave_cnt++;
> +	ringp->r_worker_cnt++;
>  
> -	/* return the msg to the slave
> +	/* return the msg to the worker
>  	 */
>  	return msgp;
>  }
>  
>  static void
> -ring_slave_put(ring_t *ringp, ring_msg_t *msgp)
> +ring_worker_put(ring_t *ringp, ring_msg_t *msgp)
>  {
> -	/* assert the slave holds exactly one message
> +	/* assert the worker holds exactly one message
>  	 */
> -	assert(ringp->r_slave_cnt == 1);
> +	assert(ringp->r_worker_cnt == 1);
>  
> -	/* assert the slave is returning the right message
> +	/* assert the worker is returning the right message
>  	 */
>  	assert(msgp->rm_mix == ringp->r_ready_in_ix);
>  
> @@ -382,9 +382,9 @@ ring_slave_put(ring_t *ringp, ring_msg_t *msgp)
>  	 */
>  	assert(msgp->rm_loc == RING_LOC_SLAVE);
>  
> -	/* decrement the count of messages held by the slave
> +	/* decrement the count of messages held by the worker
>  	 */
> -	ringp->r_slave_cnt--;
> +	ringp->r_worker_cnt--;
>  
>  	/* update the message location
>  	 */
> @@ -402,7 +402,7 @@ ring_slave_put(ring_t *ringp, ring_msg_t *msgp)
>  }
>  
>  static int
> -ring_slave_entry(void *ringctxp)
> +ring_worker_entry(void *ringctxp)
>  {
>  	sigset_t blocked_set;
>  	ring_t *ringp = (ring_t *)ringctxp;
> @@ -424,7 +424,7 @@ ring_slave_entry(void *ringctxp)
>  		ring_msg_t *msgp;
>  		int rval;
>  
> -		msgp = ring_slave_get(ringp);
> +		msgp = ring_worker_get(ringp);
>  		msgp->rm_rval = 0;
>  
>  		switch(msgp->rm_op) {
> @@ -486,7 +486,7 @@ ring_slave_entry(void *ringctxp)
>  			msgp->rm_stat = RING_STAT_IGNORE;
>  			break;
>  		}
> -		ring_slave_put(ringp, msgp);
> +		ring_worker_put(ringp, msgp);
>  	}
>  
>  	return 0;
> diff --git a/common/ring.h b/common/ring.h
> index 6535af8..b90efd4 100644
> --- a/common/ring.h
> +++ b/common/ring.h
> @@ -21,16 +21,16 @@
>  /* ring - readahead/writeahead abstraction
>   *
>   * the ring is conceptually an ordered set of messages circulating between the
> - * client thread and the I/O slave thread. a message can be in one of four
> + * client thread and the I/O worker thread. a message can be in one of four
>   * places: on the ready queue, held by the client, on the active queue, or held
> - * by the slave. The client and slave can each hold at most one message at a
> + * by the worker. The client and worker can each hold at most one message at a
>   * time. all others must be on one of the two queues. the messages must
> - * circulate in that order: ready, client, active, slave, ready, ...
> + * circulate in that order: ready, client, active, worker, ready, ...
>   * initially all messages are on the ready queue, with status set to
>   * INIT. The client uses ring_get to remove a message from the ready queue.
>   * the client can then use the message to read or write. to read, the client
>   * sets the op field to READ, and places the message on the active queue. the
> - * slave will remove messages from the active queue, invoke the client-supplied
> + * worker will remove messages from the active queue, invoke the client-supplied
>   * read function with the message's buffer, record the read function's return
>   * value in the message, set the message status to OK (read function returned 0)
>   * or ERROR (read returned non-zero), and place the message on the ready queue.
> @@ -39,28 +39,28 @@
>   * except the client fills the buffer and sets the op to WRITE prior to placing
>   * the message on the active queue.
>   *
> - * if the client-supplied read or write function returns an error, the slave
> - * will set the message status to ERROR. the slave will pass all subsequent
> + * if the client-supplied read or write function returns an error, the worker
> + * will set the message status to ERROR. the worker will pass all subsequent
>   * messages appearing on the active queue directly to the ready queue with
> - * no I/O done and the message status set to IGNORE. the slave will remain
> + * no I/O done and the message status set to IGNORE. the worker will remain
>   * in this state until a reset is performed (see below).
>   *
> - * The client may at anytime place a NOP msg on the ring. the slave does
> + * The client may at anytime place a NOP msg on the ring. the worker does
>   * nothing with this mmessage other than to place it back on the ready queue
>   * with NOPACK status. This is useful for inhibiting read-ahead.
>   *
>   * To flush the ring, the client must repetatively place TRACE messages on the
> - * active queue until it sees an IGNORE msg on the ready queue. the slave will
> + * active queue until it sees an IGNORE msg on the ready queue. the worker will
>   * simply transfer TRACErs from active to ready with no other action taken
>   * (other than to set the message status to IGNORE).
>   *
>   * the client may at any time reset the ring. the reset will return to the
> - * client when the current I/O being executed by the slave completes, and
> + * client when the current I/O being executed by the worker completes, and
>   * all messages have been wiped clean and placed on the ready queue with
>   * status set to INIT. the ring_reset function accomplishes this internally by
>   * placing a RESET message on the active QUEUE, and continuing to remove
>   * messages from the ready queue (without placing them on the active queue)
> - * until the RESET message is seen the slave responds to a reset message by
> + * until the RESET message is seen the worker responds to a reset message by
>   * setting the status to RESETACK, queueing the message on the ready queue, and
>   * waiting for a message from the active queue. ring_reset will then re-
>   * initialize the ring and return. note that the client may be holding one
> @@ -68,7 +68,7 @@
>   * that message into the reset call. otherwise it must pass in NULL.
>   *
>   * the ring_destroy function may be invoked to shut down the ring and kill the
> - * slave thread. it simply places a DIE message on the active queue, and waits
> + * worker thread. it simply places a DIE message on the active queue, and waits
>   * for a DIEACK response. it then de-allocates all semaphores memory allocated
>   * by ring_create.
>   *
> @@ -76,7 +76,7 @@
>   * of the client. it is not perturbed during any ring operations.
>   *
>   * the ring maintains four performance metering values: the number of times
> - * the slave and client attempted to get a message, and the number of times
> + * the worker and client attempted to get a message, and the number of times
>   * those attempts resulting in blocking.
>   */
>  
> @@ -128,9 +128,9 @@ typedef struct ring_msg ring_msg_t;
>   */
>  struct ring {
>  	off64_t r_client_msgcnt;
> -	off64_t r_slave_msgcnt;
> +	off64_t r_worker_msgcnt;
>  	off64_t r_client_blkcnt;
> -	off64_t r_slave_blkcnt;
> +	off64_t r_worker_blkcnt;
>  	time32_t r_first_io_time;
>  	off64_t r_all_io_cnt;
>  /* ALL BELOW PRIVATE!!! */
> @@ -143,7 +143,7 @@ struct ring {
>  	size_t r_active_out_ix;
>  	qsemh_t r_active_qsemh;
>  	size_t r_client_cnt;
> -	size_t r_slave_cnt;
> +	size_t r_worker_cnt;
>  	int (*r_readfunc)(void *contextp, char *bufp);
>  	int (*r_writefunc)(void *contextp, char *bufp);
>  	void *r_clientctxp;
> diff --git a/common/stream.c b/common/stream.c
> index 4f56517..3c2b172 100644
> --- a/common/stream.c
> +++ b/common/stream.c
> @@ -54,7 +54,7 @@ stream_init(void)
>   * Note that the stream list structure (updated via the stream_* functions)
>   * is indexed by pthread_t (tid). Multiple processes can be registered against
>   * the same stream index, typically: the primary content process that does the
> - * work; and the drive slave process, which just processes stuff off the ring
> + * work; and the drive worker process, which just processes stuff off the ring
>   * buffer. In general having multiple tids registered per stream is not an issue
>   * for termination status reporting, as the mlog_exit* logging functions only
>   * ever get called out of the primary content process.
> diff --git a/common/ts_mtio.h b/common/ts_mtio.h
> index 9b31d25..76f3f91 100644
> --- a/common/ts_mtio.h
> +++ b/common/ts_mtio.h
> @@ -611,7 +611,7 @@ struct mt_capablity  {
>  #define MTCANT_IMM	0x80000 /* drive doesn't work correctly when
>  	immediate mode rewind, etc. is enabled.  Setting this bit
>  	will disable immediate mode rewind on the drive, independent
> -	of the setting of tpsc_immediate_rewind (in master.d/tpsc) */
> +	of the setting of tpsc_immediate_rewind (in the tpsc sysgen file) */
>  #define MTCAN_COMPRESS	0x100000 /* drive supports compression */
>  #define MTCAN_BUFFM	0x200000 /* drive supports writing of
>  				  * buffered filemarks */
> 
