Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 22:16:57 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBL6Goqw026163
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 22:16:53 -0800
Subject: Re: Review: Clear unwritten flag on during partial page truncation
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061220062813.GU44411608@melbourne.sgi.com>
References: <20061220062813.GU44411608@melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 21 Dec 2006 17:16:58 +1100
Message-Id: <1166681818.5572.190.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Wed, 2006-12-20 at 17:28 +1100, David Chinner wrote:
> Hence the solution is to clear the private buffer flags in
> xfs_vm_invalidatepage() so that when we extend the file the buffers
> on the page are all consistent.
> 
> Patch below. Comments?

Looks good Dave, nice sleuthing.

In hindsight, it'd have been really good to have gone for the real
BH_Unwritten flag upfront, and then being able to clear that inside
discard_buffer (like was done for BH_Delay)... if we did that, then
all this new code we're adding here (to just clear_buffer_unwritten,
ultimately) and also the complete hack in xfs_count_page_state could
be removed.  It still might be worth considering doing that, in case
there's other hard-to-hit-but-not-yet-uncovered bugs lurking along
the same lines.  But alot of effort, with the possibility of it not
being merged at all, as it touches code outside XFS.  D'oh.

FWIW, GFS seems to have managed to do even worse here, and looks like
they have dup'd big chunks of buffer.c ... has a discard_buffer() copy
and invalidate_page and probably others which are closely derived from
the equivalent buffer.c code ... guess those guys (hi Russell) could
do some code rationalisation in this area too before they get bitten.

cheers.

-- 
Nathan
