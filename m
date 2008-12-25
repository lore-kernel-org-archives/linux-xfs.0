Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBPHscOm022016 for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 11:54:38 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D60647DE9
	for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 09:54:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id oCFr7h57dR6DU9Qi for <xfs@oss.sgi.com>;
	Thu, 25 Dec 2008 09:54:36 -0800 (PST)
Message-ID: <4953C8B8.4010500@sandeen.net>
Date: Thu, 25 Dec 2008 11:54:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs_repair: allow filesystems with a single AG
References: <20081224231901.GA652@infradead.org>
In-Reply-To: <20081224231901.GA652@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Currently xfs_repair bails out on a filesystem with just a single AG.
> But that's a perfectly valid configureation, so we should allow it.
> 
> Skip the geomery validation because we simply can't do it if we don't
> have a secondary SB, and make sure to take the internal log into account
> when guestimating the first inode cluster.
> 
> I'll also cook up a testcase for repair on single AG filesystems.

While I think we should certainly allow this, what's the worst-case
scenario for a corrupted superblock when we can't validate it and
continue with repair?

I wonder if something like

# xfs_repair --allow-single-sb

should be required, with some man page docs suggesting a run with -n
first etc to be sure that garbled geometry doesn't trash the whole thing...?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
