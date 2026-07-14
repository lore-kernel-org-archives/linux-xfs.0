Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B960367B9C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 23:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784071829; cv=none; b=grMwRTlWDt4Ihr9NQeaW01BFIxRrRl4UkRYToO3QselHv0ML2MODnoUu9DzHlSAcdX62WFgB3GPsJ1x9pgjWIEm9aa5vy7qwj6/XioRScXuTchKyutOZjCvHKTKUMqQrfRSO+kPxkVk8EjHIpX25plJb5Jgiex7n6vG9QegqETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784071829; c=relaxed/simple;
	bh=wAKNnafPrfv4KRgaXWNnVK7ZlXzgjNeGjSJvoj03PpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBl/PHuauD8zCAvV1hucxKGUV0zGLfXZxgTkdoVL+emZVdbkkjRnuruguwccHVhJjnyY/LrIcklMfzVw8iy0GudAh2RlWpu4gBEsV9gNCwfvJvAS3VnHAsjY5HxZX1HPLTsO7260jk9C9OU7GYBgm0H2lINvFCDyShe+EWTiL5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ow2CONyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ow2CONyb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 159E11F000E9;
	Tue, 14 Jul 2026 23:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784071828;
	bh=u51JwSs3xxnRVXsWNd+SCq+pw9o+36CPqy8Pf2SpUoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ow2CONybjKCs4BRzV1CZlrRP2iOqhMPa3YGA9KAgT4HdjvcDebZDOa2V0QPkGjP/V
	 NXMUYiyGreyN9NYFyaLPLT++lmYX251upgM8YNVOjjqjkDu/fXaW3Zc/Wi3RGgU0SU
	 YrxAwoXVvj1qs+R5R5oz4zKbphSDQLTNjHmticVFr9n9719MbQc9RnV8TIAtibIMkS
	 QtYAx/PsP/hryHOTF3I63Qk0Nf8eqWWZyPkaQWBu9bKtizWEbld32XPBmgYo/TDIbg
	 NfH/gw1ZTBC+aLFNQTge6XdlKJoiBlRSba4jfHWtPfVDqJzCUlHIefJZAvI5BkNCld
	 tXvaHKdnNXToQ==
Date: Tue, 14 Jul 2026 16:30:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Allen Hewes <rallenh@hotmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: healer: install targets one at a time
Message-ID: <20260714233027.GL7380@frogsfrogsfrogs>
References: <3681cff200496f792a9f0dfdc117c268fc5803d5.camel@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3681cff200496f792a9f0dfdc117c268fc5803d5.camel@hotmail.com>

On Tue, Jul 14, 2026 at 11:21:03PM +0000, Allen Hewes wrote:
> libtool's --mode=install requires the destination to already exist
> as a real directory whenever more than one source file is given
> (it emulates cp/install semantics, which have the same requirement).
> Installing xfs_healer and xfs_healer_start in a single LTINSTALL
> call trips this check on any build where HAVE_HEALER_START_DEPS=yes,
> since PKG_LIBEXEC_DIR isn't guaranteed to exist under the raw,
> un-DESTDIR'd path libtool checks. Install each target separately
> to avoid the multi-file directory check entirely.

Aha, so that's the bug then -- distro build scripts set DESTDIR=/xxx and
run the build.  include/buildefs sets
PKG_LIBEXEC_DIR=/usr/libexec/xfsprogs and passes that to libtool.
libtool sees that /usr/libexec/xfsprogs doesn't exist and fails.

Or, if that path happens to exist already, then it starts our custom
../install-sh script which copies the file to $DESTDIR/$PKG_LIBEXEC_DIR
which is NOT the same path that libtool dies on.

> Assisted-by: Claude:claude-sonnet-5
> Signed-off-by: Allen Hewes <rallenh@hotmail.com>
> ---
>  healer/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/healer/Makefile b/healer/Makefile
> index e3c41e66..4aa58757 100644
> --- a/healer/Makefile
> +++ b/healer/Makefile
> @@ -69,7 +69,9 @@ install: $(INSTALL_HEALER)
>  
>  install-healer: default
>  	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> -	$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
> +	for f in $(BUILD_TARGETS); do \
> +		$(LTINSTALL) -m 755 $$f $(PKG_LIBEXEC_DIR); \

Let's hope nobody ever wants to build a binary with a space in it.
Thanks for digging into this.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	done
>  
>  install-systemd: default
>  	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> -- 
> 2.55.0
> 
