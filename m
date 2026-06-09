Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F423CF206;
	Tue,  9 Jun 2026 07:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989969; cv=none; b=Le+U1SbGVmdStIqrGb6edW52mby7cwM3MoZ8FjcTBwSK9juVjampPqvuZKcXkh4lPDkSah0CJ4ch65dsjPLZYHeB8zv1VDeNG4Fa+V5UPRXhIjDZ7CndPZ90mDfBF0KCM4tATQedK6RlHheGENiRA6bJrfonqJnwYbJH89qR3II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989969; c=relaxed/simple;
	bh=Kt03EgXCsWGJyvGX4RfWseF291hwgWGerOgolggkbKA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=G9u/7EfdIT7lESLu9du2+6TaXvtNvG2VhAHWjtJgUn0n2XBg7qkVXOdeo7wecBlxiSbcYq3Z02DELFQEPFNaTRAb4YVWL7jl5qQqg2+sSA/7Dd0Q9agwyz1XnUuBtN9TrHClF/ECn+wYXx0B7grBQ4FYsrTjWmrOJbDgHE0m+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+vP+p/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+vP+p/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60E61F00899;
	Tue,  9 Jun 2026 07:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780989967;
	bh=8eZbPjEd/vfEuk81iaU79bASiFUW46+zaHV7Qnirwvw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Z+vP+p/O8xRLo8uKi9Pyh0LRG4cf43d/krgvzdJ5JJsp99ZKmSFvDhaWUgwscwBfc
	 L6O0hBnNVD+Luim+jFtskfQgRyaZh2owrs/E4lAuyjZ88S0nohyy0mCzX93py2CsP8
	 k4K7+GCyyPTyx+d9xo7S6JCiSjHnxXV4/Tnc+YJyh7hVRXW3RU34cl2txjer5KwFS3
	 h0qMS3VK2bHIgPdtUl3sg66SRcgYX5327D/F3dQa23mzzHkWesioWRbhFt8s2Iuend
	 lgSOhpVX/nXgVcHCKSEgZJu34ngCjbpNSG73JiyEkT8V6hv93H7GsUjPPHuF5zcEMI
	 WEOYiGF5u+Pkg==
From: Carlos Maiolino <cem@kernel.org>
To: Alexey Nepomnyashih <sdl@nppct.ru>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, 
 Allison Collins <allison.henderson@oracle.com>, 
 Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
 stable@vger.kernel.org
In-Reply-To: <20260603204148.232530-1-sdl@nppct.ru>
References: <20260603204148.232530-1-sdl@nppct.ru>
Subject: Re: [PATCH] xfs: fix unreachable BIGTIME check in dquot flush
 validation
Message-Id: <178098996557.72840.6449094357309834636.b4-ty@b4>
Date: Tue, 09 Jun 2026 09:26:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 03 Jun 2026 20:41:47 +0000, Alexey Nepomnyashih wrote:
> The dqp->q_id == 0 check inside the XFS_DQTYPE_BIGTIME block is
> unreachable because root dquots return successfully earlier. Reject root
> dquots with XFS_DQTYPE_BIGTIME before that early return, preserving the
> intended validation and removing the unreachable condition.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix unreachable BIGTIME check in dquot flush validation
      commit: 03866d130ed33ab68cc7faaf4bf2c4abef96d42e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

