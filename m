Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACJ8c09246236 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 13:08:38 -0600
Message-ID: <50A149AD.7000406@sgi.com>
Date: Mon, 12 Nov 2012 13:10:37 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: fix attr tree double split corruption
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
	<1352718586-3538-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1352718586-3538-2-git-send-email-david@fromorbit.com>
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

On 11/12/12 05:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> In certain circumstances, a double split of an attribute tree is
> needed to insert or replace an attribute. In rare situations, this
> can go wrong, leaving the attribute tree corrupted. In this case,
> the attr being replaced is the last attr in a leaf node, and the
> replacement is larger so doesn't fit in the same leaf node.


...

> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks great.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
