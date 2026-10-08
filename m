Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD74A4980;
	Thu,  8 Oct 2026 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466358; cv=none; b=ntL+cf8wSkYsTQyJ4GZDQfeHplQmSVtm4OGh73LKvGpYtgGOgOzh73piW4r/6jOLdrdwrTc5jiaCWIIYqTPaaDGPkn5hlaG5FMz1nRzLTixqatG1N8LGNXOLQsb4nsICbZdDFrJ2LJoa87e9Onw6hECjjiJW+6/FOo1+J7s3NsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466358; c=relaxed/simple;
	bh=bnDSHNcew5tL35tbZLVcXnRvc9OlVjjYMr72G8puEVg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T9BqprHMoAy51ytt2bWBNGsyIizxiJvYFKNKeq3WRkck+Q9RsF9KszmfYiVsXOjplMpbL0cLSxmHg3P9KzGGPvYQqjlkcTy1FURdWrIqxfsK5Z2qErq0JCpTZk+DNgYWEfTAeYA488QbxIkDykWcQ9VTB1tqp5BKqqNrQWL4r34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5ZTyfdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5ZTyfdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213131F00898;
	Thu,  8 Oct 2026 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466357;
	bh=8+i8inJM+y2RHK3Rwrs6Z4UPYI5MVZQwvCmHqWA/+50=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f5ZTyfdbLIeklI0/JuJiC2nOAbEGgYikV4kUX9YT6L5ysmaYcS5qY9ElKkIaIIAqJ
	 R+5dCkzwmiXgDWDiyxFIVNM8CLDNi9BcLhZ0NCRxgqtdH8twdNBZcRUi2Dhky2x7K0
	 C6DeCrBGP5018qulWHG5TJhaVR8ZlvLha8XyOnFWJ+7ilNvUgLBxtVupRPXuVwjjHN
	 StnaJheYIgjCU8FIxlEe9m/+UWnd9yON8LRWlT5GA98pAgkWm3lGAAzFscfk+WjG18
	 nvQI4STrW79/4ftd2dwvsDchFvu3ms+YFZvP9q/hz0LRLwowA0VeEAIWXcTttG7A3j
	 uVCVLRJSnJztg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 19
Message-Id: <179146635581.378461.13705675093577134310.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sun, 27 Sep 2026 23:15:58 -0700, Darrick J. Wong wrote:
> Here's a nineteenth batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: be extra careful about replacement directory construction
        (no commit info)
[02/12] xfs: improve dirent bounds checking in scrub and repair
        (no commit info)
[03/12] xfs: abort dirtree repair if the live update hook dies
        commit: 07732dea4f5d0410e1566b81a58a1154bf9dcb29
[04/12] xfs: bail out of directory tree repairs on error
        commit: d83ca4e7cc65dce6a02fd3427cefd174517657a3
[05/12] xfs: fix revalidation of xchk_dquot_iter cached mappings
        commit: 6c64d650460b455980a6023d43bc6c8859c1cfd2
[06/12] xfs: don't repair fs summary counters with garbage
        commit: 22a8a7501c0146dba4ce99b8256975ffe945125d
[07/12] xfs: allow softlimit with no hardlimit in quota scrub
        commit: 342c2e00b3a99099a7088f7b8c8f075670c603a9
[08/12] xfs: assign an owner to scrub_stats_fops
        commit: fe67a493c7a76cf75556152af24285a114f69d34
[09/12] xfs: fix lost errno returned from xfarray_foliosort
        commit: 8c4f172c246717b1420f138a159ed15c315a58bd
[10/12] xfs: fix skipped inode mask handling in iscan
        commit: 63341d4af16fe850716b454fcd18990590d07d97
[11/12] xfs: don't proceed with xattr repair if the live update fails
        commit: 833f98b3be45bc7c6ce4c87bdc4892f546ab72ee
[12/12] xfs: don't fix the directory tree if live update fails
        commit: c8226f3d1a7eafe472addc232689e9c9a0c36a1c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

