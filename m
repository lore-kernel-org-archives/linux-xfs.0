Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929E3A9D9C
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297765; cv=none; b=MbKbacbSEsSLvFXk2u1MnpKDw6HYrkP57kBDNMMEZzQNavWmxePvbOsxV3DVPE8h8ibTpREgfdK0mI99mk7ZNnN9u3M70EnLvwGYu6m+T6YsjTltzpnE9I85m/qKzuWP3Ea2IQLoWqbJT+gheGHpAD8t2/ppsVQlDuuN2LGhT2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297765; c=relaxed/simple;
	bh=oxgc5uuK7nOByKGchzX0VQLipRoZc1RHS+o6VB3tChY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fT3pLPOJGdMIa2zUhTusMFIv2IO3rghdcr34c3IqfRQF+TqcvoIWvD+0FFlW63tqOyqvnLRMxtOFaqXsnQYt8mlrk01MdkCZhQ5s54wYkrpR1gf03rRUHrmZ1AywXUOUnFUl9nZF7Kvm1N2n2XVn7FqSnvBjg2woAEupx/fsnyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofhkVEz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofhkVEz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C2B1F00AC4;
	Fri, 21 Aug 2026 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297753;
	bh=jWmf44uxVF1HMpX6T8krmMcbxcdiLpZxfs0ZIY7RWss=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ofhkVEz8R9MlYqJGpa9ilBH8wLkTw+CWHCHDxObf857K1nJ+YaH1KQ8jml8vGhfih
	 qqHChFmhNCJ4zYH5R7FgV50STXFFdFNWffBQuWKHoE8NLbqyrIgVYh1TlHG0plo7M/
	 0kKdRjtlOORlmvHZDlnYZVCX+kTm7UHC13ojIpmXRoj+9r3XZ4KBFfrXSWjWDoSvW2
	 BfWAOmd2TzFNU/uxrDp63JDoar8vWa7lE5IGGvtoGgfrZK7c0FQx3yMb3f05AIg66w
	 VgcSXu4vKsIcJWRuy8qDxJRDsFRr6iuRwpwdQx2FdowdJOkYRuAmje3VU0OB3InBjd
	 /UrKKciUDe/Iw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260810153848.466459-1-hch@lst.de>
References: <20260810153848.466459-1-hch@lst.de>
Subject: Re: [PATCH] xfs: use inode_init_always_gfp with __GFP_NOFAIL in
 xfs_inode_alloc
Message-Id: <178729775204.580975.8215161940902292516.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:52 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 10 Aug 2026 08:38:38 -0700, Christoph Hellwig wrote:
> Just like the inode allocation itself, allocation of the security data
> inside of inode_init_always(_gfp) must not fail here as we can be inside
> an already dirty transaction context.  Note that we do not have to pass
> GFP_NOFS explicitly as we are already in a nofs context when in a
> transaction, as seen by the call to alloc_inode_sb.
> 
> Also update the comment about this a bit to be more clear.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: use inode_init_always_gfp with __GFP_NOFAIL in xfs_inode_alloc
      commit: 4e07cd78e159a8c6b028e5dc5f4e5bf06067d969

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

