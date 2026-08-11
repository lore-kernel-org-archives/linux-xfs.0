Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711CD43D4EE
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467803; cv=none; b=a9clyrDa8kBunl0kUnW6tAQBU8Clm9CuMyHYKoiErQtRwBfR9UtNkH9qTBFZzWWEySQWGED0t3IbEto4xccZcCBYitxVCbWU9QIM2yMt2oF/qyeV7wZw5v+glocK3MyzbSEa4GN/YlXLVB1jkNlE0dvoAxV030HovO3X8Xcd54Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467803; c=relaxed/simple;
	bh=JBIi6bqLUuIeQ+h9mkBjiSDXlHhHvVfEKGrTeLPKXSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PU62kAb5wcj9TERnJ+qbnzOQzkJh8kt1bRjdrf04HlWEa4ePj+iZuilZPvvWClVAHNh+jwTnI3k2NCnTwRsDq9+u2tYFFl1DTx42Pl6Q1WhvwpEMVorViCm7yEaOL/9+3T+sPW2ou9aOdLLDCdY7ndNWXV69RdXaNYA9WE3g/l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJeXniFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJeXniFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7411F000E9;
	Tue, 11 Aug 2026 17:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467802;
	bh=UvPER0eb5WdAoIOa8CrNhwVL3i+uAe2AyJtKFdH0XX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cJeXniFT17uk0RZb9/NOZJOpGkf+xuJ8YEt29To1SbF1MRDPwKOBwV66NDgYiC6+V
	 FbMkp297aO/JZSO26m0cBW3iW4nbVY/BcNE3QmX1lTIuMZVvcVp3Mrm8vwOKpcMBBC
	 Uksa6E4z44VyW0tbKorlPcP/wg2os/KCkdD+bM0N49bC/9gMQC9m2h7PncLwFEBXn6
	 XSldU++w7iZwKa69rSuO7dGsydHT2FWPQa4URj59CltnLYV0LmbdNrHUbrvmUFsdsg
	 f6GD2ns3BGmSLnX99cDx46OSINJQVMdDjeZ9rRr1C38anyG1HK67BNTYGRUvGqVhbO
	 d+2mi8DqLYFEg==
Message-ID: <18851800-9a5e-4cb6-8e75-c86f6f992761@kernel.org>
Date: Tue, 11 Aug 2026 10:03:11 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in
 xfs_ioend_put_open_zones
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260811164912.124416-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/11 9:48, Christoph Hellwig wrote:
> In theory we could fail multiple ioends before an open zone was assigned
> to them, and the iomap code could merge them.  Check for NULL not only
> for the main ioend but also all merged ones on ->io_list to handle this
> case.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
