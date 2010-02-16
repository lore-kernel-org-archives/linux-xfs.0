Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jahc132001 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2EE41CD31F0
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LuK94dln2C3UFxmA for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084446.377980079@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/10] quotactl fixed and cleanups
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
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

This is a first large batch of refactoring the generic quotactl code.
I started looking at this for merging the FS interfaces for "VFS" and "XFS"
style quotas now that we grow more filesystems wanting to support quota
in a more advanced way than the generic implementation can, e.g. GFS2
and cifs.  There will be another couple of patches do do the actual
work which are not quite ready, but this is a large and useful enough batch
to get review and possibly included first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
