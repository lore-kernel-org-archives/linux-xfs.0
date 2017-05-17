Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754387AbdEQO5t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 10:57:49 -0400
Date: Wed, 17 May 2017 16:57:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3 v2] xfs: Fix SEEK_HOLE implementation
Message-ID: <20170517145746.GC5632@quack2.suse.cz>
References: <20170517121046.2632-1-jack@suse.cz>
 <20170517123115.GG7250@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170517123115.GG7250@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed 17-05-17 20:31:15, Eryu Guan wrote:
> Hi Jan,
> 
> On Wed, May 17, 2017 at 02:10:43PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > this is the second revision of the patches to fix bugs in XFS's SEEK_HOLE
> > implementation and cleanup the code a bit.
> > 
> > Changes since v1:
> > * Fixed some more buggy cases
> > * Simplified code a bit as suggested by Darrick
> > * Fixed range check as spotted by Brian
> 
> I applied this patchset on top of 4.12-rc1 kernel to test your v4 test
> case, your new test passed all my tests, but I found generic/285
> regressed with sub-page block size XFS, 285.full showed that failure was
> from subtest 7
> 
> 07. Test file with unwritten extents, only have dirty pages
> 07.01 SEEK_HOLE expected 0 or 11264, got 0.                       succ
> 07.02 SEEK_HOLE expected 1 or 11264, got 1.                       succ
> 07.03 SEEK_DATA expected 10240 or 10240, got -1.                  FAIL
> 07.04 SEEK_DATA expected 10240 or 10240, got -1.                  FAIL
> 
> And manual test showed subtest 8 failed too
> 
> # ./src/seek_sanity_test -s 8 -e 8 /mnt/xfs/testfile
> File system magic#: 0x58465342
> Allocation size: 4096
> 
> 08. Test file with unwritten extents, only have unwritten pages
> 08.01 SEEK_HOLE expected 0 or 5632, got 0.                        succ
> 08.02 SEEK_HOLE expected 1 or 5632, got 1.                        succ
> 08.03 SEEK_DATA expected 5120 or 5120, got -1.                    FAIL
> 08.04 SEEK_DATA expected 5120 or 5120, got -1.                    FAIL
> 
> Other subtests all passed with sub-page block size XFS.

Strange. It doesn't fail for me this way even with 1k blocksize. I'll
investigate more tomorrow.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
