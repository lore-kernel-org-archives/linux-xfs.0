Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D713326656D;
	Sun, 20 Sep 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789919762; cv=none; b=JtDgW+3t1Ny5acTDRCcwsc40NlcPSUMcRVEXdtvwDBXuMR23YutoSdPN6HNVCIFN2MFx+qgzS0aAMSo18YBIwIPJeSGvDUodZW0nfKuE/bS29HK8mW8GAcY6K0ceDvqmUgHHwohd/m2yAyz0eJWEE6rx/vH1ww83dXzwLbTbMDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789919762; c=relaxed/simple;
	bh=Hy0fiEvJf8BgINQGiOsxZaXAYGTquZ+7FPR1Y8QNrqw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ijYB7McqeOM7z02yranF2JQZ2HQDgHZ0YqUrHMPUMezGbkE1MTZ0gQkeM4GA6qSiIdDGzwB8oY/Rhoa/1pF8c/LXRcGjVC15FTsutekVtUSTWYRYA5Ln1mGgDHK3uc7alhd+2YcGZXL5LfVM7AWfAVbKtWhBCYNmcxV10UovJj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5EoRaen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5EoRaen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56041F000FF;
	Sun, 20 Sep 2026 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789919761;
	bh=Hy0fiEvJf8BgINQGiOsxZaXAYGTquZ+7FPR1Y8QNrqw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=U5EoRaenbscR15G9ukqE2alcM2qMNVKiOKi7pRkYAmrAPJkfJbvVzFB6U07rd5Jd8
	 864Za2kKnv4/C0SYzY1kiq6p0BwRnRN1Zt97Hzj6dhal7f40i6QCjjLUwvpBmKdIuv
	 N9XtRJBxh2D8gvn5JbSDZqPqBBSz7UMPFMTJPaCJb/HlsMDHv2HehxvGuXgSN/12GP
	 88nxGG6Kno8B20JH3kTJBJ42qsRZpTHzSgx1+IYO8B/G1GREfPuSTn6saXPbN7jxWB
	 u2DjlU8V9GP4ZQyqyvsRmzZKNlqzDvoZgy5xYwYOYaRdTga9Z+YdtZTDaZfOr65Z5Z
	 cMrTgg9cUR7NQ==
Message-ID: <9ef8ba86-6ebb-4b50-8e3d-fd8bf8483c24@kernel.org>
Date: Sun, 20 Sep 2026 23:55:57 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/13] fstests: add test coverage for cloned filesystem
 ids
From: Anand Suveer Jain <asj@kernel.org>
To: zlang@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 fstests@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <cover.1784949154.git.asj@kernel.org>
 <ba6c3800-d89a-49dc-b6c3-bf51277b2107@kernel.org>
Content-Language: en-US
In-Reply-To: <ba6c3800-d89a-49dc-b6c3-bf51277b2107@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for the review, Zorro. Based on the recent regression report [1]
and its fix [2], I will likely need to adjust one or two of these test
cases and add a new one. I'm waiting for the kernel fix to land in
for-next to confirm the behavior before updating the tests accordingly.

[1]
https://lore.kernel.org/linux-btrfs/be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com/

[2]
https://lore.kernel.org/linux-btrfs/b18b4324-6bd6-4231-bcb6-1f1f136222e0@kernel.org/

Anand

