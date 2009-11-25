Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPL8uW5008776 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 15:08:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7111CB5E09
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:09:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mwQ2VzZBcuLSxc5V for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:09:23 -0800 (PST)
Date: Wed, 25 Nov 2009 16:09:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS quota setup
Message-ID: <20091125210922.GA9823@infradead.org>
References: <200911241203.45604@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911241203.45604@zmi.at>
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

On Tue, Nov 24, 2009 at 12:03:45PM +0100, Michael Monnerie wrote:
> I took this from the manpage:
> xfs_quota -x -c 'project -s upload' /disks/sharestore/upload/
> xfs_quota: cannot setup path for mount /disks/sharestore/upload/: No 
> such device or address
> 
> but this works:
> cd /disks/sharestore/
> xfs_quota -x -c 'project -s upload'

I can't see these specific paths mentioned in the manpage.  The last
argument to xfs_quota should always be a mountpoint, is
/disks/sharestore/upload/ a mountpoint?

> Maybe the docs can be simpler? It's confusing now.

Suggestions or even better patches are welcome.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
