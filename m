Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 686E47CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 15:48:28 -0500 (CDT)
Date: Mon, 5 Aug 2013 15:48:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 41/48] xfs_mdrestore: recalculate sb CRC before writing
Message-ID: <20130805204828.GQ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-42-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-42-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:04AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_mdrestore writes the superblock after modifying it, and so the
> CRC is not necessarily correct. make sure the CRC is correct
> before we write the superblock back.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
