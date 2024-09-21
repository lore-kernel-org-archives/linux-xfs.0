Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66741171C9
	for <linux-xfs@vger.kernel.org>; Sat, 21 Sep 2024 10:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913085; cv=none; b=UybR6IM2ZA2P8NVSnljEmAuE6VxRx2mFlce1T78+WFqyF/plm5gawB/fcb4nIUBtODoArmP92aVKax+h3aAK/IkHXXbxUX9ihKRmjrvN5NUFH7ywF/HXte49V9BjalLiSDWKjNRw+q4nX4rEJ85rFC94URPg7GqlFO1eEH/IR8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913085; c=relaxed/simple;
	bh=7iOQ7SF+oWzD/BzsjKzk5FApVLxs+tKqm1NGsLHMKhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sADgc80KqF0X4t1lIKlbPPuhb47N3ZoYeNGVFA21wK9u6HBKVs25GByvxD2Yq6pU/VIbvMlTI7QkD8GNmXQDLQvAuuvkwHoN8rKEH+18EsfcXqNalegjeuZJm1xTAP/4MvpYWDr4m+0fs9yVN7Fty0CMCJNwh5jWqyRUsQc7WlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxX61gI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxX61gI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64978C4CEC2;
	Sat, 21 Sep 2024 10:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726913084;
	bh=7iOQ7SF+oWzD/BzsjKzk5FApVLxs+tKqm1NGsLHMKhQ=;
	h=Date:From:To:Cc:Subject:From;
	b=fxX61gI+DH4p9eeiGgv9+Ege2ADnTIXzuDHeyh0UDZ1i0KhpvoJ1oEU486BxhXW/u
	 IPcVJbuanv2Q7b7PfmAHWdPJ8z7DjRmL923nZtA2bYltxCP73gS6Ob2Sj3w2QzAGwL
	 FVh9LexirrvJxKxnXNND/AF3tZCJOlPmOtLqs9Tbew94YosMgKpWgWHvKNi5q1yTZi
	 UuwZg+PF/J2wszfWjexzhrtUXGZEMxOgY1O5NH0yxwHBFMG8rzgLun3ELVY3x43bQa
	 5HyuX0aDKF4/FXko4feKIYtw3DX0ijsAduug9tjAGVuSvEiZM+e7yXNgBaWeujjvjv
	 Ml0Az5GLKi6hw==
Date: Sat, 21 Sep 2024 12:04:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, chandanbabu@kernel.org, david@fromorbit.com, 
	djwong@kernel.org, sandeen@sandeen.net
Subject: [ANNOUNCE] Maintainers swap for linux-xfs and xfsprogs/xfsdump trees
Message-ID: <w74v6od6ow4rqd3k3icsze4gsgsy2d4mgwttz34l6qvxuf3ujq@wyubfnqekgfd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

We are swapping maintainers for the mainline xfs trees. Due the responsibilities
transfer, some patches may be delayed or missed. If you have anything that
didn't end up in one of the trees, please let us know.

Andrey Albershteyn <aalbersh@kernel.org> is assuming xfsprogs/xfsdump

Carlos Maiolino <cem@kernel.org> is assuming linux-xfs.


Cheers,
Carlos
