Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756743AbdACFw6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 00:52:58 -0500
Date: Tue, 3 Jan 2017 13:52:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 0/3] xfs/348: test handling of malformed inode mode
Message-ID: <20170103055256.GK1859@eguan.usersys.redhat.com>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Dec 25, 2016 at 08:09:33PM +0200, Amir Goldstein wrote:
> Eryu,
> 
> I beefed up the initial test sent earlier today with more checks
> on mounted fs.
> 
> The original patch testing only xfs_repair remains patch 1 in this series.
> 
> Patch 2 adds fstat tests on mounted fs, which are safe on my test system.
> 
> Patch 3 is explosive. It exposes an XFS assert, but I left a "safety pin"
> that needs to be commented out to reproduce the assert.

My kenrel config doesn't turn DEBUG on, so I don't see a kernel crash :)

I can push this test out after the fix lands in upstream, then I think
there's no need to leave a switch in the test.

Otherwise tests look good to me. But I'd like to have Darrick to review
too, as he had written many fuzzer tests and suggested this test :)

Thanks,
Eryu

> 
> I will soon post my kernel configs and dmesg logs.
> 
> Amir.
> 
> v2:
> - test fstat with malformed inode mode
> - test readlink/readdir with malformed inode mode
> 
> v1:
> - test xfs_repair with malformed inode mode
> 
> Amir Goldstein (3):
>   xfs/348: test handling of invalid inode modes
>   xfs/348: test fstat with malformed inode mode
>   xfs/348: test readlink/readdir with malformed inode mode
> 
>  tests/xfs/348     | 154 +++++++++++++++++++++++++++
>  tests/xfs/348.out | 312 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 467 insertions(+)
>  create mode 100755 tests/xfs/348
>  create mode 100644 tests/xfs/348.out
> 
> -- 
> 2.7.4
> 
