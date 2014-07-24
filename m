Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E1597F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:08:41 -0500 (CDT)
Message-ID: <53D13D94.9030607@sgi.com>
Date: Thu, 24 Jul 2014 12:08:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/18] xfs: define sparse inode chunks v5 sb feature bit
	and helper function
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-4-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 07/24/14 09:22, Brian Foster wrote:
> The sparse inode chunks feature will use the helper function to enable
> the allocation of sparse inode chunks. The incompatible feature bit is
> set on disk once a sparse inode chunk is allocated to prevent older
> drivers from mounting an fs with sparse chunks.
>
> Note that the feature is hardcoded disabled and the feature bit not
> included in the all features mask until fully implemented.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

Sorry if I missed it in the series but is there an 
XFS_FSOP_GEOM_FLAGS_SPINODES for xfs_info/growfs?

Thanks,

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
