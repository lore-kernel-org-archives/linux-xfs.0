Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LI7YHj237314 for <xfs@oss.sgi.com>; Mon, 21 May 2012 13:07:34 -0500
Date: Mon, 21 May 2012 13:12:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 2/3] xfs: fix xfsaild hang due to premature idle
Message-ID: <20120521181232.GS16099@sgi.com>
References: <1337620886-41807-1-git-send-email-bfoster@redhat.com>
	<1337620886-41807-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337620886-41807-3-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hey Brian,

On Mon, May 21, 2012 at 01:21:25PM -0400, Brian Foster wrote:
> Running xfstests 273 in a loop reproduces an XFS lockup due to
> xfsaild entering idle mode indefinitely. The following
> high-level sequence of events leads to the hang:
> 
> - xfsaild is running, hits the stuck item threshold and reschedules,
>   setting xa_last_pushed_lsn appropriately.
> - xa_threshold is updated.
> - xfsaild restarts from the previous xa_last_pushed_lsn, hits the
>   new target and enters idle mode, even though the previously
>   stuck items still populate the ail.
> 
> Modify the tout logic to only enter idle mode when the ail is empty.
> IOW, if we hit the target but did not perform the current scan from
> the start of the ail, reschedule at least one more time.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Thanks for the patch.  Unfortunately it does not apply cleanly.  Care to spin it again?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
