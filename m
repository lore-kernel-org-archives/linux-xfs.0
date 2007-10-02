Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:36:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l929aXwG029146
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:36:36 -0700
Date: Tue, 2 Oct 2007 19:36:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
Message-ID: <20071002093629.GG995458@sgi.com>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com> <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4701ED51.8050706@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Oct 02, 2007 at 05:03:45PM +1000, Lachlan McIlroy wrote:
> Yeah that about sums it up.  In an attempt to prevent log replay of inodes
> in cases when we shouldn't replay we also prevented log replay of inodes in
> cases when we should replay.  We end up with directories that refer to 
> inodes
> that were not replayed and we read existing data off disk.  That existing
> data is usually previous instances of inodes.  We had cases of regular files
> turning into directories and inode version mismatches.

The issue that started tripping this was stale inodes from a
previous filesystem being detected as valid clusters of inodes.
Hence inodes magically changed from what they were supposed to
be and that caused all sorts of problems.

FWIW, in a past life XFS was supposed to store the uuid of the
filesystem in it's inodes to prevent exactly this sort of confusion,
but that was considered expendable and disappeared in version 2
inodes when XFS grew 32bit link counts and project ID's. The padding
is still there waiting to be used.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
