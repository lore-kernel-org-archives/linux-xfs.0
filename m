Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JINAdj220419 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:23:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 207E214E4A69
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:23:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uRGE7fkixOSz1ElS for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:23:59 -0700 (PDT)
Date: Wed, 19 Aug 2009 14:20:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel crash with >2.6.28.10 + drbd + nfs + xfs + heartbeat
Message-ID: <20090819182049.GA10787@infradead.org>
References: <4A8C37F3.90300@actusa.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A8C37F3.90300@actusa.net>
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
To: Stuart Sheldon <stu@actusa.net>
Cc: support@actusa.net, xfs@oss.sgi.com

On Wed, Aug 19, 2009 at 10:35:47AM -0700, Stuart Sheldon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> Hi all,
> 
> I've traced this down to what looks to be a XFS problem. When executing
> a hb_standby the system crashes with the following error on the console:

Known problem.  Fixed in latest mainline, and
http://bugzilla.kernel.org/show_bug.cgi?id=13375 has backports for
2.6.29 and 2.6.30.  I will send them to 2.6.30-stable this week, but
there is no 2.6.29-stable anymore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
