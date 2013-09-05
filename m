Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0148E7F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 13:50:57 -0500 (CDT)
Message-ID: <5228D28C.2060205@sgi.com>
Date: Thu, 05 Sep 2013 13:50:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 13/55] libxfs: fix compile warnings
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-14-git-send-email-david@fromorbit.com>
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
> Some of the code shared with userspace causes compilation warnings
> from things turned off in the kernel code, such as differences in
> variable signedness. Fix those issues.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
no change in the reposting of the patch

convert a couple ASSERT to warn/exits, variable sign correction, 
non-DEBUG unused variable, default string value.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
