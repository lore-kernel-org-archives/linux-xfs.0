Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43487 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdC0RKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 13:10:40 -0400
Date: Mon, 27 Mar 2017 10:10:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: verify inline directory data forks
Message-ID: <20170327171006.GF5738@birch.djwong.org>
References: <20170315072855.GA5280@birch.djwong.org>
 <20170316211255.GU17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170316211255.GU17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Fri, Mar 17, 2017 at 08:12:56AM +1100, Dave Chinner wrote:
> On Wed, Mar 15, 2017 at 12:28:55AM -0700, Darrick J. Wong wrote:
> > When we're reading or writing the data fork of an inline directory,
> > check the contents to make sure we're not overflowing buffers or eating
> > garbage data.  xfs/348 corrupts an inline symlink into an inline
> > directory, triggering a buffer overflow bug.
> 
> I think the check is fine, but from a structural point of view they
> are in the wrong place. i.e.  the functions xfs_iformat_local() and
> xfs_iflush_fork() should not be doing any content specific checks
> and verification. All they do is marshall the fork data to and from
> in-memory and on-disk formats - the contents of the forks should be
> opaque to them.
> 
> IOWs, incoming fork contents validity should be checked in
> xfs_iformat_fork() after we call xfs_iformat_local(), outgoing fork
> validity is checked in xfs_iflush_int() before calling
> xfs_iflush_fork().

Sorry for pushing the button prematurely.  I just sent out a patch to
clean this up and address a few other issues.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
