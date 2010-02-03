Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13AsbXx223826 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 04:54:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 578C213732E3
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 02:55:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id etcdaNkFIDviGg17 for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 02:55:46 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ncctd-00019X-Lj
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:55:45 +0000
Date: Wed, 3 Feb 2010 05:55:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-2.6.33] xfs: flush all log buffers in xlog_dealloc_log
Message-ID: <20100203105545.GA1047@infradead.org>
References: <20100201220813.GA3519@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100201220813.GA3519@infradead.org>
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
To: xfs@oss.sgi.com

Actually I'll take this one back - the log buffers aren't delwri
so xfs_flush_buftarg probably only helped by timing or the
xfs_buf_runall_queues on xfslogd_workqueue.  Need to think about
this a bit more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
