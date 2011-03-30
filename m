Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2U9RWaF028863
	for <linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:27:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C971D144C34E
	for <linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 02:30:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4SHWG3GKlNkVSPd2 for
	<linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 02:30:43 -0700 (PDT)
Date: Wed, 30 Mar 2011 05:30:41 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110330093041.GB21819@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535D@MSXAOA6.twosigma.com>
	<20110330000942.GI3008@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110330000942.GI3008@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Sean Noonan <Sean.Noonan@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

On Wed, Mar 30, 2011 at 11:09:42AM +1100, Dave Chinner wrote:
> +	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
> +							KM_SLEEP | KM_NOFS);

The old code didn't use KM_NOFS, and I don't think it needed it either,
as we call the iop_format handlers inside the region covered by the
PF_FSTRANS flag.

Also I think the   routine needs to be under #ifndef XFS_NATIVE_HOST, as
we do not use it for big endian builds.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
