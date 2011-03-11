Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2BA6tmb154533 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:07:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BA4533B774
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 02:09:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1WKpELX6v7BVEZBv for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 02:09:37 -0800 (PST)
Date: Fri, 11 Mar 2011 05:09:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Does XFS ever relocate extents after they are on disk?
Message-ID: <20110311100936.GA11879@infradead.org>
References: <903E14DC-D9EA-4BDC-8D43-FBB9AB4127BC@cs.ucsd.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <903E14DC-D9EA-4BDC-8D43-FBB9AB4127BC@cs.ucsd.edu>
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
To: Steven Swanson <swanson@cs.ucsd.edu>
Cc: xfs@oss.sgi.com

On Thu, Mar 10, 2011 at 11:55:21PM -0800, Steven Swanson wrote:
> I have simple question that I'm having trouble finding a concrete answer for:
> 
> Does XFS ever relocate a file or one of its extents once it's been written to disk?  For instance, does the file system ever decide to reorganize extents to reduce fragmentation.
> 
> I've read through all the documentation I can find, and everything points to using an external de-fragmentation tool, which suggests that XFS won't do it autonomously, but for the project we are working on it would be useful to know for certain when and under what conditions XFS might decide to move an extent that's already been written.

XFS kernel code will never move the written extents by itself.  The xfs_fsr
tool can instruct the kernel to move extents by the swapext ioctl, and
it can be run through a cron job, although that is usually not required.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
