Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DD73C276D
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415564; cv=none; b=uWd16Fr/2rHmVXjWeki/gBc9rfFaVWiD29GuNb/28/2gPcER6dgnVJXj6poIzW4v/u4/K9DoNryVysTDfoCVLcGjYwsG7m43FNjtEl+Ym6w5ZLVjTfBbGyjPzC3GOKx+3Y7tFphVm49GBG5FK0gnWerqjpsrK0CjhUS7If+VO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415564; c=relaxed/simple;
	bh=x0Qx1O46VYrtVpvl3bTNnUUoip548JIsMUxRsEMvOgc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KekEQSPdSFpoteOTT/7mA1x+sal4iIzrmlIUqW+SqGUsT5cI4D8ocO8aln/nVoRuyzqdeWBYwtnjtHTbc6IaXr9fgwxjXAakLFhgDBoNxZ4EoY1JleSrxY+GI4FG/SKxl7WKY/L0cjG7fchQEme1pcC7HGs9tHNh52HvhEQ8AXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iD3k5l7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iD3k5l7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE271F00A3D;
	Thu,  3 Sep 2026 06:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415562;
	bh=9DcDZUop4gdkZ9sXtrSBUR5LiGBnUCzBnTQm2rqL2TE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iD3k5l7OQ2se3ht3zwRKtfoh+N6M5X8feS3NF02FR7hqA5wRLKTTX240Mv7qkEoLW
	 8zlig4DZtLMBdRuuX6blAxLQBM1shPG6I9FTLj0tCfsscGcYaI4YW3gLrBphRJ8ZHA
	 VpmYecftu8+eJCqg8OzZQbe2VsjQJ28uG7jgz1jD6WSGqVcGIhnUeyOCad0GZH2yU+
	 RnTSYl3dbJegYZPa8i3DMurNi2MrB3eoCthTL3AMtZTcE8lC4oCvWiV38D5Xo6pLka
	 KD+vcGPas/wVN/UsQoeRB7yZRgPXWhq6t2YIyxkfXNJfa2jp1xaS0cDMe39Bi+BA57
	 aVQx2DjDvRSIg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260729130320.2282183-2-hch@lst.de>
References: <20260729130320.2282183-1-hch@lst.de>
 <20260729130320.2282183-2-hch@lst.de>
Subject: Re: [PATCH 01/16] xfs: remove an outdated comment above
 xfs_file_ioctl
Message-Id: <178841556166.1198521.16511170653622955307.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:01 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 29 Jul 2026 15:03:00 +0200, Christoph Hellwig wrote:
> The return code sign flipping at the method boundary is long gone in XFS,
> so remove this comment documenting an exception from it.
> 
> 

Applied to for-next, thanks!

[01/16] xfs: remove an outdated comment above xfs_file_ioctl
        commit: d7cf5c006dc3fcc9171939da88fcf6539d37bca5
[02/16] xfs: rename xfs_ioc_swapext to xfs_swapext
        commit: fbbf446c322a5e20aa6ecdfacf02b9446df4800d
[03/16] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
        commit: 098a0ee1b45f0f09d77b517a9e34ecdada13c9aa
[04/16] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
        commit: 6c015db4e9d9bf562a1dda59f71dbb7822c0e4e4
[05/16] xfs: split out the handler for XFS_IOC_DIOINFO
        commit: 4b18c2835c83f9002484d3af8362b31d0d374eae
[06/16] xfs: split out the handlers for XFS_IOC_.*HANDLE
        commit: 80e352a27758e0666a63c85feeb3277466853a1e
[07/16] xfs: split out the handler for XFS_IOC_SWAPEXT
        commit: 45af54ac546a39f0fb40a6332cd4b71170b72e41
[08/16] xfs: split out the handlers for XFS_IOC_FSGROWFS*
        commit: 7c98c4461679b22639f72207b8a917c6af516402
[09/16] xfs: split out the handler for XFS_IOC_GOINGDOWN
        commit: 319acdc8b39e6a4563e273a7710977caca184061
[10/16] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
        commit: a443db96c14b617647e4465fa612162256be39ef
[11/16] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
        commit: 2b7755e216c7be0f3ac6e74ad3778b90afea8c4c
[12/16] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
        commit: 3368d51225e86fb58a527e2d216653194cb6d009
[13/16] xfs: cleanup XFS_IOC_GETVERSION_32 handling
        commit: b193b5f5b12402ddcd77a3208743fecc91c0cb0e
[14/16] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
        commit: af563225303d1c747db0edeb14b28172b23d767e
[15/16] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
        commit: 490ada21265049883c3f64f825df3798bd4a655d
[16/16] xfs: remove an extra cast in xfs_file_compat_ioctl
        commit: 0a57de878fcceb65abd67947ddd053ac6b9d573b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

