Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3N9lk41002473 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 04:47:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42132234BC3
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 02:47:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id n7vXsj5X4tQKo3y2 for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 02:47:43 -0700 (PDT)
Date: Thu, 23 Apr 2009 05:47:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
Message-ID: <20090423094741.GA23157@infradead.org>
References: <1416563271.242851240369384712.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<811197347.242901240369616266.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <811197347.242901240369616266.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


Lachlan,

any chance we could get you to resubmit the minimal locking fix for now?

We can play with the test program than to find some cause the other
corruptions.  We also still have that non-freed attr fork patch that was
somewhat related which we still need get done :P

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
