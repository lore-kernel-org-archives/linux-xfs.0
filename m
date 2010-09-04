Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o84NUDgM079349 for <xfs@oss.sgi.com>; Sat, 4 Sep 2010 18:30:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D107A15DFE76
	for <xfs@oss.sgi.com>; Sat,  4 Sep 2010 16:41:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hUInwq6HarkHg5b9 for
	<xfs@oss.sgi.com>; Sat, 04 Sep 2010 16:41:48 -0700 (PDT)
Date: Sat, 4 Sep 2010 19:30:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: separate project quota from group quota (questions, design issues)
Message-ID: <20100904233053.GA26586@infradead.org>
References: <201009041000.55878.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009041000.55878.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

Thanks for doing this work Arek, I think it will be useful for some
users and defintively is cleaners than what we have now.

> I started doing that by splitting every group+project handling code into 
> separate group and project one. Added superblock field for project quota. New 
> feature flag (SEPARATEPQUOTA).

Ok.

> If old filesystem (for SEPARATEQUOTA) is mounted then I'll simply load 
> sb_gquotino into mp->m_sb.sb_pquotino which I think is enough to handle old fs 
> (since new kernel operates on separate structures for project quota).

Do you mean an old filesystem without the SEPARATEQUOTA bit set here?

> New filesystem (without quota inodes allocated yet), when mounted, gets new 
> quota inode allocated for project quota and SEPARATEQUOTA feature bit set.

I think we need the SEPARATEQUOTA bit set explicitly by
mkfs.xfs/xfs_admin.  But once we start using project quotas with the
bit set the above sounds fine.

> Converting old fs to separate quota isn't currently solved. User could need 
> two choices - use old group quota still as group or old group as new project 
> quota. Not sure how to handle these yet. 

We know what sb_gquotino is used for currently from sb_qflags.  If it's
used for group quota we can simply set the SEPARATEQUOTA bit and we're
done.  To convert a filesystem using project quotas to SEPARATEQUOTA
sb_gquotino needs to be cleared and instead the new sb_pquotino field
needs to point to the project quota inode.


Need to go now, I'll answer to your other questions once I had some more
time to review them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
