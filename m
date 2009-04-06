Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n36Hfweu181344 for <xfs@oss.sgi.com>; Mon, 6 Apr 2009 12:42:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84CC313FA4FD
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2009 10:42:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JNd6xoQLUliazkMG for
	<xfs@oss.sgi.com>; Mon, 06 Apr 2009 10:42:39 -0700 (PDT)
Date: Mon, 6 Apr 2009 13:40:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_trans_log_inode: OOPS in 2.6.28.7
Message-ID: <20090406174030.GA8943@infradead.org>
References: <20090402024744.GB23044@ns1.signalpunk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090402024744.GB23044@ns1.signalpunk.com>
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
To: Christopher Layne <clayne@anodized.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 02, 2009 at 02:47:44AM +0000, Christopher Layne wrote:
> While I think I might be able to reproduce this it's not something I
> particularly want to reproduce. The precursor was cancelling an
> already running xfs_fsr, removing the .fsr_last, and immediately
> restarting it (forcing a new cycle). Right after I received an OOPS and
> all file system access was blocked necessitating a hard reboot and
> xfs_repair.

The a5a5a5 in there looks like slab poisoning.  I'll try to come up with
a testcase based on your above report to try to reproduce it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
