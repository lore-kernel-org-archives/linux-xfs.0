Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C02517F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 08:55:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE67C304059
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 06:55:04 -0700 (PDT)
Date: Wed, 11 Sep 2013 06:55:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: change the immutable in xfs_open_by_handle
Message-ID: <20130911135502.GA21898@infradead.org>
References: <20130910184724.726933044@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130910184724.726933044@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Greg Banks <gbanks@sgi.com>, xfs@oss.sgi.com

On Tue, Sep 10, 2013 at 01:47:20PM -0500, Mark Tinguely wrote:
> This patch allows clients like DMF to modify an immutable file
> without changing the immutable capability on the file, which
> would expose the file to change.
> 
> This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
> so no addition security risk has been introduced.

The immutable flag means that the file can't be modified, and
CAP_LINUX_IMMUTABLE allows setting/removing that restriction, but not
ignoring it.

So: NAK, this is a change in semantics and long-standing behaviour.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
