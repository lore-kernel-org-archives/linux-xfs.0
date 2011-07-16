Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G26Ol2230456 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:06:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 143C575C44
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:06:23 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OwDDyfXnnrOEzgSA for <xfs@oss.sgi.com>;
	Fri, 15 Jul 2011 19:06:23 -0700 (PDT)
Date: Fri, 15 Jul 2011 22:06:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] xfs: Remove the macro XFS_BUF_SET_TARGET
Message-ID: <20110716020623.GB10258@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012204.6629.86975.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716012204.6629.86975.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

As all the buffer allocator already set ->b_target it should be safe
to simply remove these calls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
