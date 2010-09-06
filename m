Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o861G1sp143578 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 20:16:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEF7514E6AE1
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 18:27:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	GC53U776u0cVDAmR for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 18:27:41 -0700 (PDT)
Date: Mon, 6 Sep 2010 11:16:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: separate project quota from group quota (questions, design issues)
Message-ID: <20100906011640.GZ7362@dastard>
References: <201009041000.55878.arekm@maven.pl>
	<20100904233053.GA26586@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100904233053.GA26586@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Sep 04, 2010 at 07:30:53PM -0400, Christoph Hellwig wrote:
> Thanks for doing this work Arek, I think it will be useful for some
> users and defintively is cleaners than what we have now.
> 
> > I started doing that by splitting every group+project handling code into 
> > separate group and project one. Added superblock field for project quota. New 
> > feature flag (SEPARATEPQUOTA).
> 
> Ok.
> 
> > If old filesystem (for SEPARATEQUOTA) is mounted then I'll simply load 
> > sb_gquotino into mp->m_sb.sb_pquotino which I think is enough to handle old fs 
> > (since new kernel operates on separate structures for project quota).
> 
> Do you mean an old filesystem without the SEPARATEQUOTA bit set here?
> 
> > New filesystem (without quota inodes allocated yet), when mounted, gets new 
> > quota inode allocated for project quota and SEPARATEQUOTA feature bit set.
> 
> I think we need the SEPARATEQUOTA bit set explicitly by
> mkfs.xfs/xfs_admin.  But once we start using project quotas with the
> bit set the above sounds fine.

Agreed - we can't set the bit by default until the kernel has
suppoerted the feature for some time. A user who upgrades from a
kernel that doesn't support separate quotas can't downgrade if the
bit is automatically set if there are problems (and the problems
requiring downgrade might be completely unrelated to XFS).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
