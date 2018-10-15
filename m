Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16730 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbeJOIOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 04:14:34 -0400
Date: Mon, 15 Oct 2018 11:31:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
Message-ID: <20181015003139.GZ6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923117420.5546.13317703807467393934.stgit@magnolia>
 <CAL3q7H7mLvCGpyitJhQ=To-aDvG9k9rxSVi2jSpcALQVj3myzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7mLvCGpyitJhQ=To-aDvG9k9rxSVi2jSpcALQVj3myzg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filipe Manana <fdmanana@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Fri, Oct 12, 2018 at 09:22:18PM +0100, Filipe Manana wrote:
> On Thu, Oct 11, 2018 at 5:13 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > A deduplication data corruption is exposed by fstests generic/505 on
> > XFS.
> 
> (and btrfs)
> 
> Btw, the generic test I wrote was indeed numbered 505, however it was
> never committed and there's now a generic/505 which has nothing to do
> with deduplication.
> So you should update the changelog to avoid confusion.

What test is it now? And if it hasn't been committed, are you going
to update it and repost as it clearly had value....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
