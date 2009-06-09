Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59GcMc0047610 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 11:38:22 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B65AD2E247B
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 09:38:41 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 7ujRjw6VDufN7nQu for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2009 09:38:41 -0700 (PDT)
Message-ID: <4A2E900B.3070100@sandeen.net>
Date: Tue, 09 Jun 2009 11:38:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
References: <4A2C8AD8.9030107@sandeen.net>	<20090608074230.GA28066@infradead.org>
	<20090609160622.GE63930@magus.portal.sigil.org>
In-Reply-To: <20090609160622.GE63930@magus.portal.sigil.org>
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
To: Richard Kolkovich <richard@intrameta.com>
Cc: xfs@oss.sgi.com

Richard Kolkovich wrote:
> Guys,
> 
> After applying the patch, we get much further.  xfs_repair then fails in phase 7:
> 
> 
> xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.
> 
> Aborted
> 
> 
> Any ideas on that one?  Thanks!

Yep, I meant to reply, I hit that one too.  Haven't yet looked into that
one ....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
