Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8GCCSE151481 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 10:12:13 -0600
Date: Thu, 8 Dec 2011 11:12:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/19] xfs: remove the deprecated nodelaylog option
Message-ID: <20111208161210.GA6326@infradead.org>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215852.699758135@bombadil.infradead.org>
	<20111207214453.GR29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111207214453.GR29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 07, 2011 at 03:44:53PM -0600, Ben Myers wrote:
> > -	log->l_cilp = NULL;
> > -	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
> > -		return 0;
> > -
> 
> There is a section of comment above xlog_cil_init that only applies if
> we could still switch the CIL off.  It should be removed with this
> patch.

Indeed.  If there's enough comments that I need to respin the series
I'll remove it.  If not please just remove it for while commiting the
patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
