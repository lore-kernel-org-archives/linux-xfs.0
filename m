Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01NTMJu004505 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 17:29:25 -0600
Received: from isp.becroft.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D7075882E
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 15:29:20 -0800 (PST)
Received: from isp.becroft.co.nz (isp.becroft.co.nz [202.89.33.33]) by
	cuda.sgi.com with ESMTP id s7ZrwuNjQGWR6qMS for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 15:29:20 -0800 (PST)
Subject: Re: XFS internal error when NFS client accesses nonexistent inode
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
	<20090101171409.GA18020@infradead.org>
	<20090101190039.GA29959@infradead.org>
From: Mario Becroft <mb@gem.win.co.nz>
Date: Fri, 02 Jan 2009 12:15:46 +1300
In-Reply-To: <20090101190039.GA29959@infradead.org> (Christoph Hellwig's
	message of "Thu\, 1 Jan 2009 14\:00\:39 -0500")
Message-ID: <87ocyqpqhp.fsf@server.ak.quickcircuit.co.nz>
MIME-Version: 1.0
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

Christoph Hellwig <hch@infradead.org> writes:

> Btw, you update /proc/sys/fs/xfs/error_level manually?  The corruption
> test only triggers from a avalue of 5, but 3 is the default.

I was getting:

Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117

and in trying to figure out what it meant, I bumped up the XFS debug
level to 6, which enabled me to see the errors from XFS. Maybe I should
have just left it alone?

I should have pointed out that when this happened, the filesystem did
not actually shut down. So it did not cause any real problems. Should it
have been shutting down?

I was mainly just worried that depending on what data it happened to hit
when accessing the nonexistent inode, it might screw things up. If I do
encounter any shutdowns, I will apply the patch you sent through. Thanks
for the ultra-fast response.

I realise preserving inode/generation numbers on dump/restore is
probably hard and never going to happen. None of the other Linux
filesystems I have looked at do it either. It would be very, very nice
though... This is a feature I have wanted for ages.

-- 
Mario Becroft <mb@gem.win.co.nz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
