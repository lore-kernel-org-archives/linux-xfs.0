Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdJ0EmD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 00:42:03 -0400
Date: Fri, 27 Oct 2017 12:42:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 9/6] generic/459: fix test running errors
Message-ID: <20171027044201.GU3235@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027004446.GG5486@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027004446.GG5486@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Oct 26, 2017 at 05:44:46PM -0700, Darrick J. Wong wrote:
> If the DISCARD of the thin device somehow fails with this message:
> 
> device-mapper: thin: Data device (dm-1) discard unsupported: Disabling discard passdown.
> 
> Then we can end up with arbitrary gunk in the thin device.  This causes
> mkfs to fail because it's afraid to format the device.  Don't be afraid,
> just zap it.  FWIW mkfs.xfs thinks that the thinp device has an xfs
> external log because sometimes the thinp device just happen to be backed
> by the log of the previous test's scratch fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/459 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/459 b/tests/generic/459
> index 7c10c2a..3dd3681 100755
> --- a/tests/generic/459
> +++ b/tests/generic/459
> @@ -92,7 +92,7 @@ $LVM_PROG lvcreate  --virtualsize $virtsize \
>  		    -T $vgname/$poolname \
>  		    -n $lvname >>$seqres.full 2>&1
>  
> -_mkfs_dev /dev/mapper/$vgname-$lvname >>$seqres.full 2>&1
> +_mkfs_dev -f /dev/mapper/$vgname-$lvname >>$seqres.full 2>&1

I think we should fix it in _mkfs_dev, add a new switch entry for xfs.

Thanks,
Eryu

>  
>  
>  # Running the test over the original volume doesn't reproduce the problem
