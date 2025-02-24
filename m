Received: from dibed.net-space.pl (dibed.net-space.pl [84.10.22.86])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 62CCE8F5E
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.10.22.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415287; cv=none; b=nqv+IC1X4MsumB++VJPN4ro0XXKWuTNNnkQ0ziG0kKzuCk8rG6mdz1+1yAVc9goej/aMu3f7PZ7buqqZ8sAPdG5cn4pXOnA67LIoOBDnff/ChaQgtk3KmCLmiUnkXoVjZRv7PdgnBZHU2+7ylLVgA/skCXVMVP7RB/MuAcNvIrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415287; c=relaxed/simple;
	bh=8B4e3BRbZllOAdDA2xPxEbEJvDpfyhIZAfpueoOcqG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnrE3/gkDZaLmstvdcXzkm1vvdP9S5owaCzELRzNIViHS/pAajxvp9sdCRv6I/CaHl+9c5D4wp+00eo6P0IL3X4sh5C8rJW0sls6ChorKLoN1T/Iutzi5RL9+puJOgqsSE25+bJHynWb0+bnGGmiStRhbxr9JbVpQYaazME528c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl; spf=pass smtp.mailfrom=net-space.pl; arc=none smtp.client-ip=84.10.22.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-space.pl
Received: from router-fw.i.net-space.pl ([192.168.52.1]:57976 "EHLO
	tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
	id S2239933AblBXQ2b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
	Mon, 24 Feb 2025 17:28:31 +0100
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:	Mon, 24 Feb 2025 17:28:30 +0100
From:	Daniel Kiper <dkiper@net-space.pl>
To:	"Darrick J. Wong" <djwong@kernel.org>
Cc:	grub-devel@gnu.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: add new superblock features added in Linux
 6.12/6.13
Message-ID: <20250224162830.x6bbko7ce6cfdocn@tomti.i.net-space.pl>
References: <20250203234122.GH134507@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203234122.GH134507@frogsfrogsfrogs>
User-Agent: NeoMutt/20170113 (1.7.2)

On Mon, Feb 03, 2025 at 03:41:22PM -0800, Darrick J. Wong via Grub-devel wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The Linux port of XFS added a few new features in 2024.  The existing
> grub driver doesn't attempt to read or write any of the new metadata, so
> all three can be added to the incompat allowlist.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

... but one nit below...

> ---
>  grub-core/fs/xfs.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
> index 8e02ab4a301424..5d809a770a1576 100644
> --- a/grub-core/fs/xfs.c
> +++ b/grub-core/fs/xfs.c
> @@ -89,6 +89,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME    (1 << 3)        /* large timestamps */
>  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)       /* needs xfs_repair */
>  #define XFS_SB_FEAT_INCOMPAT_NREXT64 (1 << 5)           /* large extent counters */
> +#define XFS_SB_FEAT_INCOMPAT_EXCHRANGE  (1 << 6)        /* exchangerange supported */
> +#define XFS_SB_FEAT_INCOMPAT_PARENT     (1 << 7)        /* parent pointers */
> +#define XFS_SB_FEAT_INCOMPAT_METADIR    (1 << 8)        /* metadata dir tree */
>
>  /*
>   * Directory entries with ftype are explicitly handled by GRUB code.
> @@ -98,6 +101,15 @@ GRUB_MOD_LICENSE ("GPLv3+");
>   *
>   * We do not currently verify metadata UUID, so it is safe to read filesystems
>   * with the XFS_SB_FEAT_INCOMPAT_META_UUID feature.
> + *
> + * We do not currently replay the log, so it is safe to read filesystems
> + * with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.
> + *
> + * We do not currently read directory parent pointers, so it is safe to read
> + * filesystems with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.

s/XFS_SB_FEAT_INCOMPAT_EXCHRANGE/XFS_SB_FEAT_INCOMPAT_PARENT/?

I can fix it for you before push...

> + *
> + * We do not currently look at realtime or quota metadata, so it is safe to
> + * read filesystems with the XFS_SB_FEAT_INCOMPAT_METADIR feature.
>   */
>  #define XFS_SB_FEAT_INCOMPAT_SUPPORTED \
>  	(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> @@ -105,7 +117,10 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  	 XFS_SB_FEAT_INCOMPAT_META_UUID | \
>  	 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
>  	 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
> -	 XFS_SB_FEAT_INCOMPAT_NREXT64)
> +	 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
> +	 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
> +	 XFS_SB_FEAT_INCOMPAT_PARENT | \
> +	 XFS_SB_FEAT_INCOMPAT_METADIR)

Daniel
