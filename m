Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32ImYFZ238361 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 13:48:35 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KVkNoHw3QcmQE43A (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Apr 2012 11:48:31 -0700 (PDT)
Date: Mon, 2 Apr 2012 14:48:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Add XFS support in SYSLINUX
Message-ID: <20120402184830.GA12792@infradead.org>
References: <D9839BD8-29F4-4472-A5B5-7974497B14DD@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D9839BD8-29F4-4472-A5B5-7974497B14DD@gmail.com>
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
To: CHEN Baozi <baozich@gmail.com>
Cc: xfs@oss.sgi.com

Hi Chen,

thanks a lot for your interested in tackling this project.

Writing to the end of the first block would work for 4k or larger block
sizes filesystems, but it's not a very clean solution.

Id had a quick brainstorm with Dave and we came up with the following
idea:

 - create an extended attribute on the root filesystem that is larger
   than than the filesystem block size (typically 4k), and store the
   syslink payload in it.
 - for the first prototype get its block number using the GETBMAPX
   ioctl, and use it.

once that prototype works we can talk about a good interface for you.
We could precreate the attribute at mkfs time at a fixed block number
so that syslinux can hardcode it, or we could discuss any other kind
of interface that helps you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
