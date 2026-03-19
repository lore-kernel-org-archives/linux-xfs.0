Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FD23E8C4D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939247; cv=none; b=s8HncRphBA1BN21IrvoJF2EsnUOMlA68B79Qm4mG+e4Ua4CZ//vQqvPUdBRcxU4FzGKHCF7IpaPjUGMLK00UQPK16cLeLPoj2513B9tEEfhcg0Igd9dwgHZCH37B1ibSRH1LjVc0Wtt/UaGo1JQt75zRcWxwVydiXX1lyHhatc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939247; c=relaxed/simple;
	bh=8YR8uJOa9H5TIBadLEDwOzR2sXrCQmE5tlpCHlYjygk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ku5YhS+nvGrZXIYs9crkUAWnePImj3R7oEA7QoaElbhKC2+Lsa2UCuxdk0Bu2kZx0rCjmzV9XSE+6Q8vMFVzz3s1DbESj6qAneilmE/Bdi8Xc5tFDMCoObd28zeZZh5Iyvsshtv6c5V4rdyS8j8HD+4DbvX87lJGfW7q2T7x6JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kysWPMyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kysWPMyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB04FC19424;
	Thu, 19 Mar 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939246;
	bh=8YR8uJOa9H5TIBadLEDwOzR2sXrCQmE5tlpCHlYjygk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kysWPMypKZ9LlLnXCCVhB4r8EBWIRszVe4AosPR2ZzJQirwUcstt+6bZeXsfzXY+v
	 aL8wshV98X8zel5PU2z5JUk4Ce/IMTns7x7bse0DoKUlwAYtPrI/bp9SL8VLITzD7f
	 u2eEWksVXfCOhiRzxbE2IOyB1nBJ2w55DVq5fnwuBG83Wq2ncYv9uE0Q2UpNbnIcQX
	 Yb0K0UkuzA9zh0DXqY4LaufrNIGkO5f0pMlZ3pdgorgjLUZLOBoC2pf9AaIPta//SA
	 Q6JgeuQeKQyRCSFKNs7H62UXNZFvNOxzxtI86DaZAMgak9Z8zT+V2g4OF4pzJyvhkK
	 34cD91vKbl1AQ==
Date: Thu, 19 Mar 2026 09:54:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 2/3] xfs: fix ri_total validation in
 xlog_recover_attri_commit_pass2
Message-ID: <20260319165406.GQ1770774@frogsfrogsfrogs>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
 <20260319010618.722448-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319010618.722448-3-leo.lilong@huawei.com>

On Thu, Mar 19, 2026 at 09:06:17AM +0800, Long Li wrote:
> The ri_total checks for SET/REPLACE operations are hardcoded to 3,
> but xfs_attri_item_size() only emits a value iovec when value_len > 0,
> so ri_total is 2 when value_len == 0.
> 
> For PPTR_SET/PPTR_REMOVE/PPTR_REPLACE, value_len is validated by
> xfs_attri_validate() to be exactly sizeof(struct xfs_parent_rec) and
> is never zero, so their hardcoded checks remain correct.
> 
> This problem may cause log recovery failures. The following script can be
> used to reproduce the problem:
> 
>  #!/bin/bash
>  mkfs.xfs -f /dev/sda
>  mount /dev/sda /mnt/test/
>  touch /mnt/test/file
>  for i in {1..200}; do
>          attr -s "user.attr_$i" -V "value_$i" /mnt/test/file > /dev/null
>  done
>  echo 1 > /sys/fs/xfs/debug/larp
>  mount /dev/sda /mnt/test/
>  echo 1 > /sys/fs/xfs/sda/errortag/larp
>  attr -s "user.zero" -V "" /mnt/test/file
>  echo 0 > /sys/fs/xfs/sda/errortag/larp
>  umount /mnt/test
>  mount /dev/sda /mnt/test/  # mount failed
> 
> Fix this by deriving the expected count dynamically as "2 + !!value_len"
> for SET/REPLACE operations.
> 
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: ad206ae50eca ("xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 8ebdd0926b89..19eaf6b8cd43 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -1049,7 +1049,7 @@ xlog_recover_attri_commit_pass2(
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  		/* Log item, attr name, attr value */
> -		if (item->ri_total != 3) {
> +		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {

The comment should be updated:

		/* Log item, attr name, optional attr value */

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					     attri_formatp, len);
>  			return -EFSCORRUPTED;
> -- 
> 2.39.2
> 
> 
