Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD472DECD6;
	Tue, 12 Aug 2025 07:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984008; cv=none; b=dVjk0IQK+aCIBrwS9OINu5tF7UWoFjtEdCDmMGSp52jMKjsOUcwG4i5cyD5+Pw2LGQ2LkGj4w51iYF3xmE+Uw5NsR3CiG9Ad/MepITohy4EVaq8P2wyGJjrPKF98LzYQbD2naEqC20Fz0O4zDdQ33JOT5l+YPLRJrwHaSk82oYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984008; c=relaxed/simple;
	bh=wADw7EoH7qs/Ki4GSflKEDW8OpxZtbQMM+kQ9qro7EQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hno5jkzSAkejUXSWtiMe9D4fykl3/iMVpeSzEBvQu2f054nog3HGrNIBFT3/4Q7uBeKzFnb74zYfKb/i0ojKTTIAAQmMXipPQtahdMohQkJ8PIa9mAr3ns1PXao47iIPtJjnR5xrLHdwPYEUVKPL+YU7AKzUtIH7SysQChDeBwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiEe0czk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiEe0czk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF9CC4CEF0;
	Tue, 12 Aug 2025 07:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754984007;
	bh=wADw7EoH7qs/Ki4GSflKEDW8OpxZtbQMM+kQ9qro7EQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=EiEe0czk5jdqYkDQ6bvLB2pZdQjhBr88PCXqv/sHmMS9wfxIo6JfingVkLDTRlaMQ
	 aTXiY3eyKN8oiv+pDb6WyUqTTwL+Wnrl90Fv49uG+gXJXmL9TRwuuCc+tb/+Z96zKS
	 AeyyNP5OmokBF+mwdGBNTBlXI9AVpymbHk/YBhDKVmN/aFXmkvY6jyyY7whREsbUz/
	 87qgxFl9nCCoU4bgWJdfE0dvLhUAt4if8BYthidpkoxIXmHqIAroufLoQMql2IUCTE
	 mttDFZtTbcgecd6ajJZP6QQKbdsUjWQVMZyXIctc3Eg5+m9/4bD0VzCaw4uZt4qR8V
	 FEMOCQ6iVRKyw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Cc: djwong@kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20250731170720.2042926-3-aalbersh@kernel.org>
References: <20250731170720.2042926-3-aalbersh@kernel.org>
Subject: Re: [PATCH] xfs: fix scrub trace with null pointer in quotacheck
Message-Id: <175498400628.824422.10129480795434714985.b4-ty@kernel.org>
Date: Tue, 12 Aug 2025 09:33:26 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 31 Jul 2025 19:07:22 +0200, Andrey Albershteyn wrote:
> The quotacheck doesn't initialize sc->ip.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix scrub trace with null pointer in quotacheck
      commit: 5d94b19f066480addfcdcb5efde66152ad5a7c0e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

