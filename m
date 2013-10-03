Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C85DE29DFC
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 09:56:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3FA98F8039
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 07:56:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id G9RsRBtWtPBhpdaz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 07:56:51 -0700 (PDT)
Date: Thu, 3 Oct 2013 07:56:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/16] xfs: decouple log and transaction headers
Message-ID: <20131003145650.GD10316@infradead.org>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380510433-8353-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> @@ -33,16 +33,6 @@ struct xfs_log_vec {
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
>  /*
> - * Structure used to pass callback function and the function's argument
> - * to the log manager.
> - */
> -typedef struct xfs_log_callback {
> -	struct xfs_log_callback	*cb_next;
> -	void			(*cb_func)(void *, int);
> -	void			*cb_arg;
> -} xfs_log_callback_t;
> -
> -/*

Looking at the code I don't think this one needs to be moved as the
t_logcb field in struct xfs_trans is dead already.  Just remove it in
a separate patch and this declaration can stay where it is.

Otherwise this patch looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
