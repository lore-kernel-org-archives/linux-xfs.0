Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E08EE7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:13:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AFBEE304048
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:13:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id txNXmlbyxT0sWqUC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:13:26 -0700 (PDT)
Date: Thu, 26 May 2016 09:12:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/7] xfs: test rmap behavior when multiple bmbt records
	map to a single rmapbt record
Message-ID: <20160526161257.GB16512@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
	<20160526080424.GA8469@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160526080424.GA8469@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 26, 2016 at 01:04:24AM -0700, Christoph Hellwig wrote:
> > --- a/src/t_immutable.c
> > +++ b/src/t_immutable.c
> > @@ -38,10 +38,10 @@
> >  #include <libgen.h>
> >  #include <sys/acl.h>
> >  #include <attr/xattr.h>
> > +#include <linux/fs.h>
> >  #include <xfs/xfs.h>
> >  #include <xfs/handle.h>
> >  #include <xfs/jdm.h>
> > -#include <linux/fs.h>
> >  #include <linux/magic.h>
> >  
> >  #ifndef XFS_SUPER_MAGIC
> 
> How does this belong into the patch?

It doesn't, this somehow jumped patches when I rebased. :/

> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index f0ca410..0e34f9a 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -288,3 +288,4 @@
> >  853 auto quick clone
> >  854 auto quick clone
> >  855 auto clone
> > +856 auto clone rmap reflink
> 
> This is the only test in the reflink group, how is this group different
> from the clone one?

I'm just gonna say 'thinko' and respin. :)

/me pours a larger cup of coffee...

(Thx for the review!)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
