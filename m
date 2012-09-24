Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OLo2Uq216516 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 16:50:02 -0500
Message-ID: <5060D5D5.80602@sgi.com>
Date: Mon, 24 Sep 2012 16:51:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs_io: new functions
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1343255450-28559-1-git-send-email-david@fromorbit.com>
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

On 07/25/12 17:30, Dave Chinner wrote:
> This is just a couple of additional functions for xfs_io I have had
> sitting around for a while. The first is an interface to
> sync_file_range() for better control of file writeback.  The second
> and third introduce vectored pread/pwrite so that I could simulate
> the same style of vectored IO that KVM does via direct IO (hint -
> tracing indicated that the generic direct IO code doesn't handle
> this particularly efficiently).
>
> _____________________________________________

This series has been committed to
    git://oss.sgi.com/xfs/cmds/xfsprogs.git

-Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
