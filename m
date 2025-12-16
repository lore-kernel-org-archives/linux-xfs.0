Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9A346E69
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765871253; cv=none; b=LUoFthFRMzWjhtR32zrqjjqeX9U8zmN+GOACjYC2/yjsniNUWmlbJ2w0a4tyeJWbQsBZ8iA1s3gTmN7cz33t4uYS4n9wKXJkMCg1hiQ1g59fdU1CCqL3ZiEQUtsPggUa6MJ28vTKLs/zHPNv2FQJIWBmFUwHFJNqIyS6amHxa8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765871253; c=relaxed/simple;
	bh=FiVWIBjE8JtFnHza55F0pIQx73tu6Z96Iu6a7hIkQR0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QwT1vgq8MfMWzZ/38HaSqdFEgOCWsE9NDjTncbajJjFIURPopYmbR7mqAI5nytPsp/UTpR4UKBwaocqKSpS5hTM0t59PYMINo1Sm4OrD05ddWrgHP8oE3vRrNKr7n9gW3nODTkGHIheWqZigdaII/qS7VeM6lXHuhgGxyylDNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohATodE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohATodE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C6BC4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 07:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765871253;
	bh=FiVWIBjE8JtFnHza55F0pIQx73tu6Z96Iu6a7hIkQR0=;
	h=Date:From:To:Subject:From;
	b=ohATodE20aqhVDdoM1fD6CEHjz7Ibs7Nc1yjaDhMFp0ZmEhcDI1bC7DhM19nbI8pe
	 FxD+ILm8nJl6e6JXABQG6x6Ng3s1VGI04+DWDreCFNRzlkEFicZtDADMxeibYSERSr
	 ObPOyjuMykpiVU7fPZ6aPrWrONibi4/XKNlHXlpbbNCtraK5Qp1iO4ZfQCHU34EkvQ
	 9k2yQQDjYRMRO6xhmyLOtICJGwHVqWiUMHox70vjSnTjjtAvARpfsXCIuXZroZTdiB
	 683i9cB8d3EAVoPROOgqDmoFvkQEiOCjdONgHV4OR1vV86tN4Z/H0VgKkZlRKOyBCn
	 C13kBQ+RG7WBg==
Date: Tue, 16 Dec 2025 08:47:28 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 8f0b4cce4481
Message-ID: <7rg2s3hd7ucy5olj6exrhsgwv7counvtmm2s2rfos7ohsipz4h@zsbnf6cz4wk3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This just brings for-next to the next development cycle for 6.19 RCs, no
XFs patches have been added by now

The new head of the for-next branch is commit:

8f0b4cce4481 Linux 6.19-rc1
