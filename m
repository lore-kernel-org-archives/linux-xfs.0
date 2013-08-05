Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A20C7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:40:41 -0500 (CDT)
Date: Mon, 5 Aug 2013 16:40:41 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 47/48] xfs_repair: support CRC enabled remote symlinks
Message-ID: <20130805214041.GW3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-48-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-48-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:10AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add support for verifying the contents of remote symlinks with CRCs.
> Factor the remote symlink checking code out of the symlink function
> so that it is clear what it is checking. This also reduces the
> indentation and makes the code clearer.
> 
> Then add support for the CRC format by modelling the checking
> function directly on the code that is used in the kernel for reading
> and checking both remote symlink formats.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This goes with commit 321a95839e65.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
