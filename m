Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C8D17F73
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:51:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A471304084
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:51:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id KGlriEPoJSKYDWn0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 10:51:18 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:51:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140416175117.GA23643@infradead.org>
References: <534EC073.8090006@sandeen.net>
 <534EC282.7010905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534EC282.7010905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 12:48:50PM -0500, Eric Sandeen wrote:
> XFS_ERROR was designed long ago to trap return values,
> but it's not runtime configurable, it's not consistently used,
> and we can do the same thing today with systemtap, using
> something like:
> 
> probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }

Gives me a version just using ftrace, or at least a kprobes based module
that we can merged in the kernel tree and this would be fine for me.

Requiring a massive blob of questionable out of tree module code and a
compiler is an absolute no-go.

NAK for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
