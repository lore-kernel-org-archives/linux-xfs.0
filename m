Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFA4C14F
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMrBU87R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E71C433C7;
	Fri, 24 Nov 2023 09:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817357;
	bh=uoMBvbAbsd04BLqC7Y+95/2lYUNfqVzMbAFTRx7KJKY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=dMrBU87R8EfHPqfutWruBNT6ltk6y/ruCzm3bg3GO69LoDgmSR8+sKEdaRuaZsXFq
	 FLVy4zQMluUhMJhvJfVnO5+zG+mDzR5jLDmbfhiKHSxgedVXjIQ/nVGGHbYv2k56x1
	 blgNUPREYc7o87BmsjHt1EEnIUQjE4yYEbXoXXfE82xQ3Wbw3rrnV++z02fkotO7N0
	 VsN8iYdm78Csxn9rWxhKaHhTC2UrXXRRD9/OKZr1oMPPX7IBjYq+uiOXNbqL2DOAjs
	 mjVBIqOPGE7O81f6fgOp7bpjiM7K1gc3fWC6cQDSox2VR7HVkBzMGzt4vTBkTPxdVE
	 aRN4vTcKzWt+A==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069443670.1865809.2265862857261044359.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_metadump.8: update for external log device options
Date: Fri, 24 Nov 2023 14:41:30 +0530
In-reply-to: <170069443670.1865809.2265862857261044359.stgit@frogsfrogsfrogs>
Message-ID: <87leanwlyt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:07:16 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Update the documentation to reflect that we can metadump external log
> device contents.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  man/man8/xfs_mdrestore.8 |    6 +++++-
>  man/man8/xfs_metadump.8  |    7 +++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
>
> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> index 6e7457c0445..f60e7b56ebf 100644
> --- a/man/man8/xfs_mdrestore.8
> +++ b/man/man8/xfs_mdrestore.8
> @@ -14,6 +14,10 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>  .br
>  .B xfs_mdrestore
>  .B \-i
> +[
> +.B \-l
> +.I logdev
> +]
>  .I source
>  .br
>  .B xfs_mdrestore \-V
> @@ -52,7 +56,7 @@ Shows metadump information on stdout.  If no
>  is specified, exits after displaying information.  Older metadumps man not
>  include any descriptive information.
>  .TP
> -.B \-l " logdev"
> +.BI \-l " logdev"
>  Metadump in v2 format can contain metadata dumped from an external log.
>  In such a scenario, the user has to provide a device to which the log device
>  contents from the metadump file are copied.
> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> index 1732012cd0c..496b5926603 100644
> --- a/man/man8/xfs_metadump.8
> +++ b/man/man8/xfs_metadump.8
> @@ -132,8 +132,11 @@ is stdout.
>  .TP
>  .BI \-l " logdev"
>  For filesystems which use an external log, this specifies the device where the
> -external log resides. The external log is not copied, only internal logs are
> -copied.
> +external log resides.
> +If the v2 metadump format is selected, the contents of the external log will be
> +copied to the metadump.
> +The v2 metadump format will be selected automatically if this option is
> +specified.
>  .TP
>  .B \-m
>  Set the maximum size of an allowed metadata extent.  Extremely large metadata


-- 
Chandan
