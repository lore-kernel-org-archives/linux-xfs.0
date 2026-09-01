Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A6434407;
	Tue,  1 Sep 2026 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277069; cv=none; b=O8JaTgy7PLmZnTX4ugJAXyke9mVd+yVC8xfSA0oMntG459NN4u0IYAMcthOctt5fXnWJF96Zm2wafT+/bc4yIUrX/9MwsQa+ToOZZRvUV5dnbf95qz27Q9gXaJZCdZJTg/oD1STwkqVqaRrbNmTUZR3u899mxowWUZ+iuL5JmjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277069; c=relaxed/simple;
	bh=3y3Fzz+uzfqnhd+AAKyzJETKIcouZbqjtTrzWRVT2Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTYvNSmXP5mrFDDH+vbx0CIpc8SEfzfn+LxwttgqcXMwK5D8Q+sXb1zYlUc49iz+597pw83p1iRDbVxVwNKnC+SCi+wpnmyZ6n/WKQw1X5anwy3ExDQUnl89rzc1xguGrMjfQ4g00a07eKMycn5pM46U3kgaUidnSwL442Ch224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJiENG9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJiENG9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99AD1F000E9;
	Tue,  1 Sep 2026 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788277068;
	bh=qT7SEMz9YTRln0d8ZNOiT6CHsxhi25iHDyM6hQuAnHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FJiENG9rguyxm3V674ma1GAUWeJvo3VIay2BQiN6O1f42U9SIJ8NFECqhhwg93bho
	 kIAcTi8xhbCkxkYRWe7yuJX+fb2oWxqqpFFVy8v6vadNaN9Mr8deukVkfX7tnQSTCM
	 /ztzbbdh6i94ZdL2VHmdYjT+zJ2im3tfucFOyWL+pnkaeWOicYhvZ5KQS4xcuqYMwI
	 5mNKWOrGH44uAOfrBFTxU1OPtZTPIfJHdyrDp3wPBLs/QbQ06bUBhiV6KpgzKvKeTN
	 WW1ml43rSn7IRu9QgHlrQ90hpo1WsF8IU06JvRDkRt8VU1c6v24Lc+JjdUkR5tTXKR
	 15a/p+pczfpqg==
Date: Tue, 1 Sep 2026 23:37:40 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 03/13] fstests: add FSNOTIFYWAIT_PROG
Message-ID: <apbxF-WvNF4j7Ph4@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <09003af49b95d3b7fdf24b0d76e3ef389b44c3e1.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09003af49b95d3b7fdf24b0d76e3ef389b44c3e1.1784949154.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:00PM +0800, Anand Jain wrote:
> Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/config b/common/config
> index d5299d5b926f..5661fa0ec310 100644
> --- a/common/config
> +++ b/common/config
> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>  export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
> +export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"

OK, new *notifywait command.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  
>  # udev wait functions.
>  #
> -- 
> 2.43.0
> 
