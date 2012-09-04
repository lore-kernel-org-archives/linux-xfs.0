Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84Kwdhd160921 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 15:58:39 -0500
Message-ID: <50466BB8.8050101@sgi.com>
Date: Tue, 04 Sep 2012 15:59:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/13] xfs: xfs_sync_fsdata is redundant
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-9-git-send-email-david@fromorbit.com>
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

On 08/30/12 07:00, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Why do we need to write the superblock to disk once we've written
> all the data?  We don't actually - the reasons for doing this are
> lost in the mists of time, and go back to the way Irix used to drive
> VFS flushing.
>
> On linux, this code is only called from two contexts: remount and
> .sync_fs. In the remount case, the call is followed by a metadata
> sync, which unpins and writes the superblock.  In the sync_fs case,
> we only need to force the log to disk to ensure that the superblock
> is correctly on disk, so we don't actually need to write it. Hence
> the functionality is either redundant or superfluous and thus can be
> removed.
>
> Seeing as xfs_quiesce_data is essentially now just a log force,
> remove it as well and fold the code back into the two callers.
> Neither of them need the log covering check, either, as that is
> redundant for the remount case, and unnecessary for the .sync_fs
> case.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
