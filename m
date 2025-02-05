Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0F918FDDE;
	Wed,  5 Feb 2025 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738770995; cv=none; b=PfFl+Sn7VYjzbf9ceuM/oBetehxAdgS35/HBsfU4xarQ1oCKlip+YvRnh4yfoK0fTJ2ici8o0WqsCRMrqrQWjCxWMgNuauyLDeZuzHeY/PUnnK3UIVSh0wk2mUtiyIbNxLq8/V+6fCyZBfdcPHrDYGGNcspABo3XY4swWgM/FJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738770995; c=relaxed/simple;
	bh=MFQF50d7FG+/Q6NzXwHuucLTVQVAWALAr+y3xBK51Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CltdaFdTPE+n3sP29GNTXv9KPSaMhA0NTwqZZO7zemGNbyhjXeanPS68KocN3fsTfrNufsS3UqbhkrGT9NXeMc8bcsrWAcmX7+WE2F/eojg1nDHpyPI59pC2HeKwu4UeR/T61IinOu+B/DLE4cQUULnJnBeqDOgqZIV8gMOwGUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+SZtybM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+SZtybM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D771CC4CEE4;
	Wed,  5 Feb 2025 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738770994;
	bh=MFQF50d7FG+/Q6NzXwHuucLTVQVAWALAr+y3xBK51Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+SZtybMGB+SDMfJiK/bnGwJ5tO/uVoPdwrNcN6eQ5FIBLWl+ObbL66Z5zUn+9oUi
	 wpIly07ezw7YN0ePL+zfFUMKiUkGkktH+9i/4NhrtrS+0301zi+eaTaESpCasb3Lrz
	 suPBI20beTOlDyn7Oj/pf3a513RtWZwWweBXafeWPYKBW1U6yuNNaw19Pbz+KPQziN
	 C650kkcocJnYihrlFXMt63XQNxBtgzzvdw9z5GGydCLyxJyq6/YOwLXK2aEFVH/ENG
	 rXs+FVYhOMLjgrXSYXX3pJ7D360R/p/gUy8+6B7KWb4++w2lVW5Y544I4TaGPI7Cvt
	 64w4Ug0K+5c8A==
Date: Wed, 5 Feb 2025 07:56:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org,
	syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	eflorac@intellique.com, hch@lst.de, cem@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCHSET RFC 6.12] xfs: bug fixes for 6.12.y LTS
Message-ID: <20250205155634.GG21808@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
 <2025020556-bagful-cosmos-2a72@gregkh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025020556-bagful-cosmos-2a72@gregkh>

On Wed, Feb 05, 2025 at 06:55:19AM +0100, Greg KH wrote:
> On Tue, Feb 04, 2025 at 10:51:15AM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here's a bunch of bespoke hand-ported bug fixes for 6.12 LTS.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > With a bit of luck, this should all go splendidly.
> > Comments and questions are, as always, welcome.
> 
> Should we take these into the next stable release, or do you want us to
> wait a bit?

Let's wait a day or two to see if anyone has objections, and then I'll
send this series again without the RFC tag.  Already I think I see that
the first patch needs a cc:stable tag to capture the version.

--D

> thanks,
> 
> greg k-h
> 
