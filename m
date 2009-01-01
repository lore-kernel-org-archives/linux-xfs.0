Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01J0ecQ014186 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 13:00:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FF171BF81F4
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 11:00:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3dDGwCEoFJ0en9mT for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 11:00:39 -0800 (PST)
Date: Thu, 1 Jan 2009 14:00:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error when NFS client accesses nonexistent inode
Message-ID: <20090101190039.GA29959@infradead.org>
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
	<20090101171409.GA18020@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090101171409.GA18020@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mario Becroft <mb@gem.win.co.nz>
Cc: xfs@oss.sgi.com

Btw, you update /proc/sys/fs/xfs/error_level manually?  The corruption
test only triggers from a avalue of 5, but 3 is the default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
