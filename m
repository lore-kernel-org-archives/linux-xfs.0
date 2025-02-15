Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68C678F35;
	Sat, 15 Feb 2025 13:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739625413; cv=none; b=UjD/yWS70Mb1Ch4Mu32jR4yKxJpj2DgZ1C/1g4g8gFfqCVmqaExEeorOiDHEKA4xd7AMNg2g4PTNLehUgUCRzMC7KIQyMm7BJwluLb9I5khVcJOPiGdvVns4YHTnseSewHBLUZRgMWQ4pOgj5XiUCOMGw0RCXwwJF2MteW95Py8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739625413; c=relaxed/simple;
	bh=t2apdF6PShqXNVBRb9y0vIOktShDfXeGzjCvTu7zC0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8hMXzwZRLEErBhZzimaHYuNUPwKYcrWwfvoMVbmJXQBp8DsUlOEYca2F+U55osQtmoI9pK5keoW2u4Ursobwspb0wpdATg3qTOr2pquw6TASNTqMfgcRI3u4oJ+v7Ao7lAehKCtrC7UvksHMUe5jGmg4XBH9eLmFVY96V5JoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvidJh/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvidJh/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B391CC4CEDF;
	Sat, 15 Feb 2025 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739625413;
	bh=t2apdF6PShqXNVBRb9y0vIOktShDfXeGzjCvTu7zC0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IvidJh/Ybdjab22AcqVNm17AmnPkNCAGgbak4LGeO5Txq9+A6yPYlfZubD86p6aDT
	 zvPSrwd1Jyel9GGvBnFGF5HGGwJmoqMzrDcsSt38e0z3R4C5CpXOTRXSu6vlKUT//2
	 p71NnNQqlsw2Gb6EN1RJ01aXYHAZ5n5zdbRb2b+IODbp6OxjfP1YsMLliFRddJc79x
	 JDd0OKN5lFc/RsUGInWtKJ7lTYwOdxUR1F8pMEksib43kRaLRUayXfIv0lemYM/kju
	 XrEaXFEZ+TE/jzIQPk2atr2WZIu6hHzPYvUI9Mhmdg96CW0ETavXJl68stfpYq6EBq
	 E49NfF8jfDk8w==
Date: Sat, 15 Feb 2025 21:16:48 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, dchinner@redhat.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13.99/34] tools: add a Makefile separate session
Message-ID: <20250215131648.g3ljalidhhqfaadk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
 <20250214211222.GE21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214211222.GE21799@frogsfrogsfrogs>

On Fri, Feb 14, 2025 at 01:12:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a Makefile to the tools/ directory so that we can put helper scripts
> in there and have them installed at make install time.  The makefile
> comes from a conversation that Zorro and I had over IRC, hence the RH
> copyright.
> 
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Ahahah, I'm just going to send the patches (we've talked) to you. So looks
like you've solve the big problem :) Anyway, this change is good to me. Thanks
for doing this, I've tested this change.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  Makefile       |    2 +-
>  tools/Makefile |   17 +++++++++++++++++
>  2 files changed, 18 insertions(+), 1 deletion(-)
>  create mode 100644 tools/Makefile
> 
> diff --git a/Makefile b/Makefile
> index d4b77c1cd17787..e2e47ffc2e6e07 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -40,7 +40,7 @@ LDIRT += $(SRCTAR)
>  endif
>  
>  LIB_SUBDIRS = include lib
> -TOOL_SUBDIRS = ltp src m4 common
> +TOOL_SUBDIRS = ltp src m4 common tools
>  
>  SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
>  
> diff --git a/tools/Makefile b/tools/Makefile
> new file mode 100644
> index 00000000000000..3ee532a7e563a9
> --- /dev/null
> +++ b/tools/Makefile
> @@ -0,0 +1,17 @@
> +#
> +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> +#
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +TOOLS_DIR = tools
> +
> +include $(BUILDRULES)
> +
> +default:
> +
> +install: default
> +	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(TOOLS_DIR)
> +
> +install-dev install-lib:
> 
