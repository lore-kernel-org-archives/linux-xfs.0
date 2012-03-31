Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2VFdgAW168406 for <xfs@oss.sgi.com>; Sat, 31 Mar 2012 10:39:42 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8ACixipga89dUx4N (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 Mar 2012 08:39:37 -0700 (PDT)
Date: Sat, 31 Mar 2012 11:39:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
Message-ID: <20120331153935.GA30352@infradead.org>
References: <4F75DE2B.7030807@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F75DE2B.7030807@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 30, 2012 at 11:24:11AM -0500, Eric Sandeen wrote:
> This ASSERT is testing an if_flags flag value against
> a di_aformat enum value.  di_aformat is never assigned
> XFS_IFINLINE.
> 
> This happens to work for now, because XFS_IFINLINE has
> the same value as XFS_DINODE_FMT_LOCAL, and that's tested
> just before we call this function.
> 
> However, I think the intention is to assert that we have
> read in the data, i.e. XFS_IFINLINE on if_flags, before
> we use if_data.  This is done in other places through the
> code as well.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
