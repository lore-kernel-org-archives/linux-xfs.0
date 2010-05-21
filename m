Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LKxn2j030572 for <xfs@oss.sgi.com>; Fri, 21 May 2010 15:59:49 -0500
Subject: Re: [PATCH 08/12] xfs: Delayed logging design documentation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1274138668-1662-9-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-9-git-send-email-david@fromorbit.com>
Date: Fri, 21 May 2010 16:02:05 -0500
Message-ID: <1274475725.2255.38.camel@doink>
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

On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Document the design of the delayed logging implementation. This
> includes assumptions made, dead ends followed, the reasoning behind
> the structuring of the code, the layout of various structures, how
> things fit together, traps and pit-falls avoided, etc. This is all
> too much to document in the code itself, so do it in a separate
> file.

I found some typo's and other things, but will hold off
suggesting (or posting fixes for) them until after we've
got the baseline document checked in.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  .../filesystems/xfs-delayed-logging-design.txt     |  819 ++++++++++++++++++++
>  1 files changed, 819 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
