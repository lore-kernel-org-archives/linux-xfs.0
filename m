Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DD817F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:37:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67C96304067
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:37:06 -0700 (PDT)
Date: Thu, 24 Jul 2014 13:37:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/18] xfs: define sparse inode chunks v5 sb feature bit
	and helper function
Message-ID: <20140724173701.GD37832@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-4-git-send-email-bfoster@redhat.com>
	<53D13D94.9030607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D13D94.9030607@sgi.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 24, 2014 at 12:08:36PM -0500, Mark Tinguely wrote:
> On 07/24/14 09:22, Brian Foster wrote:
> >The sparse inode chunks feature will use the helper function to enable
> >the allocation of sparse inode chunks. The incompatible feature bit is
> >set on disk once a sparse inode chunk is allocated to prevent older
> >drivers from mounting an fs with sparse chunks.
> >
> >Note that the feature is hardcoded disabled and the feature bit not
> >included in the all features mask until fully implemented.
> >
> >Signed-off-by: Brian Foster<bfoster@redhat.com>
> >---
> 
> Sorry if I missed it in the series but is there an
> XFS_FSOP_GEOM_FLAGS_SPINODES for xfs_info/growfs?
> 

Nope, looks like I missed it. It probably slipped my mind as I haven't
got into userspace yet and thus hadn't thought about xfs_info. I'll make
a note to add it, thanks!

Brian

> Thanks,
> 
> --Mark.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
