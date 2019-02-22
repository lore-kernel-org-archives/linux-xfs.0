Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43335 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfBVTAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 14:00:52 -0500
Received: by mail-pf1-f193.google.com with SMTP id q17so1495759pfh.10
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 11:00:51 -0800 (PST)
Date: Fri, 22 Feb 2019 11:00:48 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190222190048.GA29624@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard>
 <20190215065947.GG9819@vader>
 <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
 <20190218221820.GF14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218221820.GF14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Steve French <sfrench@samba.org>

On Tue, Feb 19, 2019 at 09:18:20AM +1100, Dave Chinner wrote:
> On Sat, Feb 16, 2019 at 06:57:45PM -0700, Andreas Dilger wrote:
> > While it may be a bit of a stretch to call this "forensic evidence", making
> 
> We do forensic analysis of corrupt filesystems looking for evidence
> of what went wrong, not just looking for evidence of what happened
> on systems that have been broken into.
> 
> > it hard to change from except via total root compromise by a skilled hacker
> > is very useful.
> 
> *nod*.
> 
> > If this were to go in (which I'm not in favour of), then there would need to
> > be a CONFIG and/or runtime knob to turn it off (or better to only turn it on),
> > similar to how FIPS and other security options can only go in one direction.
> 
> The problem here is that "inode birth time" is being conflated with
> "user document creation time". These two things are very different.
> 
> i.e. One is filesystem internal information and is not related to
> when the original copy of the data in the file was created, the
> other is user specified metadata that is related to the file data
> contents and needs to travel with the data, not the filesystem.
> 
> IMO, trying to make one on-disk field hold two different types of
> information defeats one or the other purpose, and nobody knows which
> one the field stores for any given file.
> 
> I'd suggest that "authored date" should be a generic system xattr so
> most filesystems support it, not just those that have a birth time
> field on disk. Sure, modify it through utimesat() and expose it
> through statx() (as authored time, not birth time), but store it a
> system xattr rather than an internal filesystem metadata field that
> requires was never intended to be user modifiable.

It seems that this is the general consensus, so I'll look into
implementing this functionality as an xattr.
