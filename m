Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 396707F55
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:18:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6327AC003
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 01:18:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iACnK8MKkguene7B (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 01:18:43 -0700 (PDT)
Date: Mon, 2 Sep 2013 01:18:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix endian warning in xlog_recover_get_buf_lsn()
Message-ID: <20130902081843.GC11210@infradead.org>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
	<1378092179-24973-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378092179-24973-2-git-send-email-david@fromorbit.com>
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

On Mon, Sep 02, 2013 at 01:22:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> sparse reports:
> 
> fs/xfs/xfs_log_recover.c:2017:24: sparse: cast to restricted __be64
> 
> Because I used the wrong structure for the on-disk superblock cast
> in 50d5c8d ("xfs: check LSN ordering for v5 superblocks during
> recovery"). Fix it.
> 
> Reported-by: kbuild test robot
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
