Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F1A440652;
	Tue,  1 Sep 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278984; cv=none; b=Js9Ssn8Db/U8oaVUDrEH9Z6w0M6kw6J0g0BLOKPIzXNMzJ2GZRP5t/hM/jGhk2+4kS3R9siUrhN3VVriG9lFclPIQcLzapHFYSli4fFW8QaiPq7O987WbujisG1EGsBwduE/2r20ovybOVrnECWlHZDLrcd3fPnYCQZL8PbjxZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278984; c=relaxed/simple;
	bh=3ScCW9zb7Ytm1fQ5HgRbaOC3JRk8a9y6/M5gPInI+r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsoRggneN0sjnJx2BqqSWoIGMcDbTyILaBI756tE/oMRLvG9n27SFekYwicwGj0++mK7Fk7oYfhXloyPp2ACncmJyOpALO4bRklivFcqcIWTHKkRAY5CI9v66sr3u8RO5cXb/GyQQNXhXBEbpdjEERKPgnDlxz2NqU4alS6viGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1Tz6oRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1Tz6oRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753F51F000E9;
	Tue,  1 Sep 2026 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278982;
	bh=9CE5RSBHk34ry3w4PuiZHGozADtZbhYGgw45lpA0o2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m1Tz6oRtFZ0zUWOQmm82EJl+t4YdeTXhXnnxypQmE9R6Ru0zkt0Hso2BJowL+tSNT
	 pZAW9+UGBe2OXzNpyJPIVyejvTQoRCwqFR6UOShqbLh1KEA4oVMMzAbC2vUqJxjjo5
	 ahtQ3Z6ajxhqhsQwLedC1wGjJ4dPpKAtO1Zd1ViJ3ET0wv7lhKbv+izI0OIYMPH1KY
	 MkZHbpY5MDwrOuE3Nm7Lb06drbVK5har0KcGJUVSFMWfYiUwY8NCm9/Leumz0OwmHm
	 pPfbpBXXENrKeo36Y6e+YJt3nv7/odzaDiHakUXIgsu8ePE1TFyiGwJ4C20dyl10EC
	 UPQuRVM6uVcEQ==
Date: Wed, 2 Sep 2026 00:09:35 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 05/13] fstests: add _require_unique_f_fsid() helper
Message-ID: <apb19-FLJv9dRFDS@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <878a21ea507cb955ed414072c82ab5e5493b8ae0.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878a21ea507cb955ed414072c82ab5e5493b8ae0.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:02PM +0800, Anand Jain wrote:
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
>  common/rc | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 21b516accdf7..f73251365a60 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6356,6 +6356,33 @@ _require_fanotify_ioerrors()
>  	_notrun "$FSTYP does not support fanotify ioerrors"
>  }
>  
> +# Skip the test if the filesystem does not enforce unique f_fsids
> +# natively. Checking this dynamically requires recreating a clone
> +# layout, so we use a static lookup based on FSTYP.
> +#
> +# Across all filesystems, a UUID collision causes libblkid tools to return
> +# non-deterministic device mappings. It is ultimately the responsibility
> +# of the userspace utility or use-case to enforce uniqueness when a clone
> +# diverges. For details, see mailing list thread discussions:
> +#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
> +_require_unique_f_fsid()
> +{
> +	case "$FSTYP" in
> +	ext*)
> +		# Ext4 derives f_fsid from the superblock UUID, meaning
> +		# clones share the same f_fsid until their UUIDs
> +		# diverge.
> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
> +		;;
> +	*)
> +		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
> +		# unique per filesystem instance (often by deriving it
> +		# from the UUID and underlying block device.)
> +		;;
> +	esac

I would prefer to let the experts of each filesystem confirm whether their
fs guarantees a unique f_fsid. How about switching this logic to an *allowlist*
*(whitelist)* approach, where we _notrun by default and only allow filesystems
that explicitly guarantee unique f_fsid support?

  case "$FSTYP" in
  btrfs|xfs|f2fs)
        ;;
  *)
        _notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
        ;;
  esac

Thanks,
Zorro

> +}
> +
> +
>  # Computes a percentage of the available space in a filesystem and
>  # returns that quantity in MB. The percentage must not contain a percent
>  # sign ("%").
> -- 
> 2.43.0
> 
