Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A608F139D11
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 11:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718710083; cv=none; b=i0uvV5qoN116rmsZlDss4ow3tFeDWJfQdQDvkOZloaWJhA8yyXUjfJY6HFj3ufAt61VAeIj4csuOYCLMz2fankBKOcIxXYiI/p26iSqvUnXzuiYWX8B6MweQm/TfG8JBAwAs6RA7VQjoVnRFxN9cfiTpylJ1kyN++lZD0mRdS60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718710083; c=relaxed/simple;
	bh=hH3U5mloyPCXlpzKoNAyMV6TR1moh+rnmnZvyo4bS58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSr8IUQiiNlfyF9Hp/UIYsdNdbaltWoNscZcpfSJ6rYGDOKQFrc1cjWmVHtFvUY25BJus3SFDwAUa1iaMV7velZgDBbRxyebUDj+bV2SlDvvbvL5q92wkBfsXzhubHbAXDhT01b21PbvRtSykYc0QWMIQXYNCF8heIn/m0T0Mws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5ACLMi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5ACLMi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F6FC32786;
	Tue, 18 Jun 2024 11:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718710083;
	bh=hH3U5mloyPCXlpzKoNAyMV6TR1moh+rnmnZvyo4bS58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5ACLMi+1r7J3XGNGCXK0ekS89dGW6xx8VA913PyFO17XvbdkRbDFPVy0cicy+/0w
	 DBgnxWFhk7A8V4QA6jQneEV8wnZ7+iVzXzPi34zuwDQhvzBGQscX1HrKFFov0eOHpD
	 9WD2zMPCghG8WozA4uptx/4R3zILzca+1ydQH5Yw9Y5MPQN7mH3ZFRjArcuMvnXC/z
	 jcRrmDNkhSulumyEfHDPf4ZOmecbGsU66QvyKmPrqun5n7WZiGxjtYqXFKfhaPm8q4
	 zR7wtd4AX/YjcK4FB0CswUPd4jRtwgUad2LjjU4IyEWgyjHG6bUMc40RG+ZTNVRds4
	 AkN7WPAiy+p/Q==
Date: Tue, 18 Jun 2024 13:27:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfile: fix missing error unlock in xfile_fcb_find
Message-ID: <3vvawog6q36sacc7swbg4vv7wuazpvuk564ob4m2kacqwjs2ka@wv3oj6kvszfy>
References: <A7t-EBUq9-H5Sajvoq6mgbeRxHUyOpyu0OzoCm9hEPzYSxku7_DEwUlAZcUHRA8DoatghRew8uwcIN9iWADZ7w==@protonmail.internalid>
 <20240618005703.GD103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618005703.GD103034@frogsfrogsfrogs>

On Mon, Jun 17, 2024 at 05:57:03PM GMT, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a missing mutex pthread_mutex_unlock and uninitialized return value
> in xfile_fcb_find.
> 
> Coverity-id: 1604113
> Coverity-id: 1604099
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  libxfs/xfile.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libxfs/xfile.c b/libxfs/xfile.c
> index fdb76f406647..6e0fa809a296 100644
> --- a/libxfs/xfile.c
> +++ b/libxfs/xfile.c
> @@ -179,7 +179,7 @@ xfile_fcb_find(
>  {
>  	struct xfile_fcb	*fcb;
>  	int			ret;
> -	int			error;
> +	int			error = 0;
> 
>  	/* No maximum range means that the caller gets a private memfd. */
>  	if (maxbytes == 0) {
> @@ -222,13 +222,13 @@ xfile_fcb_find(
>  	/* Otherwise, open a new memfd and add it to our list. */
>  	error = xfile_fcb_create(description, &fcb);
>  	if (error)
> -		return error;
> +		goto out_unlock;
> 
>  	ret = ftruncate(fcb->fd, maxbytes);
>  	if (ret) {
>  		error = -errno;
>  		xfile_fcb_irele(fcb, 0, maxbytes);
> -		return error;
> +		goto out_unlock;
>  	}
> 
>  	list_add_tail(&fcb->fcb_list, &fcb_list);
