Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D5218EB9
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734719860; cv=none; b=r5csMzfc+zt2CMRVY0vOVDP1/ul5cmmjB9ruoeIpRb726mWFCvfJounK2HOBv6rLULci0kMcnG7is/NLXnNnM6rzAwvF6LZx17S5Cx+cWV3M3tMOymtDgLvSEm6Y6m1ROLTq1ITdBX5Nf5up79C+3nmOdgcmEJ8mLyi1ZdCqzI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734719860; c=relaxed/simple;
	bh=VjtmBItI1PpNli2yg2S4b6v7y2qGzMuSn9LMKsdjAqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvxE4IzWK0ZOuzQ3Kbsi8yDtZNCqB6dj1Dfm9cGkaOznSNWBoXV+sUH/6HMOpFqdwsRMm+VjUB1XksEKu+jBgSoP8NXqWiGF5RZrZp7SDngQtSvUXstCV1d2dO4OGTqP61k3imfXznAK5EL4FYsPGxnyJ+WTYJvttKFF1cIqkEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu41kksQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu41kksQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B6C4CECD;
	Fri, 20 Dec 2024 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734719859;
	bh=VjtmBItI1PpNli2yg2S4b6v7y2qGzMuSn9LMKsdjAqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iu41kksQCMLGzJDnQZTLdR+asqBMpwBWl8UYBOxo4eWeSBb5ukkslRmKV8kEKJOiY
	 DMI/UwgvRCFXqJ5ESZ/mmLyiv9fYyIGuXwOd6qOP3PuW9yrbaLAXt3wxK8xNnk0sir
	 b7Df+9yqzcyGGZB/xsa2qKXcMUI+WWtooJ0ES8rU=
Date: Fri, 20 Dec 2024 13:37:36 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: helpdesk@kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	xfs <linux-xfs@vger.kernel.org>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Leah Rumancik <lrumancik@google.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>
Subject: Re: Create xfs-stable@lists.linux.dev
Message-ID: <vbcin7yhf7ymbt5o35clxzym3qh2irxrabkd72bnksiu2kzu7g@jzo22uocpzvv>
References: <20241219183237.GF6197@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241219183237.GF6197@frogsfrogsfrogs>

On Thu, Dec 19, 2024 at 10:32:37AM -0800, Darrick J. Wong wrote:
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

Can this work be done on stable@vger.kernel.org?

-K
