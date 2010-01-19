Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JNE98T224322 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 17:14:09 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Re: [1/3] xfs: remove duplicate buffer flags
Date: Tue, 19 Jan 2010 17:14:16 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A699B@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: xfs@oss.sgi.com

I didn't get these in my e-mail, but I've reviewed these three
patches and all look good.  Gratuitous commententary below, but
for all three:

Reviewed-by: Alex Elder <aelder@sgi.com>

					-Alex


[1/3] xfs: remove duplicate buffer flags
I agree that aliases like this obscure the code.
It's possible they were done for reasons of
architectural purity or something, but I think
this change is an improvement.


[2/3] xfs: kill XLOG_VEC_SET_TYPE
Definite improvement.


[3/3] xfs: cleanup up xfs_log_force calling conventions

> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2010-01-19 10:49:18.100003304 +0100
> +++ xfs/fs/xfs/xfs_log.c	2010-01-19 10:49:33.510003623 +0100
. . .
+void
+xfs_log_force_lsn(
+	xfs_mount_t	*mp,
+	xfs_lsn_t	lsn,
+	uint		flags)
+{
+	int	error;
 
+	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
+	if (error) {
+		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "

Function name should be fixed in this statement.  I will fix
that for  you.

+			"error %d returned.", error);
+	}
+}
 
 . . .
> @@ -3536,13 +3529,14 @@  xfs_log_force_umount(
>  	}
>  	spin_unlock(&log->l_grant_lock);
>  
> -	if (! (log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
> +	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
>  		ASSERT(!logerror);
>  		/*
>  		 * Force the incore logs to disk before shutting the
>  		 * log down completely.
>  		 */
> -		xlog_state_sync_all(log, XFS_LOG_FORCE|XFS_LOG_SYNC, &dummy);
> +		_xfs_log_force(mp, XFS_LOG_SYNC, NULL);
> +

This is a really good change.  It was a strange to have this
be the only other spot that called xlog_state_sync_all().
(And of course now you've incorporated the state_sync functions
back into _xfs_log_force*().)

>  		spin_lock(&log->l_icloglock);
>  		retval = xlog_state_ioerror(log);
>  		spin_unlock(&log->l_icloglock);
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
