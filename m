Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15D333DEF7
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 10:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789468478; cv=none; b=nlMfu9GpoexoaTTCTswkbu4O+JxiFAu6VYNkx/oo54enGZVMxc4WgTwMaaM5liv0ols4L/SGzku3vnyrKMkQWTh2r294aRtToHUMZaikG22Huw69/5Q/I6/7L+gSbFb3YvXTRoyNG8MAloT0Ht8/zLYdCo9xfMr+DHKutXgYztY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789468478; c=relaxed/simple;
	bh=13cPiOGcm5BVIkrGCS6ZXQO+gfj77YjFwIxMY1exYWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFQWmw3ip9xjULVxpD38bOuKclMuhzQ+9jmwBqpFDbFt0VlAbI/luR8bTPTjlkvNfwrEzFCIHWght81xZe4+wL/3bU8CXO/FPFT2ncFoX7AhcMfHygHrU5PxOX83Exg9UdjPV7H66FQ6wkJ1uhnz/cMsI98OTspCf6GR1RMeGwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2eBB04G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2eBB04G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6340C1F000FF;
	Tue, 15 Sep 2026 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789468477;
	bh=MEZlv6JQYaInQNekmoBYD7xEuAPPoCiIzUoTc7dwIng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R2eBB04Gl5sbPt+/bRAB1SECf4Haik/Y+cNMzNN/4CWr+bP8NN5Ivg+6NQy7k2OPV
	 fwGOyXKeFTdL1m8UcR2P811ZohEKYVSbvcCBO9aP6NmrAUTNnPVSi/CjBK1KdUlH8F
	 U6aez7n7MSG80dwu3Q02EeoIMd5OJWEQhLD08pnlXAYGyrqa629l8aVUYzSk5i4kqy
	 OjKeucvEBHgasKi9WXLam0hMSd/pIiAbvmTF0bdSNJ8/hVFwDYJCWj35iP2AeE9OcR
	 K4lsrk7ewJlRMg1e6guECn2W84TCHQSUZJk2CDZphVl6s/c6AHNTE2bAJ8BKpUbKeb
	 f6hveAoCZrq/A==
Date: Tue, 15 Sep 2026 12:34:33 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libfrog: try to pass struct fs_path objects to
 quotactl wrapper
Message-ID: <aqkeeAgNLMFFqgcl@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>

On 2026-09-13 22:50:37, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're going to adapt xfs_quota to use quotactl_fd(), so to prepare for
> that, we need to pass fs_path pointers as deep into the stack as we can
> so that xfs_quota can open the associated mountpoint(s) and stash the
> fds in the fs_path objects; and then pass that to our quotactl wrapper.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  libfrog/quotactl.h |    4 +++
>  libfrog/quotactl.c |   12 ++++++++++
>  quota/edit.c       |   29 ++++++++++++++-----------
>  quota/free.c       |   11 +++++----
>  quota/path.c       |    4 ++-
>  quota/quota.c      |    6 +++--
>  quota/report.c     |   61 ++++++++++++++++++++++++++--------------------------
>  quota/state.c      |   38 +++++++++++++++++++-------------
>  8 files changed, 97 insertions(+), 68 deletions(-)
> 
> 
> diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
> index 5e351d53bb4b1e..dae03b787b7663 100644
> --- a/libfrog/quotactl.h
> +++ b/libfrog/quotactl.h
> @@ -23,4 +23,8 @@ enum xfs_quota_cmd {
>  int xfsquotactl(enum xfs_quota_cmd xcommand, const char *device,
>  		unsigned int xtype, unsigned int id, void *addr);
>  
> +struct fs_path;
> +int xfrog_quotactl(const struct fs_path *mount, enum xfs_quota_cmd xcommand,
> +		uint xtype, uint id, void *addr);
> +
>  #endif /* LIBFROG_QUOTACTL_H_ */
> diff --git a/libfrog/quotactl.c b/libfrog/quotactl.c
> index 81df2baf4a76b4..6129fa155ce75e 100644
> --- a/libfrog/quotactl.c
> +++ b/libfrog/quotactl.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  
> +#include "libfrog/paths.h"
>  #include "libfrog/quotactl.h"
>  #include <sys/quota.h>
>  
> @@ -66,3 +67,14 @@ xfsquotactl(
>  
>  	return quotactl(op, device, id, addr);
>  }
> +
> +int
> +xfrog_quotactl(
> +	const struct fs_path	*mount,
> +	enum xfs_quota_cmd	xcommand,
> +	uint			xtype,
> +	uint			id,
> +	void			*addr)
> +{
> +	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);

The xfsquotactl() can be unfolded here and calls may be replaced
with xfrog_quotactl(), no?

-- 
- Andrey
