Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NEVRol130657 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 09:31:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D204E52536
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 07:44:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5a5pNQ0xpqpI2RdA for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 07:44:56 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:32:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100923143221.GA1989@infradead.org>
References: <4C9B5786.4010205@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C9B5786.4010205@open-e.com>
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
To: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
Cc: Artur Piechocki <artur.piechocki@open-e.com>, =?UTF-8?B?xYF1aw==?=@oss.sgi.com, asz Wittig <lukasz.wittig@open-e.com>, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, xfs@oss.sgi.com

On Thu, Sep 23, 2010 at 03:35:02PM +0200, Slawomir Nowakowski wrote:
> Dear Sir,
> 
> We are using iSCSI FileIO on the LVM. The file (called lun) has been

What is iSCSI FileIO?

> initialized with:
> dd if=/dev/zero of=/dev/vg+vg00/lv+i+lv0000 bs=1M conv=notrunc
> 
> on the XFS formatted logical volume.
> 
> Additionally, we use 2.6.27-39 kernel  and xfs-tools 2.10.1
> 
> After some time, without any additional errors, we are not able
> mount the volume. After mount command we get:

Please describe the full storage topology.  But most likely it's an
issue with your underlying storage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
