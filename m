Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p121RQHU256984 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 19:27:27 -0600
Subject: Re: [PATCH 2/4] xfstests: add test to reproduce bmap btree corruption.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295927937-20634-3-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-3-git-send-email-david@fromorbit.com>
Date: Tue, 01 Feb 2011 19:29:54 -0600
Message-ID: <1296610194.2350.159.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The problem was reprted here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=626244
> 
> With the simple test case:
> 
> # mkfs.xfs -f -d agsize=16m,size=50g <dev>
> # mount <dev> /mnt
> # xfs_io -f -c 'resvsp 0 40G' /mnt/foo
> 
> Triggering the problem. Turn this into a new xfsqa test so that we
> exercise the problem code and prevent future regressions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good, HOWEVER, since the test crashes
the target system please remove it from (at least)
the "auto" group before you commit.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
