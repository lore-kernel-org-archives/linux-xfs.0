Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24721 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdI1RFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2017 13:05:22 -0400
Date: Thu, 28 Sep 2017 10:05:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic/447: not a quick test
Message-ID: <20170928170510.GA5505@magnolia>
References: <1506616841-24121-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506616841-24121-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Sep 28, 2017 at 07:40:41PM +0300, Amir Goldstein wrote:
> It hogged my cpu for a good 300s.
> Test was inheritted from generic/176, which is not quick.

Hmm, takes 51s on some nice fast "pmem" here.  Not quick either. :(

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/generic/group | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/group b/tests/generic/group
> index f922b49..a9ad05d 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -449,7 +449,7 @@
>  444 auto quick acl
>  445 auto quick rw
>  446 auto quick rw dangerous
> -447 auto quick clone
> +447 auto clone
>  448 auto quick rw
>  449 auto quick acl enospc
>  450 auto quick rw
> -- 
> 2.7.4
> 
