Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EFD39768C;
	Tue, 21 Jul 2026 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673437; cv=none; b=WhitJryx+wWQv7wlFD75YlFqJtw8Nwn1M5DZwTp9zXckVtguPNKRegZal5MFyw4Dlv2uO5075/Sr3wIhIUy3A48lJdAgVxQuIvhAdKVSxzqKSg/Mp+d+9dEhZPCvz824QPsgB0z46w4fNRlitb5bFzyRs70LVpwncvtsU3zng5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673437; c=relaxed/simple;
	bh=j+U85Vmce3flv9DgJ377/e9nUeU9pzHXtP7lOQ+Bjt4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WvKxjdOrJ99A32gLn+642ZYx3MpNDB6MSFZGVqv5cdqC5TRajt2C05ZmYmfdg7q9FEeQ/nA07cqHetN2H6e4DFts3Ty8JLNY5kBjP9yuyOl5Qi3iIjBADm0RLE+xUP6qY7kKDwpQ7mSemdzO4Ju/y1F1lp/Il1btRh3nz2VptcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TinKzZCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TinKzZCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539871F00A3A;
	Tue, 21 Jul 2026 22:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673436;
	bh=JQPOE4KI8wVROAG2s7qaeds5Wqqg4NjMeGk/K5p65kk=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=TinKzZCFRr9NTrvjDhe1+NnsJ01Q9ajgZbV1ni8udnG2s3CCgVqlWizI+9H6XvuaE
	 sgio1F6KVFUN+nWHV2D3fxosfQ6S13eMyD84/A/flsXxgjCjrtzcDqu/5j6ntlzoym
	 6wf16ahuV/3FUNr0L0XeM2s6OJDk7opflBItl3oSLAf41rkmcSIu/vN0s2khHDtdyD
	 d/4YHGsFaCl0Qu+ITNYK/+FtWyNSL7r+/Q0n+V4qSlAQHEi0iJ/yFN1+kDIzzoecaF
	 SdkoEFs9Bwy6cHwctSsKh8spsO7uTfldEeG+/fDcXxkn7PeohkFmDFwI9hrAg4VY9C
	 LP+N6/GVuFYTw==
Message-ID: <48637a77-b2ec-47e8-ac77-d397660c482b@kernel.org>
Date: Wed, 22 Jul 2026 06:37:12 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v7 04/11] fstests: add _require_unique_f_fsid() helper
To: "Darrick J. Wong" <djwong@kernel.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1781694879.git.asj@kernel.org>
 <f556db45f1ffc93508a69ce9f9e567b74384210f.1781694879.git.asj@kernel.org>
 <20260701171122.GF6517@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260701171122.GF6517@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


> _require_unique_fsid(
> {
> 	case "$FSTYP" in
> 	ext*)
> 		# Ext4 derives f_fsid from the superblock UUID, meaning
> 		# clones share the same f_fsid until their UUIDs
> 		# diverge.
> 		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
> 		;;
> 	*)
> 		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
> 		# unique per filesystem instance (often by deriving it
> 		# from the UUID and underlying block device.)
> 		;;

> 	fi
esac

> }
> 
> --D
> 

Yeah sure, suggestions applied.

Thanks, Anand

