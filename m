Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbdEQMb3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 08:31:29 -0400
Date: Wed, 17 May 2017 20:31:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/3 v2] xfs: Fix SEEK_HOLE implementation
Message-ID: <20170517123115.GG7250@eguan.usersys.redhat.com>
References: <20170517121046.2632-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170517121046.2632-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Hi Jan,

On Wed, May 17, 2017 at 02:10:43PM +0200, Jan Kara wrote:
> Hello,
> 
> this is the second revision of the patches to fix bugs in XFS's SEEK_HOLE
> implementation and cleanup the code a bit.
> 
> Changes since v1:
> * Fixed some more buggy cases
> * Simplified code a bit as suggested by Darrick
> * Fixed range check as spotted by Brian

I applied this patchset on top of 4.12-rc1 kernel to test your v4 test
case, your new test passed all my tests, but I found generic/285
regressed with sub-page block size XFS, 285.full showed that failure was
from subtest 7

07. Test file with unwritten extents, only have dirty pages
07.01 SEEK_HOLE expected 0 or 11264, got 0.                       succ
07.02 SEEK_HOLE expected 1 or 11264, got 1.                       succ
07.03 SEEK_DATA expected 10240 or 10240, got -1.                  FAIL
07.04 SEEK_DATA expected 10240 or 10240, got -1.                  FAIL

And manual test showed subtest 8 failed too

# ./src/seek_sanity_test -s 8 -e 8 /mnt/xfs/testfile
File system magic#: 0x58465342
Allocation size: 4096

08. Test file with unwritten extents, only have unwritten pages
08.01 SEEK_HOLE expected 0 or 5632, got 0.                        succ
08.02 SEEK_HOLE expected 1 or 5632, got 1.                        succ
08.03 SEEK_DATA expected 5120 or 5120, got -1.                    FAIL
08.04 SEEK_DATA expected 5120 or 5120, got -1.                    FAIL

Other subtests all passed with sub-page block size XFS.

Thanks,
Eryu
