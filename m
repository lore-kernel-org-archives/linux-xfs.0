Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6E2A7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 15:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 890818F804B
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 13:21:11 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id C0ISEipv2IQizfjQ for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2016 13:21:05 -0700 (PDT)
Date: Wed, 13 Jul 2016 16:21:04 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v2] xfs: abstract block export operations from nfsd layouts
Message-ID: <20160713202104.GA10734@fieldses.org>
References: <6c1549ee874431c8293cad72c5f7382095277822.1467985684.git.bcodding@redhat.com>
	<20160710094540.GA19392@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160710094540.GA19392@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Benjamin Coddington <bcodding@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Sun, Jul 10, 2016 at 11:45:40AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 08, 2016 at 09:53:20AM -0400, Benjamin Coddington wrote:
> > Instead of creeping pnfs layout configuration into filesystems, move the
> > definition of block-based export operations under a more abstract
> > configuration.
> > 
> > Changes from v1:
> > 	- dropped the first patch in the first posting
> > 	- renamed the config to EXPORTFS_BLOCK_OPS from BLOCK_EXPORT_OPS
> > 	- add an explicit default to no for EXPORTFS_BLOCK_OPS
> > 	- add some help and menu text
> > 
> > Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> > ---
> >  fs/Kconfig          | 7 +++++++
> >  fs/nfsd/Kconfig     | 2 ++
> >  fs/xfs/Makefile     | 3 +--
> >  fs/xfs/xfs_export.c | 2 +-
> >  fs/xfs/xfs_pnfs.h   | 4 ++--
> >  5 files changed, 13 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 6725f59c18e6..ac6d3b36600c 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -66,6 +66,13 @@ config FS_POSIX_ACL
> >  config EXPORTFS
> >  	tristate
> >  
> > +config EXPORTFS_BLOCK_OPS
> > +	bool "Enable filesystem export operations for block IO"
> > +	default n
> 
> default n is the default, no need to add it.
> 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.  Applied, with that one "default n" line dropped.

An ACK from Dave might also help reassure Linus I'm not stepping on
anybody's toes.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
