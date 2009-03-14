Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EFRZdl206556 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 10:27:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94082198798
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 08:26:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BkQobqbuEdPWFrLB for
	<xfs@oss.sgi.com>; Sat, 14 Mar 2009 08:26:52 -0700 (PDT)
Date: Sat, 14 Mar 2009 11:26:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LWN article: 4K disk sectors
Message-ID: <20090314152621.GB18811@infradead.org>
References: <200903121258.51497@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903121258.51497@zmi.at>
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

On Thu, Mar 12, 2009 at 12:58:51PM +0100, Michael Monnerie wrote:
> http://lwn.net/SubscriberLink/322777/16380cde8af0a37e/
> 
> 4K disk sectors coming 2011, might be interesting for devs to prepare 
> supporting it.

Fortunately there's not just the PC world.  4k is the standard sector
size of most common mainframe DASD so the Linux filesystems including
xfs deal with it very well.  The real issue are bootloader and anything
involving the DOS partitioning scheme.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
