Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01NcmOU005114 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 17:38:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4592A5855C
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 15:20:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SFO94DeAwBMp9SXC for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 15:20:47 -0800 (PST)
Date: Thu, 1 Jan 2009 18:20:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error when NFS client accesses nonexistent inode
Message-ID: <20090101232016.GA4476@infradead.org>
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
	<20090101171409.GA18020@infradead.org>
	<20090101190039.GA29959@infradead.org>
	<87ocyqpqhp.fsf@server.ak.quickcircuit.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ocyqpqhp.fsf@server.ak.quickcircuit.co.nz>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 02, 2009 at 12:15:46PM +1300, Mario Becroft wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Btw, you update /proc/sys/fs/xfs/error_level manually?  The corruption
> > test only triggers from a avalue of 5, but 3 is the default.
> 
> I was getting:
> 
> Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117
> 
> and in trying to figure out what it meant, I bumped up the XFS debug
> level to 6, which enabled me to see the errors from XFS. Maybe I should
> have just left it alone?
>
> I should have pointed out that when this happened, the filesystem did
> not actually shut down. So it did not cause any real problems. Should it
> have been shutting down?
> 
> I was mainly just worried that depending on what data it happened to hit

Looking at the code again there indeed aren't shutdowns, just
stacktraces.  So yes, the stacktraces are caused by the higher error
level.  With debug kernels it's still a kernel crash though, but no one
should run debug kernels on their production machines.

> when accessing the nonexistent inode, it might screw things up. If I do
> encounter any shutdowns, I will apply the patch you sent through. Thanks
> for the ultra-fast response.

Please try the second patch which I cc'ed you on as it gives back
the correct error code to the nfs clients.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
