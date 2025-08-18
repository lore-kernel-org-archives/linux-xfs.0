Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BDE17A318
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 20:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549961; cv=none; b=qtiWNnvld458p8kGysC5WRTGwr5V5DUNUgygb0qn/b3Gr6DzKgGEY6yAwRzrbF6Yrr49AvM5KG0zMuGJuAiDTz7jfWl5ioNlruhUuuteRBeiupGF1SQKC+H4LhckrfWLqdB/+NyOQ8hkLdYWYyp6Ri6pbc4L6ng1w+40hR6ao7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549961; c=relaxed/simple;
	bh=9hinBuc7rsznGLsVOeVedvzxKEicQwHwoWDXegTNT2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoIo0tzOOadnmLwYPqkZbJfzHpMLCEPhqtP673nZn924+pWnHexQkicyMjkgaYQKL5rggdGALbJy6yxbBifgxp2FNLqKNKhIXE8Ph+7bqhThmgdJLDfv+gSuCSa1qEO26RaSvEu7E7E3t09UCbwFUsjh+o5FGcxAiw1ne2cwSYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppxPNzqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppxPNzqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF368C4CEEB;
	Mon, 18 Aug 2025 20:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755549961;
	bh=9hinBuc7rsznGLsVOeVedvzxKEicQwHwoWDXegTNT2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ppxPNzqKsmfXLciJUPHbnDe+uxHG/W30CwfO0606R24Vv/IDSOm33WLnrmyVKzZMo
	 0FjkZyY4dKcVvZkRgiE/hCpnEW/5PZRDupKgLkyxrVagh6bk6Q3E+e0FEJxe2ODXlY
	 lbPlj7CfV4RFKa+c0EVdDEXwuwY34cG0tOZPgkJgA4kll/Gdox4jtf615+CUHxIDlT
	 XanZ3u0sxEhTnhVGoOJv8wEnizXq66p0XOHLqSymwpoH5e1GG8YGhnbYCoWu0slkbi
	 erBNLzB4Yzin/TmSjAzh14W1fUOSlhil9r0owEGSWv1+ukPsqj02zuUiAPBBmQvYS7
	 L2hPAX+oLlDiw==
Date: Mon, 18 Aug 2025 13:46:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Xavier Claude <contact@xavierclaude.be>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH xfsprogs] Document current limitation of shrinking fs
Message-ID: <20250818204600.GW7965@frogsfrogsfrogs>
References: <20250818151858.83521-1-contact@xavierclaude.be>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818151858.83521-1-contact@xavierclaude.be>

On Mon, Aug 18, 2025 at 03:19:10PM +0000, Xavier Claude wrote:
> Hello,
> 
> If I understand the code correctly[1], shrinking more than one AG is not
> supported. So I propose to add it to the manpage, like for the log
> shrinking option.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_fsops.c?h=v6.17-rc2#n152
> -- >8 --
> 
> Current implementation in the kernel doesn't allow to shrink more that
> one AG
> 
> Signed-off-by: Xavier Claude <contact@xavierclaude.be>
> ---
>  man/man8/xfs_growfs.8 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> index a0126927..2e329fa6 100644
> --- a/man/man8/xfs_growfs.8
> +++ b/man/man8/xfs_growfs.8
> @@ -70,6 +70,7 @@ otherwise the data section is grown to the largest size possible with the
>  option. The size is expressed in filesystem blocks. A filesystem with only
>  1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the point
>  where it would only have 1 AG.
> +.B [NOTE: Only shrinking the last AG without removing it is implemented]

That's my understanding of where growfs is right now wrt shrinking

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  .TP
>  .B \-e
>  Allows the real-time extent size to be specified. In
> -- 
> 2.50.1
> 
> 
> 
