Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEE4259CA9;
	Wed, 18 Mar 2026 09:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773825228; cv=none; b=COFnDHAT7bp7dnK2HB/k2CsLp925muAcWCFHS9obxx8bJFQSbxxCpQFjqLpDQngPeXQk/Hcoc4qt1L8UU8ODbjluxCRr/y6kuqxfdjTEDB2WcyMzlQtHC1xZ1Z4KQw1IMIFxXIURWGdKg4Cqw84wOLIpZOMCupk3kC65cXBsIqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773825228; c=relaxed/simple;
	bh=OF2A7xe8ldRCTf9tSG9WUWI+Gx4Rd00mVFvL14yWztY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7XEE7VElY1SmEzEGTW7X42I4k1TZXqsSBU0fPwVO7vQEhK12Fl12NiEop0W8tO1GlRqLPndBLNF3xnJ8WNnVyDGDP/fSZSNv7XzsKP2VoK+vCvpEx4/NKHidP2mjKKM5HbQl0wHscdgiZ6euuZcbAWBD54MlpQqSP1/z6XwWgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krNfvozf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krNfvozf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB8CC19421;
	Wed, 18 Mar 2026 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773825227;
	bh=OF2A7xe8ldRCTf9tSG9WUWI+Gx4Rd00mVFvL14yWztY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krNfvozfS6lx6VQ4ms57uiafFu8hGCANcoQCqwUeN9LX4MtdeotSLUQJ60FDYmRZ1
	 /mHU8kDanrHlGEfeiT2gz+73a2rAOKAe1IPSukpfbnr9ASmXzCqgg/F4DHs28XlHSP
	 Ji2kF2UqhXcwFfME9j52Y/dpdeChBdCbz+SIP1imNSlm4g9OtXL3LIsz+7QBkBKHEY
	 Nq3CmSO5yiGN3AnlP+/X5wsjN1hCUEVZNR/9TNlYH4WmsiMOLVkQFdW0trtVs8FSD/
	 w5wY7Gw2O8vl+1aNZgNbCSni4MGW1h5JukSw/EMcmKSSntE//hr2bJOz7MxPYOOCqn
	 /PHNZKYIRVp6Q==
Date: Wed, 18 Mar 2026 10:13:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com
Subject: Re: [PATCH v4 0/8] iomap, xfs: improve zero range flushing and lookup
Message-ID: <abpsdcySytW3J_2G@nidhogg.toxiclabs.cc>
References: <20260311162502.192375-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311162502.192375-1-bfoster@redhat.com>

On Wed, Mar 11, 2026 at 12:24:54PM -0400, Brian Foster wrote:
> Hi all,
> 
> No significant changes in v4. A few whitespace fixes throughout and I've
> added some R-b tags from v3 review. Thanks.
> 
> Brian

Christian, giving the majority of this series belongs to XFS, are you ok
if I pull this series through XFS tree, including the iomap patch?

Carlos

> 
> v4:
> - Minor whitespace cleanups.
> v3: https://lore.kernel.org/linux-fsdevel/20260309134506.167663-1-bfoster@redhat.com/
> - Inserted new patches 1-2 to fix up zoned mode zeroing.
> - Appended patch 8 to correctly report COW mappings backed by data fork
>   holes.
> - Various minor fixups to logic, whitespace, comments.
> v2: https://lore.kernel.org/linux-fsdevel/20260129155028.141110-1-bfoster@redhat.com/
> - Patch 1 from v1 merged separately.
> - Fixed up iomap_fill_dirty_folios() call in patch 5.
> v1: https://lore.kernel.org/linux-fsdevel/20251016190303.53881-1-bfoster@redhat.com/
> 
> Brian Foster (8):
>   xfs: fix iomap hole map reporting for zoned zero range
>   xfs: flush dirty pagecache over hole in zoned mode zero range
>   iomap, xfs: lift zero range hole mapping flush into xfs
>   xfs: flush eof folio before insert range size update
>   xfs: look up cow fork extent earlier for buffered iomap_begin
>   xfs: only flush when COW fork blocks overlap data fork holes
>   xfs: replace zero range flush with folio batch
>   xfs: report cow mappings with dirty pagecache for iomap zero range
> 
>  fs/iomap/buffered-io.c |   6 +-
>  fs/xfs/xfs_file.c      |  17 +++++
>  fs/xfs/xfs_iomap.c     | 146 +++++++++++++++++++++++++++++++----------
>  3 files changed, 130 insertions(+), 39 deletions(-)
> 
> -- 
> 2.52.0
> 
> 
