Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 723087F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:49:22 -0500 (CDT)
Date: Tue, 25 Jun 2013 14:49:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/6] xfstests: generic/193 runs tests in wrong location
Message-ID: <20130625194920.GC20932@sgi.com>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
	<1370610398-14630-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370610398-14630-2-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 11:06:33PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/193 runs the test in $here - the root of the xfstests source
> tree/installation. IOWs, it doesn't test the filesystem on either
> the TEST_DIR or SCRATCH_MNT, and so it not testing the filesystem
> we think it is testing. Bad. Fixing this is the majority of the
> change - introducing $test_root and $test_user for the files with
> different owners, and then redirecting error output and filtering
> the output appropriately.
> 
> And then add checks that truncate clears the suid/sgid bits
> appropriately, somethign that has never been tested on XFS (and
> likely other filesystems) so will cause kernels between 3.1 and 3.9
> to assert fail as Dave Jones has recently reported.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  The behavior you outlined regarding suid/sgid bits matches that of
should_remove_suid().

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
