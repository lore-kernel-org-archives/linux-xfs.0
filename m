Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGGn5V146108
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:16:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1013A3BF8D9
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:19:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qWpUZ0SLDbxhjjY9 for
	<linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:19:23 -0700 (PDT)
Date: Fri, 11 Jun 2010 12:19:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-2.6.34 xfs crash: xfs_inode_ag_iterator+0x6c - NULL
	pointer dereference
Message-ID: <20100611161922.GB7556@infradead.org>
References: <hur8at$jua$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <hur8at$jua$1@dough.gmane.org>
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
To: Peter Niemayer <niemayer@isg.de>
Cc: linux-xfs@oss.sgi.com

On Thu, Jun 10, 2010 at 07:45:01PM +0200, Peter Niemayer wrote:
> Hi,
> 
> FYI: attached screen-shot is from a server that crashed today when
> doing an "umount" of a no longer needed XFS partition on a SSD
> (mount options: rw,noatime,nodiratime,nobarrier)
> 
> (The operations on that filesystem ended > 1 day before the umount,
>  and did not show any problem)
> 
> Kernel was plain vanilla 2.6.34.

Unfortunately the backtrace doesn't really tell what has happened as
the origin of the backtrace scrolled away.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
