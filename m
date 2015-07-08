Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9E0F7F54
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 03:53:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B533C304064
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 01:53:45 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id gs5RlFMmGtM0ZzFZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 01:53:43 -0700 (PDT)
Date: Wed, 8 Jul 2015 10:53:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs_io bmap confused
Message-ID: <20150708085341.GA23332@lst.de>
References: <1436338913.13729.11.camel@hasee>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436338913.13729.11.camel@hasee>
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
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 08, 2015 at 12:01:53AM -0700, Ming Lin wrote:
> Hi list,
> 
> I am testing some direct-io patches.
> xfs_tests/xfs/080 failed.
> 
> It's strange.
> There is no hole in "rwtest.file",
> but when read it at some offset it returns zero because of hole.
> 
> root@block:~# xfs_io -c bmap /mnt/test/rwtest.file
> /mnt/test/rwtest.file:
>              0: [0..125671]: 160..125831

Sounds like you see an unwritten extent.  What does xfs_bmap -pv show on
the file?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
