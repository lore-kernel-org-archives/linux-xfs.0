Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5ED77F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:53:26 -0500 (CDT)
Message-ID: <522A24A5.8050308@sgi.com>
Date: Fri, 06 Sep 2013 13:53:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 51/55] xfs: fix calculation of the number of node entries
	in a dir3 node
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-52-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-52-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The calculation doesn't take into account the size of the dir v3
> header, so overestimates the hash entries in a node. This causes
> directory buffer overruns when splitting and merging nodes.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good, same as kernel commit 37804376.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
