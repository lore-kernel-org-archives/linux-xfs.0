Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1564 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752558AbdCPVN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 17:13:26 -0400
Date: Fri, 17 Mar 2017 08:12:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify inline directory data forks
Message-ID: <20170316211255.GU17542@dastard>
References: <20170315072855.GA5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315072855.GA5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Wed, Mar 15, 2017 at 12:28:55AM -0700, Darrick J. Wong wrote:
> When we're reading or writing the data fork of an inline directory,
> check the contents to make sure we're not overflowing buffers or eating
> garbage data.  xfs/348 corrupts an inline symlink into an inline
> directory, triggering a buffer overflow bug.

I think the check is fine, but from a structural point of view they
are in the wrong place. i.e.  the functions xfs_iformat_local() and
xfs_iflush_fork() should not be doing any content specific checks
and verification. All they do is marshall the fork data to and from
in-memory and on-disk formats - the contents of the forks should be
opaque to them.

IOWs, incoming fork contents validity should be checked in
xfs_iformat_fork() after we call xfs_iformat_local(), outgoing fork
validity is checked in xfs_iflush_int() before calling
xfs_iflush_fork().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
