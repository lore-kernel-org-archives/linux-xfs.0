Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3O2hmdS053572 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 21:43:48 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766121CE3B34
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 19:43:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id cLHg3yzrc68srkNs for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 19:43:44 -0700 (PDT)
Date: Thu, 23 Apr 2009 22:43:16 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <144122190.4081240540996189.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20090423094741.GA23157@infradead.org>
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> Lachlan,
> 
> any chance we could get you to resubmit the minimal locking fix for
> now?

Okay, done.  If people still see problems then we should take the
rest of the patch too (of course I would suggest taking it anyway
but it needs more soak testing).

> 
> We can play with the test program than to find some cause the other

I suggest increasing or decreasing the -l argument until you can
reproduce the problem.  Timing it so that the file's data is being
flushed to disk (and therefore delayed allocations being converted
and extents merged) at the same time the file is closed (ie the
fput() is done) can be tricky.

It may be easier to reproduce if another program, running concurrently
to the test program, is simply opening and close the file repeatedly.

> corruptions.  We also still have that non-freed attr fork patch that
> was
> somewhat related which we still need get done :P
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
