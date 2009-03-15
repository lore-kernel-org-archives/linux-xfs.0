Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2F8JLh1258521 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:19:42 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 788BA1C433B7
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 01:18:59 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	jS5GBbKJAbpFYtmy for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 01:18:59 -0700 (PDT)
Date: Sun, 15 Mar 2009 19:18:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: use generic Posix ACL code
Message-ID: <20090315081856.GW26138@disturbed>
References: <20090220205117.GA7943@infradead.org>
	<20090304173008.GA32471@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090304173008.GA32471@infradead.org>
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

On Wed, Mar 04, 2009 at 12:30:08PM -0500, Christoph Hellwig wrote:
> On Fri, Feb 20, 2009 at 03:51:17PM -0500, Christoph Hellwig wrote:
> > This patch rips out the XFS ACL handling code and uses the generic
> > fs/posix_acl.c code instead.  The ondisk format is of course left
> > unchanged.
> > 
> > This also introduces the same ACL caching all other Linux filesystems do
> > by adding pointers to the acl and default acl in struct xfs_inode.
> 
> FYI: there was one hunk that slipped into another patch so that it
> was missing in this one.  Correct one below:
> 
> 
> This patch rips out the XFS ACL handling code and uses the generic
> fs/posix_acl.c code instead.  The ondisk format is of course left
> unchanged.
> 
> This also introduces the same ACL caching all other Linux filesystems do
> by adding pointers to the acl and default acl in struct xfs_inode.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I haven't done an in-depth review of this, but i can't find any
glaring problems while reading over the diff. So, in the interests of
moving this forward, you can add a:

Acked-by: Dave Chinner <david@fromorbit.com>

to this. I think at this point it probably should be pushed into the
dev tree and aimed at 2.6.31....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
