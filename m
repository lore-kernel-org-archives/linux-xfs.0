Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48185 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S944771AbdDTN3B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 09:29:01 -0400
Date: Thu, 20 Apr 2017 15:28:59 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/2 v2] mkfs: unify numeric types of main variables in
 main()
Message-ID: <20170420132859.GU28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com>
 <20170420083323.12524-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170420083323.12524-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 10:33:23AM +0200, Jan Tulak wrote:
> Thus, uint64_t is the best candidate as the target
> type for numeric values. The existing uses of __uint64_t in mkfs change to the
> standard uint64_t type.

<-- snip -->

> CHANGES:
> * __uint64_t -> uint64_t

<-- snip -->

> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index ce9bbce..ab74536 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -57,7 +57,7 @@
>  #define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
>  #define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
>  
> -extern long long cvtnum(unsigned int blksize, unsigned int sectsize,
> +extern __uint64_t cvtnum(unsigned int blksize, unsigned int sectsize,

I thought uint64_t was desired ?

> -long long
> +uint64_t
>  cvtnum(
>  	unsigned int	blksize,
>  	unsigned int	sectsize,
>  	const char	*s)
>  {


Indeed. Probably just a missed case?

  Luis
