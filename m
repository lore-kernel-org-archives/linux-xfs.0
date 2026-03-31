Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D263A0E84;
	Tue, 31 Mar 2026 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986055; cv=none; b=CFg2txUDvLD0tpBxfyxU990vGe5gNpO6BCaqIn6R74gbIPohUvjKh+VqId7r08vuDKFyPWBBgxV6Z34z3RURFDME64Y3kwlEIWj4iIhMB1apCrzqpOGouy93Iijsl2pp93Me9t8LgxQNXuvyhAwU9oSZsrBqaExDsfa8/dY3IPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986055; c=relaxed/simple;
	bh=5fulfxaovanNNPY2jKemuI6f/zAjPyD9IkD9BMZrIog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SafQt0EwZxCCtQq4t9Y3fb40J5z2UlKEYaIOsPkLydl5z70Zn6E4+FfB60EAErNJuThiKtfg3+FJmek8qskNbK9NDoZO3yEI5OescP8IEPBdvGc25L+L04l0+pvQ3h5BthcKCl21/m01qPCSL47ibFhLPcv+YWO+h+TG2fZzPu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JA5juQ0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JA5juQ0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49083C19423;
	Tue, 31 Mar 2026 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774986055;
	bh=5fulfxaovanNNPY2jKemuI6f/zAjPyD9IkD9BMZrIog=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JA5juQ0KDV4SUO4HcGRNmJQDf3l5KH3vgOL0D6vCD7nT+cXiVJZW6Qtwtv8I8bGI7
	 qLBN1Fl3UL8GrKP5r0lR+/MZT8A/LzFpRKO18EEnfFvKuh8myPn7omv0Izl8upSEHN
	 ThFX+gRNicwMIGX/MjGIvHiAVfCdkulNb8JPgYk4pn3uEj+8saLdmHlPTaprBtm7dp
	 tNPWkVbTXjG++LhgEoWvNFFYJ/fWs9JCWUw3/fjECNf9CGTPkhEukRZt/z1XnVveRF
	 TCxSp/LeivWSW6gZ914U5xazmkUb7RdVQGq/aFRr6euo0B2CE24cXvmQC4zJJYf84w
	 45fhHY3DHDo7Q==
Message-ID: <df4f7b07-cf14-499f-84b3-7d0ef2562c15@kernel.org>
Date: Wed, 1 Apr 2026 04:40:52 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
To: Christoph Hellwig <hch@lst.de>, zlang@kernel.org
Cc: djwong@kernel.org, hans.holmberg@wdc.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260331152341.4047725-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260331152341.4047725-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/26 00:23, Christoph Hellwig wrote:
> Test that mounts of zoned file systems on conventional devices don't
> create more open zones than allowed when the last blocks in one or more
> zones have been invalidated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
