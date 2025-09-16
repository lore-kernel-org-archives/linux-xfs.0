Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9E030748A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758022487; cv=none; b=UvhbsTLZclhgNSByxlsZ7d6ObIVh7CED4eCTfoPrHm3cckxB0BlHL/C2Pp2V8RFAiav/yXcBpXImt0R2G2Z+znnTj6/Paw+vQw0w6ZrjZNQnjMcc37rYwK2o9EvjWM+USEwiiCyR0S/VXPh9u4NxKGQ1QdHS75kF2CIl6FoFYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758022487; c=relaxed/simple;
	bh=4P7Ayi7of29rflk1KcVICpxRZEgxj9tsG4/I27pA6QQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bk1PVw/A6LNT8VTIJpahTKoV3azbgOQg6d2NyINikIzgla6Q84CzV6/DuaZ3oUgkC1pXEA43MNwoqCdgxL/j9w4jEUYVtfzU+xfYhscuvkaI190wNmJIhMy6VwNS4D0fHq6+e39LFsKY7ivk+553G7bz53Ao7HuBqehUoDNCDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yw1GVTkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yw1GVTkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C9C4CEF0;
	Tue, 16 Sep 2025 11:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758022485;
	bh=4P7Ayi7of29rflk1KcVICpxRZEgxj9tsG4/I27pA6QQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Yw1GVTkhYn23x9JZUeuL+jQH4TOnzBAOe7skOD5F9pRqxZWSofL3J94vmD8t62MfZ
	 uRV+hKua76eWMM09eR9wTP34soWaGrUJRX2/xeSTzQIbVFeT6qXb5oHrBByNoeP9lQ
	 LvwrhTWluYUizetCf4ywymfNfc68LHnHer04yVCp9eRFo0Tw9X/EDLsB9QPR4ApOIX
	 QNSQSWr63Uok6fT7KHdIKBoO7m39xZ38x/PZ5/imHLLTFNOUh0h7wFGBaVziyCRJbh
	 F50Yl49/YqiqQYTYRen9d28CLilMdGwhN9RGX6JQETCjtgNXQYFjC734mbvIih+3I0
	 rJYLnqZ3YM18A==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Subject: Re: remove most typedefs from xfs_log_format.h
Message-Id: <175802248477.997282.4586556987348072736.b4-ty@kernel.org>
Date: Tue, 16 Sep 2025 13:34:44 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 15 Sep 2025 06:26:50 -0700, Christoph Hellwig wrote:
> this removes most of the mostly unused typedefs in xfs_log_format.h.
> There's a few left for which I have series pending that will do the
> removal together with changes to the area.
> 
> Diffstat:
>  libxfs/xfs_log_format.h  |   83 +++++++++++++++++++++++------------------------
>  libxfs/xfs_log_recover.h |    2 -
>  xfs_extfree_item.c       |    4 +-
>  xfs_extfree_item.h       |    4 +-
>  xfs_log.c                |   19 +++++-----
>  5 files changed, 56 insertions(+), 56 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[01/15] xfs: remove the xlog_op_header_t typedef
        commit: eff8668607888988cad7b31528ff08d8883c5d7e
[02/15] xfs: remove the xfs_trans_header_t typedef
        commit: 05f17dcbfd5dbe309af310508d8830ac4e0c5d4c
[03/15] xfs: remove the xfs_extent_t typedef
        commit: 476688c8ac60da9bfcb3ce7f5a2d30a145ef7f76
[04/15] xfs: remove the xfs_extent32_t typedef
        commit: 7eaf684bc48923b5584fc119e8c477be2cdb3eb2
[05/15] xfs: remove the xfs_extent64_t typedef
        commit: 72628b6f459ea4fed3003db8161b52ee746442d0
[06/15] xfs: remove the xfs_efi_log_format_t typedef
        commit: 655d9ec7bd9e38735ae36dbc635a9161a046f7b9
[07/15] xfs: remove the xfs_efi_log_format_32_t typedef
        commit: 68c9f8444ae930343a2c900cb909825bc8f7304a
[08/15] xfs: remove the xfs_efi_log_format_64_t typedef
        commit: 3fe5abc2bf4db88c7c9c99e8a1f5b3d1336d528f
[09/15] xfs: remove the xfs_efd_log_format_t typedef
        commit: 0a33d5ad8a46d1f63174d2684b1d743bd6090554
[10/15] xfs: remove the unused xfs_efd_log_format_32_t typedef
        commit: a0cb349672f9ac2dcd80afa3dd25e2df2842db7a
[11/15] xfs: remove the unused xfs_efd_log_format_64_t typedef
        commit: 3dde08b64c98cf76b2e2378ecf36351464e2972a
[12/15] xfs: remove the unused xfs_buf_log_format_t typedef
        commit: 1b5c7cc8f8c54858f69311290d5ade12627ff233
[13/15] xfs: remove the unused xfs_dq_logformat_t typedef
        commit: ae1ef3272b31e6bccd9f2014e8e8c41887a5137b
[14/15] xfs: remove the unused xfs_qoff_logformat_t typedef
        commit: bf0013f59ccdb283083f0451f6edc50ff98e68c0
[15/15] xfs: remove the unused xfs_log_iovec_t typedef
        commit: 3e5bdfe48e1f159de7ca3b23a6afa6c10f2a9ad2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

