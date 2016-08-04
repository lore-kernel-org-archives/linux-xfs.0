Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DCC17CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:46:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F34D5AC003
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 08:46:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7jGWgbyri3emyqdC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 08:46:36 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:46:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 37/45] drivers: use req op accessor
Message-ID: <20160804154622.GB15656@infradead.org>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
	<CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
	<87fbe31f-27b3-ff7a-e381-34fc1aad337e@redhat.com>
	<CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
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
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: philipp.reisner@linbit.com, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, konrad.wilk@oracle.com, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, osd-dev@open-osd.org, Ross Zwisler <zwisler@gmail.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, ocfs2-devel@oss.oracle.com

On Wed, Aug 03, 2016 at 07:30:29PM -0500, Shaun Tancheff wrote:
> I think the translation in loop.c is suspicious here:
> 
>     "if use DIO && not (a flush_flag or discard_flag)"
> should translate to:
>     "if use DIO && not ((a flush_flag) || op == discard)"
> 
> But in the patch I read:
>     "if use DIO && ((not a flush_flag) || op == discard)
> 
> Which would have DIO && discards follow the AIO path?

Indeed.  Sorry for missing out on your patch, I just sent a fix
in reply to Dave's other report earlier which is pretty similar to
yours.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
