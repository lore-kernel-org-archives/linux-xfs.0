Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E417EF01;
	Fri,  9 Feb 2024 18:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707504248; cv=none; b=JeQ8XunLyrGkhg5XmmKTt3XfKFATdtg3Erkc8E9FDpEqCcDD9U9gqgM+1uiTmDhXhr00D2vyMl0B9Ptm3EEaxB3vAXVm4Cq3LvXqWfd7V7G//Zo0+mLkRJ2GWVVvQzFLcutnAMepO6xIwibymXQrMSPaDdLPqSKoK5/7BlPJJEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707504248; c=relaxed/simple;
	bh=Pvsex5JHR9uqBUwhlnYMnlI0sDN5E7MckxxaLPANjCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wgvqzoe0/eY87uWI77FvQesppQbto4evkH8AE9vVo8TZgNf37pXfUKXt9UQN3CrSmEwjLwU1oiRE/W5TXzVIM/PGWgkoiGj1Mz5L1ZavhP8XHLbL34BbKg6t1SXSfLit+YSAmF8fWVWgYBCVYYgFmUP8NHqLsN4KqFpm8WoPArw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbQO6qBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbQO6qBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4D6C43394;
	Fri,  9 Feb 2024 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707504247;
	bh=Pvsex5JHR9uqBUwhlnYMnlI0sDN5E7MckxxaLPANjCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NbQO6qBjdX5c0JFnbUGJ2dU+J/wpMpBLt6nEx+HLp/BbXfYWbSeqXEnjuCG9yff3E
	 OsyxnwpVhcrU1QXKaDU5xYx6uiofGdiH/+sU5UTlTY83Lu92vZmaFOvwye2zvDh0JZ
	 AsoOaAc6GC1wDu59r/Wr53T6p2Ykg0RWaQfW9oKrKz0UplT9yNmrFZPBn3j0yx5H6v
	 s6edmQMTZHC8B7MwAHIrqVEssOAOOFc2hE4aCr1DQm4xx/4oqbfAO0UYsmh/gf77X/
	 yrzFlwyQHJ5tsif5kweL9rdlF6HZ09shUlCCflvPoj1TnfP3+RxppEfTk7kqCEaboK
	 3eWa6f699WpIw==
Date: Fri, 9 Feb 2024 13:44:05 -0500
From: Sasha Levin <sashal@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 00/21] xfs backports for 6.6.y (from v6.7)
Message-ID: <ZcZydUKapI1i30gj@sashalap>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>

On Thu, Feb 08, 2024 at 03:20:33PM -0800, Catherine Hoang wrote:
>Hello,
>
>This series contains backports for 6.6 from the 6.7 release. This patchset
>has gone through xfs testing and review.

Queued up, thanks!

-- 
Thanks,
Sasha
