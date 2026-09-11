Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C561424676D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 11:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124793; cv=none; b=JlV8OzOoZa4ux+yWChucXCnr1FZgAO4N0zLV+gmLhKqVMrR57FrzCKDLLLR9KhVobiWxsbZXyzD8VvcABIw9ODFi/t+Su56eGQMde7JSPIvagwxpmRzQY99jG+Nm7o/CZFxy1c9L9Md3VJ2Gzya3rRQ0/pWgCSlyA42RT5Xl6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124793; c=relaxed/simple;
	bh=zDf+c6DRUrzubmqur3rUynU51HN7z6XpiW8QtkJcYAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZsjwnsERj4kS4iu9AuNZUd+405MNmcZTD/3lWKEZLkA20BWddp+MciIJKs6SXkUfRKhRxms+ViXsyk02ZdaNkDsP9BbsPz/xbcJiCUVquJ5Q3PGWN4DdRa2rCubTa0JtRmL5F2WH3vmGR6pk9ykdWzerVWCbd/zqbzoZyY4124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbrOr2w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbrOr2w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC8A1F000FF;
	Fri, 11 Sep 2026 11:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789124791;
	bh=nlyyGtIbxcdtzk0/PvISKGq/4+Aue/B9mBJW5RPrywg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DbrOr2w4BbcO8EM80C2QPlBx1xOYXmdTihTblW+A72ddKoVrtZqJ6U3XQX6+MaZ/d
	 YgxwYh3xBLVamxhku5kv8XCk29wKKdwlNQ9R1yQjRlQ9bkar2cqQMwrz/wv/+9nDQj
	 ytWu+Axf75kvg7UC7HEIPT/tQI7DmUx5I6ISzV20ayMCTSKSzoMIOYq0YnpiOckMxF
	 lr8Hjat/3NNbPwBo8kXdNDbVDrHxKHuAwFszBeXpiR2RV4/rw6vnw1pafqlAPBjZiw
	 L3E0rb9qESTtMeWNBUR0SZCam1BNFdRcL/1ukzK98iBL5cbRhRmgr6jdqQqs73b4S1
	 cpRSmflUziFBw==
Date: Fri, 11 Sep 2026 13:06:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: remove the ip variable in ensure_rtgroup_file
Message-ID: <aqPgoLmGMUkez2xb@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260911070548.1760348-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070548.1760348-1-hch@lst.de>

On 2026-09-11 09:05:48, Christoph Hellwig wrote:
> The values is never used after the first initialization, and only twice
> after the second one.  Open code the dereferences for those to remove
> the dead assignment and to keep the code simple.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
