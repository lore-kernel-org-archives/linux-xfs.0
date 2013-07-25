Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B57A77F54
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 16:08:53 -0500 (CDT)
Date: Thu, 25 Jul 2013 16:08:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/48] xfs: buffer type overruns blf_flags field
Message-ID: <20130725210850.GG3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-20-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:42AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer type passed to log recvoery in the buffer log item
> overruns the blf_flags field. I had assumed that flags field was a
> 32 bit value, and it turns out it is a unisgned short. Therefore
> having 19 flags doesn't really work.
> 
> Convert the buffer type field to numeric value, and use the top 5
> bits of the flags field for it. We currently have 17 types of
> buffers, so using 5 bits gives us plenty of room for expansion in
> future....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This corresponds to commit 61fe135c1dde1.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
