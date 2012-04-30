Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UNKJ9W048150 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 18:20:19 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eHRFEBvoaRzuzzXs for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 16:20:18 -0700 (PDT)
Date: Tue, 1 May 2012 09:20:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120430232007.GO7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120430143434.GM16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430143434.GM16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 09:34:34AM -0500, Ben Myers wrote:
> While testing this patchset without Jan's freeze work, I hit this assert.
> 
> This one rings bells for me, but I can't find where it's been reported.
> 
> -Ben
> 
> 
> [56571.411824] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [56571.412798] IP: [<ffffffffa00bf477>] xfs_log_space_wake+0x17/0x140 [xfs]

Which is failing on this:

(gdb) l *(xfs_log_space_wake+0x17)
0xffffffff81482cb7 is in xfs_log_space_wake (fs/xfs/xfs_log.c:844).
839             struct xfs_mount        *mp)
840     {
841             struct log              *log = mp->m_log;
842             int                     free_bytes;
843
844 >>>>>>>     if (XLOG_FORCED_SHUTDOWN(log))
845                     return;

On this offset:

$ pahole fs/xfs/xfs_log.o |grep -A 6 "^struct log"
struct log {
        struct xfs_mount *         l_mp;                 /*     0     8 */
        struct xfs_ail *           l_ailp;               /*     8     8 */
        struct xfs_cil *           l_cilp;               /*    16     8 */
        struct xfs_buf *           l_xbuf;               /*    24     8 */
        struct xfs_buftarg *       l_targ;               /*    32     8 */
        uint                       l_flags;              /*    40     4 */
                                                         ^^^^^^^^^^^^^^^^^

So the log pointer passed is NULL. That's the first definite sign
that the problems you are seeing are all a result of log buffer IO
completing after the log has been torn down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
