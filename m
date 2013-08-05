Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FA987CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 09:52:03 -0500 (CDT)
Date: Mon, 5 Aug 2013 09:52:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 32/48] xfs_db: convert directory parsing to use libxfs
	structure
Message-ID: <20130805145203.GH3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-33-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-33-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_db rolls it's own "opaque" directory types for the different
> block formats. All it cares about is where the headers end and the
> data starts, and none of the other details in the structures. Rather
> than duplicate this for the dir3 format, we already have perfectly
> good headers and abstraction functions for finding this information
> in libxfs.  Using these means that the dir2 code used for printing
> fields, metadump and check need to be modified to use libxfs
> definitions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
