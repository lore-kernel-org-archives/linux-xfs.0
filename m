Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC52154763
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415561; cv=none; b=q+dmJhj89Zu+VgKl0oRTa7dabkPfcrguMKpZtoLuKNuMXt6WlxU7LQJhYogZsKa3eSGSbAkZNbHCuiKFGp3M5UGWczdfYWIeYqD72GfnUDesCvi2b71FLaBwxTsn7gjd2BLjoy2hzmPqGWCgtRHTAxhAOJBY2CggN9K9t2uxjxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415561; c=relaxed/simple;
	bh=MMOIgSJCl+7uW1jz+JNMjOrAAd3bBucov5tDng6XaN8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=X5bslnBUgOjNqKOO0KIQi/7vGJxs+Wa8VwMFMtpd6wvvgFv9muqLUE4uIkYev54kZfQMZXHao+sD1Or4MYQ0WCpQYzdHS9DneqUFAm4FgG+gjmrW75cfXlz/LJq70ZDPf78835b0qdPLgHSU4VkYzOmC4vnb/Kel0L3S1nUWmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW6rFc6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW6rFc6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08121F00A3A;
	Thu,  3 Sep 2026 06:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415559;
	bh=a4VjLbyRcde8YjPr1GXNVA8BG5neSQaj9+T+7RGbHuI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aW6rFc6gdH1gJEEpHJ3Hs4ykR/R/KcrGQh5tP2cnWIlL/THkfU8r/HPYy1cQuuj9N
	 itxrKZT6wWHmwZRlOEXESbeUHU8ZFSFYOUc1AmRbgt0gOKpqEzXOqljWQbtOF5pb8I
	 34thDXjTmQ2RzaDuXXuBritw531hxuT0FXJTqRiVAxdkpZfPMSPue9qYxpj/ShuWVX
	 1qo68rmTBgp28GCQdd0xvhH0NGW30x+hMX0SVD4qGgz9jhBNWyS8DYcl6YL5ExZHcj
	 YZw5w3TiFOaqdJ6hNFx8soU4nQE1NEobxB+LMARUQAS0TtL6gZWuZDYwUY1hPEFmE/
	 POynwkbKLw2cQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>
Cc: hch@lst.de, djwong@kernel.org, dlemoal@kernel.org, 
 shinichiro.kawasaki@wdc.com, sashiko-bot@kernel.org
In-Reply-To: <20260826123219.73978-1-hans.holmberg@wdc.com>
References: <20260826123219.73978-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: prevent race in zoned space reservations
Message-Id: <178841555761.1198521.11039319583293305814.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:05:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 26 Aug 2026 14:32:19 +0200, Hans Holmberg wrote:
> xfs_zoned_add_available() checks whether the reservation list is empty
> before adding blocks to the available-space counter.  This check is not
> serialized against a task adding itself to the reservation list however.
> 
> This allows the space provider to observe an empty list, after which a
> reserver can enqueue itself and retry the counter before the new space is
> added.  The provider then adds the space and returns without waking the
> now-eligible reserver, leaving it asleep until GC or another event
> provides a wakeup, potentially adding seconds to max write latency.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: prevent race in zoned space reservations
      commit: d5ae1c0959420e536c9ac3a1a32f04c73f52bd09

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

