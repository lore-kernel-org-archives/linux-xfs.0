Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADLGsUJ152154 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 15:16:54 -0600
Message-ID: <50A2B93D.6090901@sgi.com>
Date: Tue, 13 Nov 2012 15:18:53 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/32] xfs: make growfs initialise the AGFL header
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-9-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/12/2012 05:54 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> For verification purposes, AGFLs need to be initialised to a known
> set of values. For upcoming CRC changes, they are also headers that
> need to be initialised. Currently, growfs does neither for the AGFLs
> - it ignores them completely. Add initialisation of the AGFL to be
> full of invalid block numbers (NULLAGBLOCK) to put the
> infrastructure in place needed for CRC support.
>
> Includes a comment clarification from Jeff Liu.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   fs/xfs/xfs_fsops.c |   23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
>
Looks good.

Reviewed-by Rich Johnston <rjohnston@sgi.com>

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
