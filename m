Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 832167F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 12:35:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62318304039
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 10:35:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7cfdkCeVeIencI5m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 10:35:48 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9THZk3K029062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:35:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9TGcSTo015903
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 12:38:28 -0400
Date: Wed, 29 Oct 2014 12:38:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2] fix up indlen reservations on extent split
Message-ID: <20141029163826.GB14410@bfoster.bfoster>
References: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
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

On Tue, Oct 14, 2014 at 05:59:13PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's a couple patches to fix up the indirect block reservation
> problem when splitting delalloc extents, described in more detail in the
> patch 2 commit log.
> 
> This runs through xfstests without any explosions and quiets down
> generic/033 when used in combination with the zero range rework (current
> for-next includes the writeback on zero range workaround that also
> prevents generic/033 asserts).
> 
> Brian
> 
> v1:
> - xfs_bunmapi() code into independent patch.
> - Refactor fix into separate helper function.
> rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html
>  

ping?

> Brian Foster (2):
>   xfs: update icsb freeblocks counter after extent deletion
>   xfs: borrow indirect blocks from freed extent when available
> 
>  fs/xfs/libxfs/xfs_bmap.c | 159 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 116 insertions(+), 43 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
