Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DI1JdO080489 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 13:01:19 -0500
Message-ID: <4F8869EC.9060107@sgi.com>
Date: Fri, 13 Apr 2012 13:01:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/18] xfs: Ensure inode reclaim can run during quotacheck
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-2-git-send-email-david@fromorbit.com>
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

On 04/13/12 07:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Because the mount process can run a quotacheck and consume lots of
> inodes, we need to be able to run periodic inode reclaim during the
> mount process. This will prevent running the system out of memory
> during quota checks.
>
> This essentially reverts 2bcf6e97, but that is safe to do now that
> the quota sync code that was causing problems during long quotacheck
> executions is now gone.
>
> The reclaim work is currently protected from running during the
> unmount process by a check against MS_ACTIVE. Unfortunately, this
> also means that the reclaim work cannot run during mount.  The
> unmount process should stop the reclaim cleanly before freeing
> anything that the reclaim work depends on, so there is no need to
> have this guard in place.
>
> Also, the inode reclaim work is demand driven, so there is no need
> to start it immediately during mount. It will be started the moment
> an inode is queued for reclaim, so qutoacheck will trigger it just
> fine.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
