Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6LBISNo159828 for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 06:18:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B085130D9C2
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 04:27:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AbWlvYquJndDBl5b for
	<xfs@oss.sgi.com>; Tue, 21 Jul 2009 04:27:18 -0700 (PDT)
Date: Tue, 21 Jul 2009 07:19:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs tries to write on readonly device on unmount
Message-ID: <20090721111909.GA29399@infradead.org>
References: <2009-07-21T12-28-50@devnull.michael-prokop.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2009-07-21T12-28-50@devnull.michael-prokop.at>
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
To: Michael Prokop <mika@grml.org>
Cc: xfs@oss.sgi.com

On Tue, Jul 21, 2009 at 12:51:20PM +0200, Michael Prokop wrote:
> Hi,
> 
> This issue might be related to
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=413
> 
> A XFS partition is set to read-only mode (using 'blockdev --setro')
> and mounted. As soon as I *un*mount the filesystem there seem to
> happen write requests.
> 
> I've a Tableau Forensic Bridge? which avoids the write requests and
> attached it to a Linux live-system running kernel 2.6.28 inside
> VMware and Virtualbox. I can easily reproduce the problem.


Block 0 is the superblock, so it appears like there is a superblock
write somewhere not guarded by an read-only check.  Can you still
reproduce this with a current kernel?  We now do have a testcase in
xfsqa (test 200) that checks exactly that scenario, but it doesn't
show issues on recent kernels.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
