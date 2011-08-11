Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BM4vFL008083 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 17:04:57 -0500
Subject: Re: [PATCH 2/2] xfs: replace xfs_buf_geterror() with bp->b_error
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110803021834.29700.40199.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110803021834.29700.40199.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Thu, 11 Aug 2011 17:04:42 -0500
Message-ID: <1313100282.2899.99.camel@doink>
MIME-Version: 1.0
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-08-02 at 19:18 -0700, Chandra Seetharaman wrote:
> Since we just checked bp for NULL, it is ok to replace xfs_buf_geterror()
> with bp->b_error in these places.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
