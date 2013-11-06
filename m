Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D53729E26
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 05:21:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 615C68F8084
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 03:21:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id rGiAbokRG79miGSl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 03:21:45 -0800 (PST)
Date: Wed, 6 Nov 2013 03:21:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ***** SUSPECTED SPAM ***** [RFD 11/17] xfs: factor xfs_create to
	prepare for O_TMPFILE
Message-ID: <20131106112145.GB24805@infradead.org>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
	<1376313607-28133-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1376313607-28133-12-git-send-email-david@fromorbit.com>
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
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, xfs@oss.sgi.com

On Mon, Aug 12, 2013 at 11:20:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> O_TMPFILE support requires allocating an inode that is not attached to the
> a current namespace - it's anonymous. The current inode allocation code runs
> through xfs_create() which requires a parent inode and a name to be passed to
> it. for O_TMPFILE, we do not have a parent inode or a name so we cannot use
> the same calling conventions as xfs_create() to allocate a inode.

Btw, O_TMPFILE does get a path passed, which the existing
implementations treat as an invisible parent.  I would suggest we follow
that path for our allocation decisions for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
