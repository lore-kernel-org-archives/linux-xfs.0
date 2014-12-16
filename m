Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC3DD7F3F
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 01:56:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B6368F8035
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 23:56:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HggkXOFCBjESqdST (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2014 23:56:08 -0800 (PST)
Date: Mon, 15 Dec 2014 23:56:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141216075605.GA24633@infradead.org>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141215201036.GQ24183@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 16, 2014 at 07:10:36AM +1100, Dave Chinner wrote:
> The controller is broken if it's returning EIO to reads when it
> is busy.

What controller is this?  SCSI devices can return a QUEUE BUSY
indicator, so having a RAID controller do something similar doesn't
sound unusual.  But the driver needs to returns translate that into
a QUEUE BUSY so that the SCSI midlayer can handle it correctly.

It might make sense to take this to linux-scsi with the driver
maintainer in Cc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
