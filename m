Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3550F7F6C
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 17:53:07 -0500 (CDT)
Date: Mon, 30 Sep 2013 17:53:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix memory leak in xlog_recover_add_to_trans
Message-ID: <20130930225306.GS1935@sgi.com>
References: <20130927140104.515578025@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130927140104.515578025@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Sep 27, 2013 at 09:00:55AM -0500, tinguely@sgi.com wrote:
> Free the memory in error path of xlog_recover_add_to_trans().
> Normally this memory is freed in recovery pass2, but is leaked
> in the error path.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
