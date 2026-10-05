Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D584825C8;
	Mon,  5 Oct 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223595; cv=none; b=IQij1ZHHin3TdrZVgqXHyvFI9q94ZsYwjLn1O5yut3JkYtEqcd7kKV7ecZ51oRw3Gdf3bM+gm2vK4bjS3NqiAS45hB1UROKqxcerQX2kmj3MPH6LgTbvK9NQrFNxja/8yvo8Mruk3OFBo+z8233D52x0Dbreesy5R8uBNkOf9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223595; c=relaxed/simple;
	bh=Eo7yLLt324Hd64jAabQOGkKBR6T80PF6y81peiSPRyg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ETGmvG0X8DEl42eE6VQe2lrDB1q+tE6Bpol6AVip1PoiNeeQBk/9FjyvIwxa2Yy1P8NKMShVSziNUycfPqaWWxSxCLyVWi4JI/IXiHusWRvoEyBXAZrPjVkj+T8sI03Oa6D5ARBYzMQbsETdFoucfF4cnLk329Z4qOe30YJbhu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xs1g5ucD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xs1g5ucD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FF91F00893;
	Mon,  5 Oct 2026 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223594;
	bh=yg9qPeAA/6tsRgAZE47l1gFhzikar4FMalu/vxb6zQU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Xs1g5ucDbuNENkwl1SnJmqQ4VXo7tsOHuy7a/WwAY7GScUvl/IweX5h2RUlzkREU9
	 OQjFcvzLOo4xGJkuIbRIxqg7OIwyRADyRJGEhz7qDgzgrvBBb7mL5QsbyC06eJltST
	 Ic+bIpF/XxAwYQrciXp4lQlLLAOcGKUBy9VqptP5HXOBuipG0eDVpnlPK+zDVrKMdz
	 9IVfldeL2qtLQ3ihPaHyhk6DGC2VO1EhkJkt3LVSgvPxIWT/B8qx3ZrNDg2gYXBnWp
	 VPvbXzqJhvTelBLzm1BO3KlB2zEqKjEz3oXSyg4jB/4RtWBsx1aEm5CP6IHkyYhB0P
	 0E9NdZgcPuXzw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, hch@lst.de, dgc@kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 16
Message-Id: <179122359284.102066.7926822053908413946.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 22 Sep 2026 22:57:26 -0700, Darrick J. Wong wrote:
> Here's a sixteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: add RVB tags, integrate some review feedback from humans and LOLLM
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[01/13] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
        commit: da483b8a9c2c3e7b23655699680feb57a194000c
[02/13] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
        commit: 244425cf63d7e3a0ff5736b41f0e0afe807f7031
[03/13] xfs: fix buffer overruns in xfs_ioc_attr_list
        commit: 0b9081a774ee7b9dff1e9ac3765b73c1d6bba5b2
[04/13] xfs: clean up after failed metafile relinking
        commit: 07c73d1f0be610a8c14a2d73ed5cbda8ea9749d7
[05/13] xfs: pass xfs_trans_resv object to reservation calculation helpers
        commit: 035d27cb2ae7f9a2f2e2625671086995c6b45433
[06/13] xfs: fix xfs_rename_space_res for non-pptr filesystems
        commit: a800b926346c3aa2482421f5c0272280ee7d32e8
[07/13] xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
        commit: aafe21c23ad8263251085291019d8860ddc51da9
[08/13] xfs: add missing healthmon trace strings
        commit: 23067b4f98f536ff3341fde04d52a331b2ebdf76
[09/13] xfarray: don't crash when sorting if array element crosses a folio
        commit: 329750292e9dfbb594b375d7b30cf5ddb58b7bb9
[10/13] xfarray: don't allow users to unset in the middle of an array
        commit: 3a94b91aef22b6091cdad17160105070cbf2d509
[11/13] xfs: don't allow sorting sparse arrays
        commit: 76ac15cafb29ef11098e3db7fb955922f48c823a
[12/13] xfs: simply the free space btree repair code
        commit: ebd528d1987e133fd33f51f51d76294c9a4cc196
[13/13] xfarray: warn against sorting arrays with identical elements
        commit: ddeb5fe2d8a8645d033d868117571649184d64ab

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

