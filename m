Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBfKxS206239 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:41:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E7CC9176B
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:41:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Z5lyyTIRD9W5kS6V for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:41:19 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:41:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12 v3] xfs: Remove the macro XFS_BUF_SET_TARGET
Message-ID: <20110724114119.GF26332@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722234033.14612.80261.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722234033.14612.80261.sendpatchset@chandra-lucid.beaverton.ibm.com>
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

On Fri, Jul 22, 2011 at 04:40:33PM -0700, Chandra Seetharaman wrote:
> Remove the macro XFS_BUF_SET_TARGET.
> 
> hch: As all the buffer allocator already set ->b_target it should be safe
> to simply remove these calls.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
