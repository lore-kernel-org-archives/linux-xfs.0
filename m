Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 529C17F99
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 04:22:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F1408F8087
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 02:22:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id TSJTk2tRSnVRxVPS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 02:22:28 -0700 (PDT)
Date: Wed, 16 Jul 2014 02:22:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: v0.80.4 Firefly released
Message-ID: <20140716092226.GA23561@infradead.org>
References: <alpine.DEB.2.00.1407151634250.21336@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1407151634250.21336@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 15, 2014 at 04:45:59PM -0700, Sage Weil wrote:
> This Firefly point release fixes an potential data corruption problem
> when ceph-osd daemons run on top of XFS and service Firefly librbd
> clients.  A recently added allocation hint that RBD utilizes triggers
> an XFS bug on some kernels (Linux 3.2, and likely others) that leads
> to data corruption and deep-scrub errors (and inconsistent PGs).  This
> release avoids the situation by disabling the allocation hint until we
> can validate which kernels are affected and/or are known to be safe to
> use the hint on.

I've not really seen an report for that on the XFS list, could it be
that you're running into the issue fixed by

 "xfs: Use preallocation for inodes with extsz hints"

(commit aff3a9edb7080f69f07fe76a8bd089b3dfa4cb5d)?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
