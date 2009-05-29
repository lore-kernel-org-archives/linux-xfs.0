Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TKAGX9087794 for <xfs@oss.sgi.com>; Fri, 29 May 2009 15:10:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 928E91A46E04
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 13:10:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OBnYJcps8mJ4HMqz for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 13:10:31 -0700 (PDT)
Date: Fri, 29 May 2009 16:10:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/7] xfs: remove SYNC_BDFLUSH
Message-ID: <20090529201031.GA20031@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090528121947.GB30037@infradead.org>
	<921ca19c0905290619l46fa73abj380238058ce6efc6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <921ca19c0905290619l46fa73abj380238058ce6efc6@mail.gmail.com>
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
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 29, 2009 at 06:49:39PM +0530, Sujit Karataparambil wrote:
> Hi,
> Newbie question?
> Kindly tell me where this code is called from do you have pagedeamon
> on vfs or is it some thing else?

currently all calls with SYNC_BDFLUSH are from xfssyncd.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
