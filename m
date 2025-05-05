Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42C86DCE1
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 19:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746474520; cv=none; b=MTBkkpVn9lr5OytLDQtUUegpJkRUiPA64GeJ1vD/Q1vvG+OHHkbNraF/BCP3D9RQznqykHKMeer7U0JZJ0iWWf6QLz6xZEPEb7w5g7McBj/h/x1MbDXC6eGchvfN/cXzLv1QuAedLtJfoCulsjW15x0ncK9GedQOiq51XkMNt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746474520; c=relaxed/simple;
	bh=ntBjZV+J+1J8vQpgpG17cx3a6xv4bDOJMy8G4HWZ/I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqumSIx3lsiv9tBokERUwFFibfEzCwTYeSc0xKHgHnCHTjh9ErQBSfqtRHMkjgehFnfvu/SEHbL948hd+tn+lnz1v5eA1HSPyTkQxA9l2Ko934PecVpiYEY+9RzxoktAKDWgZQPqAlsaAuvAOZ+QZ89yWY4WmNe3k9xUxEkLKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obE/UlFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obE/UlFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B352C4CEE4;
	Mon,  5 May 2025 19:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746474520;
	bh=ntBjZV+J+1J8vQpgpG17cx3a6xv4bDOJMy8G4HWZ/I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obE/UlFbbBEvqjR6vr3K9u2rNW8yKfPDQRM/MY7WNEGiM++uewBNe4QrApYcKYkIm
	 PMbUWpmzvqiMM6b8Plt7H/YdxOtu5dsfZgxKzq3re8g9vghZVUjmlJ8LKbr2AmC7og
	 96hsxgtWsd/spizRRXNhjai52ELjbEfc5SyyOS5+VdxWTX1YkJ7AtB8urrBqisKYwS
	 4gQirjLU9sONW2iKDISHGhDWyddxq6kDPlvguSvq+0ZMhbypktf6p4/8R9h5NTynsi
	 Ge4gLELI0O0naYfxhWjHg0SLNPH/ZV5KTbLsPW1q26uBxVF36PYSesC4EqtdZ5neBM
	 to817nTXbEqsw==
Date: Mon, 5 May 2025 21:48:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: =?utf-8?B?QmMuIE1hcnRpbiDFoGFmcsOhbmVr?= <safranek@ntc.zcu.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Question: Is it possible to recover deleted files from a healthy
 XFS filesystem?
Message-ID: <o3wd2gas6wtwrliz63dob24nfazdgpenqsmtepgldw2k2i5c6a@2uywvfbu4a7l>
References: <_ptC29dJ9nfKvxmWTJAEDaRH7gGc9qNbSz6zJBbEHl7ayyih4vrwmVznoGN1Mu_Luiru-PDMk_anzdCDzzUQlw==@protonmail.internalid>
 <18512e-6818b200-1ab-59e10800@49678430>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18512e-6818b200-1ab-59e10800@49678430>

On Mon, May 05, 2025 at 02:42:22PM +0200, Bc. Martin Šafránek wrote:
> Hello everyone,
> 
> I have a question regarding XFS and file recovery.
> 
> Is there any method — official or unofficial — to recover deleted files from a healthy, uncorrupted XFS filesystem? I understand that XFS does not support undeletion, but I'm wondering if any remnants of metadata might still allow partial or full recovery, perhaps under specific conditions.
> 
> If anyone has insights, tools, or suggestions, I’d be very grateful.
> 
> Thank you for your time.

It all depends on if the file's data have been overwritten or not. We have no
tools to undelete files, but there are a few tools on the market for that.

I've successfully used this tool in the past: https://www.ufsexplorer.com

But I am by no means associated with them, and I have no responsibility to
whatever happens to your data.

I know about other tools too, but I have no experience with them.


> 
> Best regards,
> Martin Safranek
> 
> 
