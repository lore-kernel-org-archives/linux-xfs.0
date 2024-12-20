Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A524441C6A
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734701599; cv=none; b=iyYeNcwjjrqAqrVyi87zRiyG63jtlTnn24tFq6XhNS9guWT9K6k9nmr8t+tZsJes5A0I8mqppuGBCxEnaJb9c3JpvaFhB/Htnrgo4POpkV5XtcFmkFpABUX9tDLFhx17sVvKXgm1PwQ0gFhohtjKsbxwXlwbBbMjFXLGHhEHEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734701599; c=relaxed/simple;
	bh=JTbEZ2CErS4NkoX/2DIq5Zn/k+X1Nxt1YEAxyXZ66wA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=mk49nd5DvmmTZKB1ZM9ChoRCXHjLcjtB5PP077mJFR5jnPKY3RHdKrTkSn039GZ0Tt4BRpazq/ibmk2HMbHLcicv6XisVd1P2GjsTSlGh9PiQ/4I+kKzAX1V2rreDPaAlaVcC4MhB9v7dTG0JBkQpl7wLG10eUuwU8tZ0ImlNFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEBnaQqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEBnaQqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760E2C4CECD;
	Fri, 20 Dec 2024 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734701599;
	bh=JTbEZ2CErS4NkoX/2DIq5Zn/k+X1Nxt1YEAxyXZ66wA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=VEBnaQquV50xt8DqGvcSSQwpT22RVZz9kpJTb4hqx4icO0YV7sbjI+Gqu/5YB3Fz5
	 9CkDsBs6UGyFkyn7Ut6kpDRRssrfTUVmnAH2BskHy8yvpebCOAtOFJK3Sbxlqx7Ry9
	 DMbVs0gBKVCkt47cWNhjG8wvZmuJ3jkHbyHFD6MHR38Om4u4rg/ujCntM9kjthJiKW
	 wiVZZuJMKphK8TMcKKOqSf0x5s5PzJgwTwMwsPHuvPD2Cv+47FbeN+4Ua9ZCEftIuz
	 PZV+YsUSRN5fhLJNSF5JQV5TDwtTIp3WydUyQOPEv0YUFKpuwWcXOfqWYv06CiztXP
	 I0wRIRc6BQ8TA==
References: <20241219183237.GF6197@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: helpdesk@kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs
 <linux-xfs@vger.kernel.org>, Catherine Hoang <catherine.hoang@oracle.com>,
 Leah Rumancik <lrumancik@google.com>, Carlos Maiolino <cem@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>
Subject: Re: Create xfs-stable@lists.linux.dev
Date: Fri, 20 Dec 2024 18:56:43 +0530
In-reply-to: <20241219183237.GF6197@frogsfrogsfrogs>
Message-ID: <87msgqiin6.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Dec 19, 2024 at 10:32:37 AM -0800, Darrick J. Wong wrote:
> Hi there,
>
> Could we create a separate mailing list to coordinate XFS LTS
> stable backporting work?  There's enough traffic on the main XFS list
> that the LTS backports get lost in the noise, and in the future we'd
> like to have a place for our LTS testing robots to send automated email.
>
> A large portion of the upstream xfs community do not participate in LTS
> work so there's no reason to blast them with all that traffic.  What do
> the rest of you think about this?
>

I would welcome this suggestion. It helps stake holders interested in "XFS in
LTS kernels" to quickly get an overview of the issues and current progress
made on LTS kernels.

-- 
Chandan
