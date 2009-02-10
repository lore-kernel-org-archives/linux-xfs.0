Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AADdhZ044043 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 04:13:40 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BE9B190EC92
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:13:02 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	b4tUNOygQC1bs79O for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 02:13:02 -0800 (PST)
Date: Tue, 10 Feb 2009 21:12:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Check if AIL has been started before stopping it
Message-ID: <20090210101259.GO8830@disturbed>
References: <4990D7EA.7020902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4990D7EA.7020902@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 10, 2009 at 12:27:06PM +1100, Lachlan McIlroy wrote:
> A failure during mount can result in shutting down the AIL when
> it may not have been started up yet.

The ail init/destroy are supposed to be called symmetrically. if the
destroy is being called when the init has not been run or completed,
then the bug is at the caller.

Reading between the lines of your brief description of the problem,
xfs_trans_ail_init() has failed with ENOMEM, and that has called
xfs_trans_ail_destroy() erroneously. The correct fix is to call
xlog_dealloc_log() when xfs_trans_ail_init() fails, not
xfs_log_unmount_dealloc() which calls xfs_trans_ail_destroy() before
calling xlog_dealloc_log().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
