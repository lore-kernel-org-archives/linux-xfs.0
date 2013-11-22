Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEAC07F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 09:38:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C892E304070
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:38:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id F6WnGkTtxo9M6LET (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 07:38:58 -0800 (PST)
Date: Fri, 22 Nov 2013 07:38:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix assertion failure at xfs_setattr_nonsize
Message-ID: <20131122153858.GA19801@infradead.org>
References: <528F743D.9010800@oracle.com> <20131122151735.GA2405@infradead.org>
	<528F796F.6070601@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528F796F.6070601@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 22, 2013 at 11:34:07PM +0800, Jeff Liu wrote:
> On 11/22 2013  23:17 PM, Christoph Hellwig wrote:
> > On Fri, Nov 22, 2013 at 11:11:57PM +0800, Jeff Liu wrote:
> >> To remain the current semantics under the debug mode, this fix add
> >> an additional judgement to make this assertion only works for non-CRC
> >> enabled version.
> > 
> >>  		if (!gid_eq(igid, gid)) {
> >>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
> >> -				ASSERT(!XFS_IS_PQUOTA_ON(mp));
> >> +#ifdef DEBUG quota
> >> +				if (!xfs_sb_version_has_pquotino(&mp->m_sb))
> >> +					ASSERT(!XFS_IS_PQUOTA_ON(mp));
> >> +#endif
> >>  				ASSERT(mask & ATTR_GID);
> >>  				ASSERT(gdqp);
> > 
> > I'd just kill this assert.
> I hesitated about killing this assertion or hold the line before, will fix it soon.

If we want to keep it maybe write is a little nicer:

	ASSERT(xfs_sb_version_has_pquotino(&mp->m_sb) ||
	       !XFS_IS_PQUOTA_ON(mp));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
