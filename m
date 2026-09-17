Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F564B7155
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 11:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643125; cv=none; b=o2aOr8JW3Mn8kRbtkshOrojmqQShJjY1iALU4SkF4ztujbpwVY8sruxRcOTRrGCjXd2qUxQf8/PCrDkpOxD0kj6s/nYG1FYsL5zXgqj0V9OlLCiI0uRkuHiQmb3X6/Oqrzho1SuHQ6AjtlV14UlO3sL3ylbsJNuWLlwewzXvQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643125; c=relaxed/simple;
	bh=WpIZ6G5h+o+HbW0c4ADJGo6hms3YlbteoHbIyInnZTg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BwsLoVPwwHtkcgzUU5hXWT17J21BIXqqXugq3OWW+/OhbO0YzOJc5ClSjqm1t1aixPSA7i7mbWQdkQi9zPDEeumRxcC7IlJXUIhQJR23t6qIEapUMPOn0ccaJpmhR5v1UCbfX9d1e627eG3poJABViRRiwgsgCcppMIxqu0RuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9i2ymbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9i2ymbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A71F000FF;
	Thu, 17 Sep 2026 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643110;
	bh=ZeHj+bPnhTDC6GHxt01UR43L9+VoxBHxPj0EUMf4dvA=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=g9i2ymbbLoDon7YPqCB87CJ1fi8NXqssKfPHvbWRtq9dBVOMCFUfuVNwjB2nQ+Nn6
	 6Q3or8ahr37qPakYNgRrSGZVwZKwOpyKb6SWEjR8JSs2J0uRgzkfOhqaxsUpTEg/bo
	 7GdZRYd7NR+BdoMFbmf50x2/Ukd6M1zNO3Tv8+UAfIzEcfXyBQO2EFeISTXPK1PTk7
	 OxY07bNp6N1OwShBuVzrIwLDlp8t316ge9C6EAD2+OozOoLBZqJs/+O7+zkvjo76cM
	 jpE7/KIkHN2Hqp9Koqy+6ervZUpNXVtkdtEssDYWWRx/n+L3F4c+hqV3eVV73eg+s4
	 5g6d105i3+6Ag==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Subject: Re: [PATCH V2 0/14] xfs: remove unused arguments from many
 functions
Message-Id: <178964310975.16287.9435159881122202117.b4-ty@kernel.org>
Date: Thu, 17 Sep 2026 13:05:09 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 14 Sep 2026 17:28:46 -0500, Eric Sandeen wrote:
> V2: Sorry, that was stale already. This is against for-next in
>     https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git :(
> 
> Seems it's cleanup season lately on the list, so figured I'd play
> too.
> 
> This removes unused arguments (mostly mp) from a bunch of functions.
> 
> [...]

Applied to for-next, thanks!

[01/14] xfs: remove unused args argument from xfs_attr_node_lookup()
        commit: 9821d9dfca71e745fa2c7f87aa27e2c97753ad62
[02/14] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
        commit: 168757e7d7092076b263027d113bba2fba23303f
[03/14] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
        commit: 0d498f3385e51a0a8eaac71aab6736b5a8cd4049
[04/14] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
        commit: 4f4f0e78aab58e1bdaf97758e5801c6912f0397f
[05/14] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
        commit: 383641abd3cc89e2b7422f59ebccb89d63404bfa
[06/14] xfs: remove unused mp argument from xfs_parent_finish()
        commit: 76a2796d4a671d71bcd4baf970accce61608c3f5
[07/14] xfs: remove unused tp argument from xfs_rmap_update_hook()
        commit: da86bd00b8532bf304dd32c51d0ddb4f57086184
[08/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
        commit: 4e7d4c62ab0e2e68764e1501588d1e21b23b5645
[09/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
        commit: 0f08a3703f5f5091f7bada957500641c96528369
[10/14] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
        commit: 1eaea71e8b998be7d8f745040b186df8d73759f4
[11/14] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
        commit: be0168dffd6911621bdf5e0d20b958c636685b87
[12/14] xfs: remove unused mp argument from xfs_verify_dablk()
        commit: 323b208c3c38673f31379db2eb4b07acf740d825
[13/14] xfs: remove unused mp argument from xfs_verify_fileoff()
        commit: 06a83d006c8cf90c109a06b0c749194fd2301ccd
[14/14] xfs: remove unused mp argument from xfs_verify_fileext()
        commit: 1c1058646d3bb5fc1b8ca4504c898e9dce520407

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

