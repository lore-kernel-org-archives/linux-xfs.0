Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E27D57F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 11:01:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3019304048
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:01:43 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dO6o6E0pElEJBOAx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 09:01:42 -0800 (PST)
Date: Tue, 20 Jan 2015 18:01:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/17] quota: Wire up ->quota_{enable,disable} callbacks
	into Q_QUOTA{ON,OFF}
Message-ID: <20150120170139.GD3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-3-git-send-email-jack@suse.cz>
	<20150119090121.GB27474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119090121.GB27474@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon 19-01-15 01:01:21, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:36PM +0100, Jan Kara wrote:
> > Make Q_QUOTAON / Q_QUOTAOFF quotactl call ->quota_enable /
> > ->quota_disable callback when provided. To match current behavior of
> > ocfs2 & ext4 we make these quotactls turn on / off quota enforcement for
> > appropriate quota type.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/quota/quota.c         | 31 +++++++++++++++++++++++++++----
> >  include/linux/quotaops.h |  2 ++
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > index 5b307e2b5719..748716ffee48 100644
> > --- a/fs/quota/quota.c
> > +++ b/fs/quota/quota.c
> > @@ -66,18 +66,43 @@ static int quota_sync_all(int type)
> >  	return ret;
> >  }
> >  
> > +unsigned int qtype_limit_flag(int type)
> > +{
> > +	switch (type) {
> > +	case USRQUOTA:
> > +		return FS_QUOTA_UDQ_ENFD;
> > +	case GRPQUOTA:
> > +		return FS_QUOTA_GDQ_ENFD;
> > +	case PRJQUOTA:
> > +		return FS_QUOTA_PDQ_ENFD;
> > +	}
> > +	return 0;
> 
> 
> What's the limit_ in the name supposed to mean?
  qtype_enforce_flag() explains probably better what's going on so I've
used that instead.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
