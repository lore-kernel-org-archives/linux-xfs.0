Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2E92D3237;
	Tue,  8 Jul 2025 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751976021; cv=none; b=C0q+NQwVZa8B3GRGQYcFlbZyAcZ7aa34iEP3IA7RhEQTJw5/k7OYuFKjZYw3rv+EDy+8Q0GI0WxGK8SKg2iR+YZbbaASlFrASybdoBrc2jDqkfGY3FbTdLCGZGNQv7Tu6i7CAs1sZmhsVQ6v37a+Tc2dBQiezaYs9aIcG8+02I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751976021; c=relaxed/simple;
	bh=gNk43+MrCINeKMwXUQsmQ2Dwv56NHcB3lHnPtMfN9eY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ImrsUlZO9ofCoQJ8Iz1YP/KpZeoaPp4FeAr7QCtpqDJwoHVVQu8Qx4jW9kqpXZ12vk0K/ZiKoh3eZC7U+3Q4enVvSam8Iwh4PVhe++Rj22Wl30kvVOn1fnIJnkiMiEIsYKZyQG7vFnd2Xts1lnzQVlmj9LyymYoCMiLB78qc6mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkSjcZvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkSjcZvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267CEC4CEED;
	Tue,  8 Jul 2025 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751976021;
	bh=gNk43+MrCINeKMwXUQsmQ2Dwv56NHcB3lHnPtMfN9eY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CkSjcZvTFP4VU3gHz9VgP0K8sChCXOnybl3tJtCtDP+ipKY63wxu/b2PHEIrqRfE8
	 qWhVupikv+H8LGEBQgLDNZ24c0KSaeAR34FdZLUI4JrVmyR9o2Rf1STKHxFMDxGzEH
	 KNQsp/5jLo36xwsQ9LEAO+OdufgmdvsnDATILtbcstI4BEQtEJJ3zIzvzpIgpBKpPp
	 zXxclRJGBPIzC7CWY7e6GKBx4wY4HCo/CFD4cPM1sBHer1ljouwXBVR5fBV+v6Djlh
	 Q4dAd7waLJl4FAEoCEbmkOwiAsCZOQjlHv6j9sP5ZCN6Pn9scuOjs7+UTXB/QBoeL4
	 0dHXaXFDJKngQ==
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
In-Reply-To: <20250617131446.25551-1-pranav.tyagi03@gmail.com>
References: <20250617131446.25551-1-pranav.tyagi03@gmail.com>
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Message-Id: <175197601980.1155040.12765734858532402239.b4-ty@kernel.org>
Date: Tue, 08 Jul 2025 14:00:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 17 Jun 2025 18:44:46 +0530, Pranav Tyagi wrote:
> Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> The length is known and a null byte is added manually.
> 
> No functional change intended.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: replace strncpy with memcpy in xattr listing
      commit: f2eb2796b95118b877b63d9fcd3459e70494a498

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

