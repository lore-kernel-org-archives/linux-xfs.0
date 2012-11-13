Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADLIOOo152410 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 15:18:24 -0600
Date: Tue, 13 Nov 2012 15:20:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/3] xfs: fixes for 3.7-rc6
Message-ID: <20121113212027.GB19387@sgi.com>
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352718586-3538-1-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Mon, Nov 12, 2012 at 10:09:43PM +1100, Dave Chinner wrote:
> These are the remaining fixes I have in my tree for the 3.7 cycle.
> One is a corruption fix, the other two are problems I'm seeing
> during shutdown and recovery testing. That testing lasts 400-500
> cycles (3-4 hours) now before it fails with another, as yet unknown
> buffer/perag reference assert failure. Without these fixes, it lasts
> 3-4 cycles before assert failing or triggering a BUG.
> 
> I'd like these fixes to be in the 3.7 cycle if at all possible, with
> both patch 1 and 2 being stable kernel candidates.

committed to git://oss.sgi.com/xfs/xfs.git, master and for-next branches.

I'll send a pull request tomorrow.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
