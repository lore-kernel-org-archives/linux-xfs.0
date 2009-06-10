Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ALmZ9U116705 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 16:48:36 -0500
Received: from mail.sigil.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9865C1D3DEF1
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 14:48:55 -0700 (PDT)
Received: from mail.sigil.org (tx1-250.intrameta.com [69.13.51.250]) by
	cuda.sgi.com with ESMTP id fXsmWtw3CSe3aoSd for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 14:48:55 -0700 (PDT)
Date: Wed, 10 Jun 2009 16:47:51 -0500
From: Richard Kolkovich <richard@intrameta.com>
Subject: Re: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
Message-ID: <20090610214750.GB39123@divination.intrameta.com>
References: <4A2C8AD8.9030107@sandeen.net>
	<20090608074230.GA28066@infradead.org>
	<20090609160622.GE63930@magus.portal.sigil.org>
	<4A2E900B.3070100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2E900B.3070100@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jun 09, 2009 at 12:38:35PM -0400, Eric Sandeen wrote:
> Richard Kolkovich wrote:
> > Guys,
> > 
> > After applying the patch, we get much further.  xfs_repair then fails in phase 7:
> > 
> > 
> > xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.
> > 
> > Aborted
> > 
> > 
> > Any ideas on that one?  Thanks!
> 
> Yep, I meant to reply, I hit that one too.  Haven't yet looked into that
> one ....
> 
> -Eric

Any ideas on a workaround if not a fix?  We really just want to get through the repair and see what
(if anything) is still usable...

Thanks!

-- 

Richard Kolkovich
IntraMeta Corporation
richard@intrameta.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
