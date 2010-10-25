Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PDgTbU234852 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:42:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C539C151E53B
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:59:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AlHFA4KiFUJ5D4c3 for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:59:13 -0700 (PDT)
Date: Mon, 25 Oct 2010 09:43:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
Message-ID: <20101025134345.GB3758@infradead.org>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
	<20101021125219.GA21472@infradead.org>
	<AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
	<AANLkTikYuWMdHRtAKLauZpyWiarioB2ezxW2qVb4s9Sv@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikYuWMdHRtAKLauZpyWiarioB2ezxW2qVb4s9Sv@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Oct 22, 2010 at 10:55:44AM +0530, Ajeet Yadav wrote:
> Hello,
> I wish to know, why the problem of bad clientid does not come, if we safely
> umount the USB storage device.

Because there the log is only recovered on an unclean umount.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
