Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3273C29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 10:07:12 -0500 (CDT)
Message-ID: <518BBBA5.3060502@sgi.com>
Date: Thu, 09 May 2013 10:07:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/8] libxlog: fix log buffer alignment
References: <20130430121300.GB10481@dastard> <20130501001714.GH10481@dastard>
In-Reply-To: <20130501001714.GH10481@dastard>
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

On 04/30/13 19:17, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The libxlog sync changed the way log buffers used in recovery are
> aligned to sector sizes. The old code used to check for a zero log
> sector size and not do any alignment - this check was removed from
> the kernel code because there is always log sector size configured.
> It turns out that userspace *never* sets the log sector size, so
> userspace has always simply ignored the alignment in log replay
> (oops!).
>
> This problem manifested itself as detecting a freshly mkfs'd
> filesystem as having a totally zeroed log and hence xfs_check was
> emitting output and hence xfstests was refusing to run.
>
> This patch correctly configures the callers that use the log
> recovery code so that the log sector size is set appropriately and
> ensures that log recovery operates as expected.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
