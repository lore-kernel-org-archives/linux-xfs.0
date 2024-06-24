Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC381B964
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 06:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719209836; cv=none; b=FSSqCMZ6v313In20uTXu/A07irfjJg4+u/f3MX6ngOqV9ZktYpkzDGf8d0P915wP5JztO2BiRKbQItz+ZGqTDJsdVl1yMwK80LTHdq0Y9b/BHrwMAFJafExB9+no6s0yuamoDC02wFkZKX9pyEC7CfCyqCDeQOnjNOydycVvxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719209836; c=relaxed/simple;
	bh=SEhoUCR9aBCO4iTQPQl5C3VcEiVzQvuq0D+TWbN9JH8=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=ft0woMkFiS0mRSJIleZaGYi0aMzGy7JC11asDIawGqOf5BrG5PxQot9UhDKqT/xA/9uXCDjdxw9yw6vXWs3/uBalh4P2XMRNmSEq+4iRNTa1BKZ5RzQqQ4eXwsJfyMM90dD/Tlpeiwgq9WZkwOlliTo8HjEvCFn2b2sWBk9iXiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pl+RjV+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pl+RjV+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4683BC2BBFC;
	Mon, 24 Jun 2024 06:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719209835;
	bh=SEhoUCR9aBCO4iTQPQl5C3VcEiVzQvuq0D+TWbN9JH8=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=Pl+RjV+b9vmjAtnEaFb4LzC3QgMS6o/smPuaTAk2QWfHLwhgffb2C0yuBT8Pf9PFO
	 obApY0fAT9lr7OIXui9UcCwMzP6JTiUlnoTP7XDeaQUoZxrYy1WyKG+vdBvyD9WPCh
	 eVk+wNN5yQ+NFBSsHGrShGXtvs109VfLlv64yQGQBiATUFohqz4N5l/72F0Rs3smz7
	 c2tXrA99sEqMMTc6qLjt0vXPs2Ra6zvFkzwyPE21QPc/6P8cuNUXvHKqmhaG1PqP4k
	 3VOvHd8XNYFcfapomrEIoi0nUUn3cI6B7bp/5ACG63cb+b5Sz/HhgYli2yyUSUVlIf
	 xt7EzWYT+02xw==
References: <None>
 <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
 <8734p34uyp.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
 linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: random fixes for 6.10
Date: Mon, 24 Jun 2024 11:45:50 +0530
In-reply-to: <8734p34uyp.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87ikxyooew.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sun, Jun 23, 2024 at 07:18:19 PM +0530, Chandan Babu R wrote:
> On Sat, Jun 22, 2024 at 08:59:00 AM -0700, Darrick J. Wong wrote:
>> Hi Chandan,
>>
>> Please pull this branch with changes for xfs for 6.10-rc5.
>
> The new patches mentioned in the PR will have to be queued for 6.10-rc6 as I
> have already sent a XFS PR for 6.10-rc5. Can you please rebase the patchset on
> 6.10-rc5 and resend?

Darrick, I have cherry picked the patches from your branch and applied them on
6.10-rc5. The resultant git tree is at
https://git.kernel.org/pub/scm/linux/kernel/git/chandanbabu/linux.git/log/?h=xfs-6.10-fixesD

-- 
Chandan
