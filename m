Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S6xYan196390 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 01:59:34 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FIrJuBuwGBSKLAk7 for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 00:00:53 -0700 (PDT)
Date: Fri, 28 Sep 2012 17:00:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 4/8] xfs: export xfs_free_eofblocks() and return
	EAGAIN on trylock failure
Message-ID: <20120928070052.GG25626@dastard>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348767952-24229-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 01:45:48PM -0400, Brian Foster wrote:
> Turn xfs_free_eofblocks() into a non-static function, return EAGAIN to
> indicate trylock failure and make sure this error is not propagated in
> xfs_release().

You might want to change the title of the patch - "export" when
talking about functions in kernel code has specific meaning i.e.
EXPORT_SYMBOL() and that's different to making something
non-static...

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
