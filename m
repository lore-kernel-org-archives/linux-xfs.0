Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3E577CAF
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 12:29:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56DEE8F8040
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 10:29:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VqWtsC5Av1SNBCzo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2016 10:29:27 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A455CC04B303
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 17:29:26 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-121.bos.redhat.com [10.18.41.121])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6EHTQXb014692
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 13:29:26 -0400
Date: Thu, 14 Jul 2016 13:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/3] serialize unmount against new buffer I/O
Message-ID: <20160714172924.GA25392@bfoster.bfoster>
References: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On Wed, Jul 13, 2016 at 12:16:32PM -0400, Brian Foster wrote:
> This is a rework of the directory readahead panic fix based on a buffer
> I/O count mechanism. See [1] for the original patch and subsequent
> discussion leading to the solution as constituted.
> 
> This is split into multiple patches simply to break out some refactoring
> and special buffer exclusion from the accounting mechanism. This
> prevents the original problem (xfs/311) as well as passes an initial
> xfstests run.
> 

FYI, I've hit an unmount hang with this while running generic/270. It
takes a few iterations to hit. I'm not sure if it's a race issue or more
of an explicit accounting issue, but I'll hold off on v2 until I can
track it down...

Brian

> Brian
> 
> [1] http://oss.sgi.com/pipermail/xfs/2016-June/049946.html
> 
> Brian Foster (3):
>   xfs: helper to set flags on uncached buffer reads
>   xfs: exclude never-released buffers from buftarg I/O accounting
>   xfs: track and serialize in-flight async buffers against unmount
> 
>  fs/xfs/xfs_buf.c   | 177 ++++++++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_buf.h   |   8 +++
>  fs/xfs/xfs_log.c   |   4 +-
>  fs/xfs/xfs_mount.c |  12 ++--
>  4 files changed, 151 insertions(+), 50 deletions(-)
> 
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
