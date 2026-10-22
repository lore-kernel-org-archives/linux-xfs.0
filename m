Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675189;
	b=OAF4hvhEBYQXV5okcKUObn9NUEFzAQYEVLDir1AzBe8WIxDDhfrn2MX/IWblelJs/U3N
	 jUskEpjAZWxS+HNkd9FiSAGRu+ioJjh7+vWF0wRRmqsGkNbBDAWWrsKT6slE3TUFcsFf2
	 OudJsB8J5vgmM4r45DBEeQRLh3sqFQA6buR5DQJz3Zbe/G8UIyNkfYtP8q1liz7opcHma
	 G9O3qz0MmYymFVs59qE4hHRFrmDNr/05wWeaqfvV9xjT7a6jHmegV4OJuUlR1nFbDIr57
	 2yGUuLv5P+HBCIzy5ir5LALAAhMxXyYHiSudDuG4GbxNL8Fs6FwApEO1jpTbYGqHydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675189;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=7kt/YewBZ5WO0DwXwreE4/5FyPrbACcihIhoifPaG+M=;
	b=UFtWduniEwKiffX5T0HuWBVfzuyiXOme0lRpUCNfWk8lg4/3oPQwohPcbgjA6d/94AVA
	 CBuVBuNJEH9F0IgoSOGehLJ9g6nMOv4qDM6F+rnHNZQ9+GHSynlSRHswc7na+b+OD5Mrg
	 VBjSLttau836CHuZHYe17+fnZVTc6GcCMrGElBXJ+SokVJsuWtRsLsN4jcVQGZ5QG03Zy
	 CP45LWP519Fe8R1X/7ZGn8prVxtjM/CQz+otuujYIqmgagDW2p2jUmZmMr0/7cG2UA2No
	 yuqHs0LaNGbSaDTw9DJYPSv1gHEMzxyi5+WChqdbrv4f+x27AIyNhG0fS3GpuGx7mlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMjfP1hC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89171606A31B;
	Thu, 22 Oct 2026 13:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMjfP1hC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21AF1F000C1;
	Thu, 22 Oct 2026 13:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792675189;
	bh=7kt/YewBZ5WO0DwXwreE4/5FyPrbACcihIhoifPaG+M=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=VMjfP1hC/3168FSqouAqzgo4s6o2H+anHy/f5E41DfZIhB2p5aRXQAawycCSmj8YX
	 QULhEsj5UAwYWC9FL5tJWpBdKd8ib2UuXamnEalDNILnfu6REb8Az4CbLtMKIJdHbO
	 1ZdG3TJBUW+2A8H9MA9oTw+gJr0u1sjU64g1QelEm01PKnkQyRQlCD2343xtsDxTHY
	 wDOnXYsmTPVAtMIeAuJ4RTnlpwpdiZbZcMFKsBERyXb8SpTxdezvj2sKjWCMl49hCl
	 49jltMEPmIP7aheElfY511NoBX4Hp8cqZvnhh/gUdH+/I2A9ZWhJbNBWvN73AHshYU
	 2ocXd8Tt/+SNA==
Message-ID: <0ba3f0a0-7e8e-46fc-bcf2-29935e8400d4@kernel.org>
Date: Thu, 22 Oct 2026 21:19:46 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/21] fstests: tests for cloned filesystem validation and
 f_fsid
From: Anand Jain <asj@kernel.org>
To: zlang@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 fstests@vger.kernel.org
References: <cover.1791272793.git.asj@kernel.org>
Content-Language: en-US
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

ping?

Regards, Anand
