Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q341aX5Q041675 for <xfs@oss.sgi.com>; Tue, 3 Apr 2012 20:36:33 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id kDKPo4J950Gh7uz1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Apr 2012 18:36:32 -0700 (PDT)
Received: by dadz9 with SMTP id z9so439495dad.5
	for <xfs@oss.sgi.com>; Tue, 03 Apr 2012 18:36:31 -0700 (PDT)
Subject: Re: [RFC] Add XFS support in SYSLINUX
Mime-Version: 1.0 (Apple Message framework v1084)
From: CHEN Baozi <baozich@gmail.com>
In-Reply-To: <20120402184830.GA12792@infradead.org>
Date: Wed, 4 Apr 2012 09:36:24 +0800
Message-Id: <28D73E4A-4288-459E-BF55-DEC2E34E60A2@gmail.com>
References: <D9839BD8-29F4-4472-A5B5-7974497B14DD@gmail.com>
	<20120402184830.GA12792@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Thanks for advice:-) 

Baozi
On Apr 3, 2012, at 2:48 AM, Christoph Hellwig wrote:

> Hi Chen,
> 
> thanks a lot for your interested in tackling this project.
> 
> Writing to the end of the first block would work for 4k or larger block
> sizes filesystems, but it's not a very clean solution.
> 
> Id had a quick brainstorm with Dave and we came up with the following
> idea:
> 
> - create an extended attribute on the root filesystem that is larger
>   than than the filesystem block size (typically 4k), and store the
>   syslink payload in it.
> - for the first prototype get its block number using the GETBMAPX
>   ioctl, and use it.
> 
> once that prototype works we can talk about a good interface for you.
> We could precreate the attribute at mkfs time at a fixed block number
> so that syslinux can hardcode it, or we could discuss any other kind
> of interface that helps you.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
