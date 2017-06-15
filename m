Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33523 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOUh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 16:37:29 -0400
Date: Thu, 15 Jun 2017 13:37:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v9 0/3] xfsprogs 4.12: GETFSMAP support
Message-ID: <20170615203722.GA4530@birch.djwong.org>
References: <149755888982.3424.6925834871301440055.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149755888982.3424.6925834871301440055.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Sorry, I mistyped the ending patch name in stg mail, so please ignore
this series.  The 12-patch series is the correct one.

--D

On Thu, Jun 15, 2017 at 01:34:49PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patchset implements the userspace components of the new GETFSMAP
> ioctl that is now in upstream for 4.12.  This release contains various
> cleanups that came up in the discussion of the v8 patchset; it should
> apply directly to for-next.
> 
> The first two patches refactor string-to-number conversion routines.
> 
> The third patch chooses a faster crc32c algorithm, which provides
> a small (~5%) decrease in xfs_repair runtime for metadata-heavy fses.
> 
> The fourth patch adds some autoconf magic so that client programs can
> detect a platform supporting FSMAP (currently Linux) and stuff in our
> own header if the system headers do not provide it.
> 
> The fifth patch introduce a 'fsmap' command to xfs_io so that users can
> query the raw reverse mapping data that is exported by fsmap.  If the
> experimental rmapbt feature is enabled, the returned results will be
> straight out of the rmapbt; otherwise, the extent information is
> synthesized out of the free space btres.
> 
> The sixth patch delegates xfs_repair's rmap comparison function to the
> new libxfs version that was introduced as a part of the getfsmap kernel
> patches.
> 
> The remainder of the patch set introduces xfs_spaceman, which is a new
> tool to manage disk space on a mounted XFS filesystem.  The new tool can
> call FITRIM, manage space reservations, and display summary information
> about the free space on the filesystem.  This information is probably
> most useful for developers and people surveying free space
> fragmentation.
> 
> Note: The primary user of the GETFSMAP information will be the media
> scan phase of the upcoming xfs_scrub tool, which will be posted later.
> 
> Questions?  Comments?
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
