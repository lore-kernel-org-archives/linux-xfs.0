Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbdKBMmQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:42:16 -0400
Date: Thu, 2 Nov 2017 20:42:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be
 allowed
Message-ID: <20171102124214.GY17339@eguan.usersys.redhat.com>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957284389.18388.370732842906149356.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 01, 2017 at 02:47:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A directory corrupted into a symlink will be caught by the upcoming
> local format ifork verifiers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/348.out |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/348.out b/tests/xfs/348.out
> index f4a7a71..17d9be2 100644
> --- a/tests/xfs/348.out
> +++ b/tests/xfs/348.out
> @@ -239,7 +239,7 @@ would have junked entry "DATA" in directory PARENT_INO
>  would have junked entry "DIR" in directory PARENT_INO
>  would have junked entry "EMPTY" in directory PARENT_INO
>  would have junked entry "FIFO" in directory PARENT_INO
> -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
> +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning

But this breaks tests on old kernels. Or with the new ifork verifiers,
old kernels can be considered as buggy?

Thanks,
Eryu

>  stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
>  stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
>  stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
> 
