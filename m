Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46906 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdANHzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jan 2017 02:55:00 -0500
Date: Fri, 13 Jan 2017 23:54:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [LSF/MM TOPIC] online filesystem repair
Message-ID: <20170114075452.GJ14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi,

I've been working on implementing online metadata scrubbing and repair
in XFS.  Most of the code is self contained inside XFS, but there's a
small amount of interaction with the VFS freezer code that has to happen
in order to shut down the filesystem to rebuild the extent backref
records.  It might be interesting to discuss the (fairly slight)
requirements upon the VFS to support repairs, and/or have a BoF to
discuss how to build an online checker if any of the other filesystems
are interested in this.

Concurrent with development of online scrubbing, I've also been working
on a fuzz test suite for xfstests that fuzzes every field of every
metadata object on the filesystem and then tries to crash the kernel,
the offline repair tool (xfs_repair), or the online repair tool
(xfs_scrub).  I could talk about that as kind of a follow up to last
year's AFL presentation, and what kinds of bugs it's uncovered.

--D
