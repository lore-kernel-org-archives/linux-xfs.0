Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2ACD229DF9
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 09:49:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 093F7304075
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 07:49:16 -0800 (PST)
Date: Fri, 6 Dec 2013 18:49:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: free the list of recovery items on error
Message-ID: <20131206154906.GA13568@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

Hello Mark Tinguely,

The patch 2a84108fe275: "xfs: free the list of recovery items on
error" from Oct 2, 2013, leads to the following
static checker warning: "fs/xfs/xfs_log_recover.c:3621
xlog_recover_process_data()
	 warn: 'trans' was already freed."

fs/xfs/xfs_log_recover.c
  3589                          switch (flags) {
  3590                          case XLOG_COMMIT_TRANS:
  3591                                  error = xlog_recover_commit_trans(log,
  3592                                                                  trans, pass);

xlog_recover_commit_trans() frees trans on the success path and on some
failure paths.

  3593                                  break;
  3594                          case XLOG_UNMOUNT_TRANS:
  3595                                  error = xlog_recover_unmount_trans(log, trans);
  3596                                  break;
  3597                          case XLOG_WAS_CONT_TRANS:
  3598                                  error = xlog_recover_add_to_cont_trans(log,
  3599                                                  trans, dp,
  3600                                                  be32_to_cpu(ohead->oh_len));
  3601                                  break;
  3602                          case XLOG_START_TRANS:
  3603                                  xfs_warn(log->l_mp, "%s: bad transaction",
  3604                                          __func__);
  3605                                  ASSERT(0);
  3606                                  error = XFS_ERROR(EIO);
  3607                                  break;
  3608                          case 0:
  3609                          case XLOG_CONTINUE_TRANS:
  3610                                  error = xlog_recover_add_to_trans(log, trans,
  3611                                                  dp, be32_to_cpu(ohead->oh_len));
  3612                                  break;
  3613                          default:
  3614                                  xfs_warn(log->l_mp, "%s: bad flag 0x%x",
  3615                                          __func__, flags);
  3616                                  ASSERT(0);
  3617                                  error = XFS_ERROR(EIO);
  3618                                  break;
  3619                          }
  3620                          if (error) {
  3621                                  xlog_recover_free_trans(trans);

Double free?

  3622                                  return error;
  3623                          }

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
