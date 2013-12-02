Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 095EA7F57
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 04:40:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFDE88F8064
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 02:40:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GrzUaHAmscALGivT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 02:40:19 -0800 (PST)
Date: Mon, 2 Dec 2013 02:40:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/15] xfsprogs: use common code for multi-disk detection
Message-ID: <20131202104016.GA21394@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-2-git-send-email-david@fromorbit.com>
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

On Fri, Nov 29, 2013 at 12:43:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Both xfs_repair and mkfs.xfs need to agree on what is a "multidisk:
> configuration - mkfs for determining the AG count of the filesystem,
> repair for determining how to automatically parallelise it's
> execution. This requires a bunch of common defines that both mkfs
> and reapir need to share.
> 
> In fact, most of the defines in xfs_mkfs.h could be shared with
> other programs (i.e. all the defaults mkfs uses) and so it is
> simplest to move xfs_mkfs.h to the shared include directory and add
> the new defines to it directly.

I have to say I do not like making the mkfs header public at all.
There's things like local prototypes in there that shouldn't be in
include/, and the name is wrong, too.  include/xfs_geom.h maybe?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
