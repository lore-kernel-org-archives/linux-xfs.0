Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0642BDC0B
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 23:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792020680; cv=none; b=kWf3hr+x7mNQgzxG+g0UhbZEpZo28RgXyz0Z5CO0zNby7onYofT8ktBosGixVD+HvtI+WGc5LyXn4r4kumD2+Ahi+0VzBzRu2pbBHDYA6dRDnGkjC3qGxOt+0jQSeh18oFkiyjHSWCPudVgSscClCq10oBH6nXc+oJL2z4CYADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792020680; c=relaxed/simple;
	bh=YOQm6hPGRkKfr5izqyntGoLNoqzkw1zeJ/8RDjhIJXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3Cu0dvhph5m1B+RsM93Wq/HlQqsXU7zImyNfmeitn2zwmG9XunA+cXGA0ZqBGFc/5/K62uJXXJvgBz4fwqV0UuUjcOMGCkB0GcWjLIQzb8Q2pzoDCjekVKvhg3nytjgiTt0gdKyH8ejgwJPe9lSGHghRNMNKCy8cUxKv76c8Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfQKEGnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfQKEGnH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 589D91F000C4;
	Wed, 14 Oct 2026 23:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792020678;
	bh=sxhlqcyC59HNE2wOdrIqvv27d//J65EWB36tAHTiETs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZfQKEGnHg6ZNQFLBlsrYGlfdjZy438XodtUWlCmJWHZ2WkKdUCr2aNSorFOEnqt3O
	 bXGvJIeMrEeYO777hOPryD68t9XYuPOXzzQi9jZsHysUiLe0+c3pkp68Fi+n6rQx0R
	 +e7XPfjujGJuKGzqJJBgzRDZ0P0ZFb28h05U16LjNFIJ4YDOmfzNUN5935/VFxaPT8
	 x+GpiAL4F7WR1zNgGd86zdGhqgO4JLgUxlQrwdF8LINB+qZC9VnSiwJuuPdJvK62m8
	 wIbjOcNVWkd/1mu2ymEQQK77Dfj09QZMXkAvhbnuWkcGwnOdNzoVyF3jIU0MheYrI/
	 4wrJr9YogX9pA==
Date: Wed, 14 Oct 2026 16:31:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 02/48] xfs: add log recovery item validation design
 document
Message-ID: <20261014233117.GL2705364@frogsfrogsfrogs>
References: <20261013060204.3138690-1-dgc@kernel.org>
 <20261013060204.3138690-3-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013060204.3138690-3-dgc@kernel.org>

On Tue, Oct 13, 2026 at 05:00:52PM +1100, Dave Chinner wrote:
> Add a design document describing a systematic approach to validating log
> items during journal recovery. Log item data read from the journal cannot
> be fully trusted - corruption from torn writes, hardware errors or
> software bugs can produce invalid type codes, wrong region counts,
> truncated regions or internally inconsistent format structures that the
> current recovery code largely uses unchecked.
> 
> The document describes a three-layer validation scheme (generic region
> header decode, per-region type-specific validation, and full cross-region
> item validation), the treatment of the transaction header as a validated
> region type, and a set of additional safety fixes for the generic region
> assembly code. It also lays out a phased implementation plan.
> 
> Changes:
> - Add Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> - Add the new document to the XFS documentation index
> 
> Created-by-AI: Claude Opus 4.8 (1M context)
>
> Prompt: Let's start by converting the existing verification doc to kernel
> .rst format and moving it to Documentation/filesystems/xfs/ and adding it
> to the relevant doc index file. The file should be tracked in a new patch.

Eheheh.

> Refinements:
> - Reordered the Phase 1 implementation plan so the ops-struct validation
>   infrastructure (min_regions/max_regions/min_hdr_len fields and the
>   validate_region callback) is added first (Patch 1), followed by the
>   transaction header ops entry that uses it (Patch 2). Downstream patches
>   renumbered accordingly so each patch builds cleanly on its own.
> ---
>  Documentation/filesystems/xfs/index.rst       |   1 +
>  .../xfs-log-recovery-validation-design.rst    | 477 ++++++++++++++++++
>  2 files changed, 478 insertions(+)
>  create mode 100644 Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> 
> diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
> index ab66c57a5d18..231c1382b27a 100644
> --- a/Documentation/filesystems/xfs/index.rst
> +++ b/Documentation/filesystems/xfs/index.rst
> @@ -9,6 +9,7 @@ XFS Filesystem Documentation
>     :numbered:
>  
>     xfs-delayed-logging-design
> +   xfs-log-recovery-validation-design
>     xfs-maintainer-entry-profile
>     xfs-self-describing-metadata
>     xfs-online-fsck-design
> diff --git a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> new file mode 100644
> index 000000000000..188b1bebf171
> --- /dev/null
> +++ b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst

The document sounds pretty reasonable for a first pass at hardening the
log recovery code.  This is a good start.

<snip>

> +Layer 3: Full item validation (type-specific, cross-region)
> +-----------------------------------------------------------

<snip>

> +Other intent/done items
> +    similar field-level validation

But please be more specific.

> +ICREATE
> +    - Already has validation in
> +      ``xlog_recover_icreate_commit_pass2()``, move the checks to
> +      ``validate_item``
> +
> +QUOTAOFF
> +    - Verify ``qf_flags`` contains only valid quota flags
> +

<snip>

> +Phase 3: Full item validation
> +-----------------------------
> +
> +Patch M: Add validate_item callback infrastructure
> +    - Add the callback to the ops struct
> +    - Call it from ``xlog_recover_reorder_trans()`` after ops verification
> +    - Return ``-EFSCORRUPTED`` on failure, aborting recovery
> +
> +Patches M+1 to M+N: Implement validate_item for each item type
> +    - Move existing validation out of ``commit_pass2`` into
> +      ``validate_item`` where possible (e.g. ICREATE field checks)
> +    - Add new cross-region validation
> +    - Order: simple types first, complex types last
> +    - INODE validation is the most complex (fork format vs region size)
> +
> +Phase 4: Cleanup
> +----------------
> +
> +- Remove redundant validation from ``commit_pass1``/``commit_pass2`` that
> +  is now covered by ``validate_region``/``validate_item``
> +- Add ``ASSERT()``\ s in commit handlers to verify validation has run
> +- Review and update error messages for consistency

Why is the plan for splitting scope across M+N patches relevant for a
design document that will live in the kernel?

--D
