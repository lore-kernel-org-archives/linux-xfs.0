Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETVl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 17:41:57 -0400
Date: Mon, 20 May 2019 14:41:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove unused flag arguments
Message-ID: <20190520214114.GN5352@magnolia>
References: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
 <20190520212139.GC5335@magnolia>
 <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 20, 2019 at 04:31:08PM -0500, Eric Sandeen wrote:
> On 5/20/19 4:21 PM, Darrick J. Wong wrote:
> > On Wed, May 15, 2019 at 01:37:32PM -0500, Eric Sandeen wrote:
> >> There are several functions which take a flag argument that is
> >> only ever passed as "0," so remove these arguments.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> (motivated by simplifying userspace libxfs, TBH)
> >>
> >>  libxfs/xfs_ag.c          |    8 ++++----
> >>  libxfs/xfs_alloc.c       |    4 ++--
> >>  libxfs/xfs_attr_remote.c |    2 +-
> >>  libxfs/xfs_bmap.c        |   14 +++++++-------
> >>  libxfs/xfs_btree.c       |   30 +++++++++++-------------------
> >>  libxfs/xfs_btree.h       |   10 +++-------
> >>  libxfs/xfs_sb.c          |    2 +-
> >>  scrub/repair.c           |    2 +-
> >>  xfs_bmap_util.c          |    6 +++---
> >>  xfs_buf.h                |    5 ++---
> > 
> > Do you have an accompanying xfsprogs patch up your sleeve somewhere too?
> > :)
> 
> yeah it's on the list, trying to decide if I want to wait and
> libxfs-merge this or just do it since IIRC it's kind of in the way
> of my other xfsprogs patches...

I'd prefer you wait so that we don't have xfsprogs out of sync with
kernel for a release.

--D

> -Eric
> 
