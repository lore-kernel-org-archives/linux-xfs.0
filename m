Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1928A38239B;
	Wed,  1 Jul 2026 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782925884; cv=none; b=I7BMMRJcOB2kt7wJQD5cAnEbTYkkynFC5vH/Kiv8JU/PpdoqA9G3owFD7QrMZwTGoCbUEjBrgv+UJ5unKnRerlkVaQf/uDKtyA+8pTu7z94USQmAoJNB3TnAAyxN3MFRglOtw7daaqYN+qdBbxaF/20HtJsUghxfNFULCG0wuZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782925884; c=relaxed/simple;
	bh=V5rTobRcuDGj/Yg1bpYbFTc4iNH9JhKPkPh6X0owJVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSRzDvMex2a6O0rbKXTpkV9qttyur9SStXBYodkX7EOlvJXtW/xhBDn7S2novAaEl4FsEvH2NAlBaU05Zvft3q37DLNyjgeSCrq1ZVpZXczf7s1UbD3UMa1eEFz1QI+UkNrKR3msB9umbxcnZqF+G6vzRJe80jsUb1l7c2fcnrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLk6T1xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLk6T1xP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B74961F000E9;
	Wed,  1 Jul 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782925882;
	bh=dObZorwKY5QXIIvyRJ67mb+sIhgTQQ1nuYKhEabm1IY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eLk6T1xPagtKVZRSbzBIhjdmyruf+ywZiv6+Yi0GhAt7ebSQGszb9JqdwVTH/x8Nv
	 2j8FBo0nP5yyUyi1I1u28my64HyjSHN525nNfzApYyqlc8maaoW4uHeHFFTyytNBwu
	 44Hj0G2JyYgB4eIa6Sv9Pv7MrKtHPEcbMf/qwFBqO9jcyHOW283g4mXGEWt3V+Yoxp
	 4i23BJwSCN496LxCRwNVRF6OYQIMzPOFGkzwQWPdiKUsHnq/6Qi7yDRdSEkZipQK2r
	 lgtEGrdCI4pk9+5jGO2MBDcP22/wLrga0xlLthUnrM6bpY4jm4Wqu1nofhnJurMEni
	 lGX+ASfXeQNvQ==
Date: Wed, 1 Jul 2026 10:11:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v7 04/11] fstests: add _require_unique_f_fsid() helper
Message-ID: <20260701171122.GF6517@frogsfrogsfrogs>
References: <cover.1781694879.git.asj@kernel.org>
 <f556db45f1ffc93508a69ce9f9e567b74384210f.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f556db45f1ffc93508a69ce9f9e567b74384210f.1781694879.git.asj@kernel.org>

On Wed, Jun 17, 2026 at 07:20:31PM +0800, Anand Jain wrote:
> Add a helper to check if the target filesystem supports unique f_fsid
> tracking across cloned or snapshot instances.
> 
> Certain filesystems like XFS, Btrfs, and F2FS ensure unique f_fsid
> identifiers per filesystem instance. However, Ext4 derives its f_fsid
> directly from its superblock UUID, which leads to identical f_fsid
> values on cloned images until the UUID is manually modified by userspace.
> 
> Introduce _require_unique_f_fsid() to allow test cases requiring strict
> f_fsid uniqueness to skip gracefully on unsupported filesystems.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 968ba33686f3..d95eec94f7b7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6310,6 +6310,27 @@ _require_fanotify_ioerrors()
>  	_notrun "$FSTYP does not support fanotify ioerrors"
>  }
>  
> +# Ext4 derives f_fsid from the superblock UUID, meaning clones share the
> +# same f_fsid until their UUIDs diverge. Conversely, XFS, Btrfs,
> +# and F2FS ensure f_fsid remains unique per filesystem instance (often by
> +# deriving it from the UUID and underlying block device.)
> +#
> +# Across all filesystems, a UUID collision causes libblkid tools to return
> +# non-deterministic device mappings. It is ultimately the responsibility
> +# of the userspace utility or use-case to enforce uniqueness when a clone
> +# diverges. For details, see mailing list thread discussions:
> +#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
> +_require_unique_f_fsid()
> +{
> +	# Skip the test if the filesystem does not enforce unique f_fsids
> +	# natively. Checking this dynamically requires recreating a clone
> +	# layout, so we use a static lookup based on FSTYP.

I would switch these two comments.  The second comment above describes
what this predicate function actually determines, whereas the first
comment above the function justifies the internal behavior of the
function.

# Skip the test if the filesystem does not enforce unique f_fsids
# natively. Checking this dynamically requires recreating a clone
# layout, so we use a static lookup based on FSTYP.
#
# Across all filesystems, a UUID collision causes libblkid tools to return
# non-deterministic device mappings. It is ultimately the responsibility
# of the userspace utility or use-case to enforce uniqueness when a clone
# diverges. For details, see mailing list thread discussions:
#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
_require_unique_fsid(
{
	case "$FSTYP" in
	ext*)
		# Ext4 derives f_fsid from the superblock UUID, meaning
		# clones share the same f_fsid until their UUIDs
		# diverge.
		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
		;;
	*)
		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
		# unique per filesystem instance (often by deriving it
		# from the UUID and underlying block device.)
		;;
	fi
}

--D

> +	if [ "$FSTYP" == "ext4" ]; then
> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
> +	fi
> +}
> +
> +
>  # Computes a percentage of the available space in a filesystem and
>  # returns that quantity in MB. The percentage must not contain a percent
>  # sign ("%").
> -- 
> 2.43.0
> 
> 
