Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o547roZV209905 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 02:53:51 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4ECF130E447
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 00:58:52 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id MRAsm72xeTNg6UZs for <xfs@oss.sgi.com>;
	Fri, 04 Jun 2010 00:58:52 -0700 (PDT)
Date: Fri, 4 Jun 2010 17:56:14 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100604075614.GB26335@laptop>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
	<1275609328-12514-7-git-send-email-david@fromorbit.com>
	<20100604075223.GB7317@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100604075223.GB7317@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 04, 2010 at 03:52:23AM -0400, Christoph Hellwig wrote:
> Even if there still are potential livelocks after this it's a big
> step in the right direction, so
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Agreed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
