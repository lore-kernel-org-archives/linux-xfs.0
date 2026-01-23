Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28358341660;
	Fri, 23 Jan 2026 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158790; cv=none; b=H+CyKx4gToBk95DKCUvhQJLCddd/XHopbchnEJHDDoRrhjZnnoAl9oPbe2kNrQkjcbY21s/ywh1moN2xEOvU9baM0rKbdJxcFYQPilWR3LB7pLDIXQHrkW9EqiaVARLzDPWjRA50mlfd7N388Mv7Ls+wL1NSpcOE4IDyRr4ea5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158790; c=relaxed/simple;
	bh=w/3RA74glNAgClSSNOe35KU+ZUkmHmZduilJvX3ZwtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAHvX7UGi3FQI7WbAAkRFXtFytnryokFwtywlxNYXkxlzEPtFkubaNyMm4cLcdrIyk2z7tiOhSRdRoEF/SV638EObFDs0sLIXed/TDHdKfOjLNJPbQ4WW1dNfUz5pgEmZhbIZFV1ZXp7XOfOCPX/A50AeqyCWak5ybmQVg3jrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8sdSF+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8sdSF+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE79C4CEF1;
	Fri, 23 Jan 2026 08:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158789;
	bh=w/3RA74glNAgClSSNOe35KU+ZUkmHmZduilJvX3ZwtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t8sdSF+1V59Ti422kfgD4w4LLSsBaXmfjhTHwSG1QD+h9xtsRR1XqSTVPLg0p5+SO
	 R+G+Hb3niXFV0x5qw51UoSpAnNP+bgAbwA/3XWi1JG79grVJnZ92n0YPBhjv0ajDsl
	 jC+X2J6ANNP+1o0vck1eF/NxEZjXv83XeOnskkG7M6VyymDmNK3TgU+DZomK3iohat
	 I5u/n7oOZk6r+zKwtNjrqbvotelLxaeNxEbODz9DI3kL4Iyl8EJfeBVvraJb7YKxzk
	 HJW0UKdW4oHDSeJYbWH4oezum5C8DWSpmwi6WmSRN7YsqvL+7LK2Yz0mK5PxilmKk/
	 +dWIqRpK7YMaQ==
Message-ID: <c7ff70c6-5375-4fb7-876e-b3c54aeba65f@kernel.org>
Date: Fri, 23 Jan 2026 19:59:45 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/14] iomap: free the bio before completing the dio
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> There are good arguments for processing the user completions ASAP vs.
> freeing resources ASAP, but freeing the bio first here removes potential
> use after free hazards when checking flags, and will simplify the
> upcoming bounce buffer support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
