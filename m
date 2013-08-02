Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9F547F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:13:08 -0500 (CDT)
Message-ID: <51FC20E0.8010105@sgi.com>
Date: Fri, 02 Aug 2013 16:13:04 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 13/49] libxfs: fix compile warnings
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-14-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Some of the code shared with userspace causes compilation warnings
> from things turned off in the kernel code, such as differences in
> variable signedness. Fix those issues.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

convert a couple ASSERT converted to warn/exits, variable sign 
correction, non-DEBUG unused variable, default string value.
    ---
Don't see the significance of the initialization of variables in 
xfs_da3_split() and xfs_rtfree_range().

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
