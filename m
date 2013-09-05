Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92C597F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 13:55:12 -0500 (CDT)
Message-ID: <5228D38F.3030505@sgi.com>
Date: Thu, 05 Sep 2013 13:55:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 14/55] xfs: remove local fork format handling from
	xfs_bmapi_write()
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-15-git-send-email-david@fromorbit.com>
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
> The conversion from local format to extent format requires
> interpretation of the data in the fork being converted, so it cannot
> be done in a generic way. It is up to the caller to convert the fork
> format to extent format before calling into xfs_bmapi_write() so
> format conversion can be done correctly.
>
> The code in xfs_bmapi_write() to convert the format is used
> implicitly by the attribute and directory code, but they
> specifically zero the fork size so that the conversion does not do
> any allocation or manipulation. Move this conversion into the
> shortform to leaf functions for the dir/attr code so the conversions
> are explicitly controlled by all callers.
>
> Now we can remove the conversion code in xfs_bmapi_write.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This reposted patch has not changed.

same as kernel commit f3508bcd.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
