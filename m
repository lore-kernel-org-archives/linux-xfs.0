Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13LRRvr161291
	for <linux-xfs@oss.sgi.com>; Fri, 3 Feb 2012 15:27:28 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vLbPAEYRRmBGxvXt (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 13:27:26 -0800 (PST)
Date: Fri, 3 Feb 2012 16:27:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A corruption that seems to span a few kernels
Message-ID: <20120203212724.GA22100@infradead.org>
References: <4F2C3D46.1010509@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2C3D46.1010509@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Feb 03, 2012 at 03:02:14PM -0500, Joe Landman wrote:
> XFS file system, built using a 2.6.32.41 kernel.  External journals.
> 
> repair the file system, mount, turn on gluster (3.2.5), do a find,
> and get a corruption.  Actually it looks like xfs_repair doesn't fix
> the problem.
> 
> Rinse repeat, reproduce.  Works (procedure to generate the
> corruption) in 2.6.32.41.scalable, 2.6.39.1, 3.2.2

[PATCH v2] repair: update extent count after zapping duplicate blocks

which was sent to the list yesterday should make xfs_repair handle this
case.

How do you reproduce the corruption?  Just start gluster on a fresh fs
an do a find?  Any chance you could share command lines used?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
