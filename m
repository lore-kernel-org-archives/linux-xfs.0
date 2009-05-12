Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CFulV7082151 for <xfs@oss.sgi.com>; Tue, 12 May 2009 10:56:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1249427DA01
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 08:56:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oZA5BfvD0jjIfv5C for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 08:56:53 -0700 (PDT)
Date: Tue, 12 May 2009 11:56:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with XFS on iSCSI in RHEL4
Message-ID: <20090512155653.GA28714@infradead.org>
References: <Pine.LNX.4.64.0905061149480.26440@andrew.triumf.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905061149480.26440@andrew.triumf.ca>
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
To: Andrew Daviel <advax@triumf.ca>
Cc: linux-iscsi-users@lists.sourceforge.net, xfs@oss.sgi.com

On Wed, May 06, 2009 at 12:32:25PM -0700, Andrew Daviel wrote:
> When I create an ext3 volume on the Sun, things are OK.
> When I create an XFS volume, after doing mkdir, I get e.g.
>   kernel: Bad page state at free_hot_cold_page (in process 'iscsi-rx',
>   page c1069a20)
>   kernel: Trying to fix it up, but a reboot is needed
>   kernel: Bad page state at free_hot_cold_page (in process 'syslogd',
>   page c1069a20)

That looks like the old disagreement on whether we could send
non-refcountable pages to the block layer.  XFS used to do this and
iscsi didn't like it.  Until today it's still not specified if it
is allowed or not and most drivers don't care but XFS stopped doing
that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
