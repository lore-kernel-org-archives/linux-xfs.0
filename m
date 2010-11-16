Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGJJdJv105714 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 13:19:39 -0600
Subject: Re: [PATCH v3 7/9] xfsrestore: make node lookup more efficient
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101116150705.030079100@sgi.com>
References: <20101116150502.179825893@sgi.com>
	<20101116150705.030079100@sgi.com>
Date: Tue, 16 Nov 2010 13:20:07 -0600
Message-ID: <1289935207.1950.89.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, 2010-11-16 at 09:05 -0600, wkendall@sgi.com wrote:
> plain text document attachment (window_lookup_performance)
> When converting an nh_t to a segment index and relative node index,
> use shift and bitwise-and instead of division and modulo. Results show
> this is about 50% faster than the current method.

So the mapping interface now takes a segment index
rather than a node index, and you have node_map_*()
functions that operate on node handles.  I think
that's good.  That change seems to be bigger, but
it basically enabled you to make the switch to
masking only affect those new functions.

Anyway, looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
