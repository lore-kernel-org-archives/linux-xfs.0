Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n71J1tmq237196 for <xfs@oss.sgi.com>; Sat, 1 Aug 2009 14:01:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22AE914A042E
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2009 12:11:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jecbeKmuMbEgrHnK for
	<xfs@oss.sgi.com>; Sat, 01 Aug 2009 12:11:51 -0700 (PDT)
Date: Sat, 1 Aug 2009 15:02:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Circular locking on rawhide 2.6.31-0.81.rc3.git4
Message-ID: <20090801190243.GB10391@infradead.org>
References: <4A6DE939.6050606@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A6DE939.6050606@redhat.com>
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
To: Prarit Bhargava <prarit@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Jul 27, 2009 at 01:51:53PM -0400, Prarit Bhargava wrote:
> Hello everyone,
>
> This was seen while doing a "rpmbuild -bp kernel.spec" on a recent  
> rawhide build.

This should be fixed by the patch

	[PATCH 3/3] xfs: do not wait for the iolock in xfs_free_eofblocks      

I sent to the list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
