Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58581 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726749AbfFXPIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 11:08:47 -0400
Date: Mon, 24 Jun 2019 11:08:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] shared/011: run on all file system that support cgroup
 writeback
Message-ID: <20190624150839.GB6350@mit.edu>
References: <20190624134407.21365-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134407.21365-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 03:44:07PM +0200, Christoph Hellwig wrote:
> Run the cgroup writeback test on xfs, for which I've just posted
> a patch to support cgroup writeback as well as ext2 and f2fs, which
> have supported cgroup writeback for a while now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/shared/011 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shared/011 b/tests/shared/011
> index a0ac375d..96ce9d1c 100755
> --- a/tests/shared/011
> +++ b/tests/shared/011
> @@ -39,7 +39,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  
>  # Modify as appropriate.
> -_supported_fs ext4 btrfs
> +_supported_fs ext2 ext4 f2fs btrfs xfs

Per my comments in another e-mail thread, given how many of the
primary file systems support cgroup-aware writeback, maybe we should
just remove the _supported_fs line and move this test to generic?

Whether we like it or not, there are more and more userspace tools
which assume that cgroup-aware writeback is a thing.

Alternatively, maybe we should have some standardized way so the
kernel can signal whether or not a particular mounted file system
supports cgroup-aware writeback?

						- Ted
