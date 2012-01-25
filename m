Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PLEgAE071943 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 15:14:42 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7djwmycFbVGMAhOm (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Jan 2012 13:14:41 -0800 (PST)
Date: Wed, 25 Jan 2012 16:14:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: mount other filesystems with selinux
	context as well
Message-ID: <20120125211438.GA11821@infradead.org>
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org>
	<4F1862FC.1050401@sandeen.net>
	<20120124174500.GB9853@infradead.org>
	<4F20700B.8060307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F20700B.8060307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 25, 2012 at 03:11:39PM -0600, Eric Sandeen wrote:
> For some reason, non-xfs filesystems aren't getting mounted with
> the selinux context; perhaps because none of the xattr tests used
> to work on anything but xfs?
> 
> Anyway, 062 fails for extN unless we mount with the fs-wide
> context.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> ps: eparis says this should work for NFS as well, let's go for
> it and if infrequently tested filesystems have trouble we can
> exclude them as necessary.

Verifying that assumption isn't hard, please do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
