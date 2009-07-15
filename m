Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6F3jdeX166395 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 22:45:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C84F363EE4
	for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 20:46:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9XSyazAikmIhXVhK for
	<xfs@oss.sgi.com>; Tue, 14 Jul 2009 20:46:19 -0700 (PDT)
Date: Tue, 14 Jul 2009 23:46:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs+nfs crash in 2.6.30 and 2.6.30.1
Message-ID: <20090715034618.GA21478@infradead.org>
References: <20090715030046.GA28592@rlogin.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090715030046.GA28592@rlogin.dk>
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
To: Michael Ole Olsen <gnu@gmx.net>
Cc: xfs <xfs@oss.sgi.com>

On Wed, Jul 15, 2009 at 05:00:47AM +0200, Michael Ole Olsen wrote:
> Everything was stable on server+client until the server got 2.6.30 kernel, 
> the mdadm raid6 only works in 2.6.30 or above - mdadm fails to initialize it in 
> anything else, so cannot downgrade (custom reshape to raid6 using echo into /sys,
>  all Q blocks on one disk).
> 
> I have experimented with mount options on the client, and the client has 
> been stable with these mount options before, when the server had a kernel
>  below 2.6.30

Yes, we had a few reports of this already, but not been able to track it
down.  Your instrcution below will be very helpful to reproduce and test
it, I will looks at it on thursday when I get back home to my test
systems.

> I saw someone talking about kernel stack size would be the cause for this xfs+nfs problem, 
> is there anything to this?

Unlikely, it looks like problem in the XFS inode cache code introduced
in 2.6.29.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
