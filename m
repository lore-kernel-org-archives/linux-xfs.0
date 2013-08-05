Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2BD77CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 13:32:17 -0500 (CDT)
Date: Mon, 5 Aug 2013 13:32:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 35/48] xfs_repair: convert directory parsing to use
	libxfs structure
Message-ID: <20130805183217.GK3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-36-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-36-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:58AM +1000, Dave Chinner wrote:
> It turns out that xfs_repair copies xfs_db in rollin git's own
						rolling it's

> opaque directory types for the different block formats. It has a
> little comment about how they are "shared" with xfs_db. Shared by
> copy and pasting, rather than a common header, it would appear.
> 
> Anyway, same problems, need to use format aware definitionsi and
						  definitions

> abstractions from libxfs so that everything is parsed properly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
