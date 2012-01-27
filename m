Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RLFt7T253295 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 15:15:56 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WrBP80GlJEAuEI27 for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:15:54 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch|rfc][0/3] fix aio+dio+O_SYNC writes
Date: Fri, 27 Jan 2012 16:15:46 -0500
Message-Id: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Currently, if an AIO/DIO/O_SYNC write is issued, generic_write_sync is
called after the submission of the I/O instead of after the completion.
This can result in flushing the disk cache before the actual write even
gets there!  This patch set attempts to fix that for xfs and ext4.
Comments would be greatly appreciated.

Cheers,
Jeff

[PATCH 1/3] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 3/3] filemap: don't call generic_write_sync for -EIOCBQUEUED

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
