Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q41FDdh9153557 for <xfs@oss.sgi.com>; Tue, 1 May 2012 10:13:39 -0500
Message-ID: <4F9FFD9F.60203@sgi.com>
Date: Tue, 01 May 2012 10:13:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] xfs: convert internal buffer functions to pass maps
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-4-git-send-email-david@fromorbit.com>
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

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> While the external interface currently uses separate blockno/length
> variables, we need to move internal interfaces to passing and
> parsing vector maps. This will then allow us to add external
> interfaces to support discontiguous buffer maps as the internal code
> will already support them.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
