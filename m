Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F1407F6A
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C727AC004
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:45:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tv1pHKaMRbxxgviB for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:45:37 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:45:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/32] xfs: check magic numbers in dir3 leaf verifier first
Message-ID: <20131009204527.GJ4446@dastard>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-5-git-send-email-david@fromorbit.com>
	<52548F4F.5000800@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52548F4F.5000800@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 06:03:43PM -0500, Eric Sandeen wrote:
> On 9/29/13 10:15 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
> > validating the magic numbers in the buffer results in ASSERT
> > failures due to mismatching magic numbers when a corruption occurs.
> > Seeing as the verifier is supposed to catch the corruption and pass
> > it back to the caller, having the verifier assert fail on error
> > defeats the purpose of detecting the errors in the first place.
> > 
> > Check the magic numbers direct from the buffer before decoding the
> > header.
> 
> Looks good; have you sent this for the kernel yet?
> 
> (I thought we wanted changes to hit kernelspace first) :)

Yes, commit 0f295a214bb7658ca37bd61a8a1f0cd4a9d86c1f.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
