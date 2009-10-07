Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n971JDN6148925 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 20:19:13 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 544DF1B982B0
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 18:20:38 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id IS8qviOS9JyMAU77 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 18:20:38 -0700 (PDT)
Date: Wed, 7 Oct 2009 12:20:31 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1157959921.9631254878431584.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20091007011850.GA32032@infradead.org>
Subject: Re: [PATCH] mkfs: add discard support
MIME-Version: 1.0
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


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> > It might be a bit cleaner to add this in with the existing
> platform-
> > specific code in libxfs/linux.c (or perhaps
> include/platform_defs.h)
> > with wrappers for the other platforms, rather than putting it
> directly
> > in mkfs like this?  repair may want to use this someday too, I
> guess.
> 
> How about this one?
> 

Looks good to me.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
