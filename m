Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H9CUe6214246 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 03:12:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F37F719534A5
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:11:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DO6E99dfQcTXLFeG for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:11:56 -0800 (PST)
Date: Tue, 17 Feb 2009 04:11:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS and XEN
Message-ID: <20090217091124.GA7118@infradead.org>
References: <200902170959.55077@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902170959.55077@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Feb 17, 2009 at 09:59:54AM +0100, Michael Monnerie wrote:
> Now I'm sure that the following configuration can destroy a PostgreSQL 
> 8.3.5 database:
> 
> * Linux host with XEN, XFS filesystem with "nobarrier", RAID controller 
> with battery backed cache.
> * XEN vm with XFS filesystem with "nobarrier" with postgresql
> * your daughter with 3.5 years switching off the power supply of the 
> server
> 
> I guess one shouldn't use "nobarrier" on a XEN XFS domU machine.
> Would that help? I'd like to enter this in the FAQ, as people (including 
> me) will be very upset to loose data, or destroy databases.

I'm not even sure the Xen driver implements barriers.  I haven't done
much with Xen, but with the default kvm/qemu config I can completely
wreck ext3 and XFS filesystems.  If using these virtualization solutions
make sure you do not cache the virtual block device in the host
pagecache, and that in doubt the write cache of the disk is turned off
as barriers most likely won't work through the virtualization stack.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
