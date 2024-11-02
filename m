Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD372B9A4;
	Sat,  2 Nov 2024 07:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730533260; cv=none; b=a8cOsVdlbbloqTioClTMjPFI+/YDRpEQlMuoTA17Ud8805ciYSqmGL7hGqA51u6deFMuwAqg/44z7CFXQ41y2faRaU/9fgroD4W1CvquTv31NXq6U9oafmMMemRv4m1zcqnFF5ChTNMgq27J1Q7QsZW/Od14nz7WiUQS4vedEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730533260; c=relaxed/simple;
	bh=zXNGygLQS++y+maclnsYpMlqOvOTWbUKkRrKgxpyRMk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KegzNGSmzRZfPac5UJcZzIqhkqCvKSXx4/pxELfHB0e0MF+igIDUtAwfmvX+Ju/+IfGznsn+XZlJik7WzsseBVBr7E0eoECUrFwaXT3hGJipSf07FSomd7R4kTWdff55VwfH33JLVEvM0Orm1IM0Y8+9wCQfzCBKbD6tl+VLnwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUW1aEB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUW1aEB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F060C4CEC3;
	Sat,  2 Nov 2024 07:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730533260;
	bh=zXNGygLQS++y+maclnsYpMlqOvOTWbUKkRrKgxpyRMk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jUW1aEB4h3jUI5Ylk/CAlWyeCuD6JS9+qc2YIpsnNSZEB1o5SGH1Tu5UTZxUE71OW
	 4P/KkH21+iqwRhk3WBXjt1rf/3oedca4H7rfTCcvxo8O8itcUa+gXIbNv89pU3wb0f
	 SBdJVJO3rNu6PAmv0jJzjwOULsC4sC347XZzuy7cjRxmF1l4d5xKNH9fCh1Kt3uoFy
	 3lzjTXS7RpKEiON8erIhCsEfIBBkznHRQQfuwE9ICCnQn07dxhBG0KgRJwhcRk8mQl
	 ojhenK4iIGqEVi1JVUpKix6EEZPJC8aTSUT4S7i/84A4PeopHSjY7zTMtxWUexbY+w
	 aa3Uene+ZRXrg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org, 
 "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com, 
 Christoph Hellwig <hch@lst.de>, nirjhar@linux.ibm.com, 
 John Garry <john.g.garry@oracle.com>
In-Reply-To: <20241015094509.678082-1-ojaswin@linux.ibm.com>
References: <20241015094509.678082-1-ojaswin@linux.ibm.com>
Subject: Re: [PATCH v4] xfs: Check for delayed allocations before setting
 extsize
Message-Id: <173053325678.1933492.6809218664596169694.b4-ty@kernel.org>
Date: Sat, 02 Nov 2024 08:40:56 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 15 Oct 2024 15:15:09 +0530, Ojaswin Mujoo wrote:
> Extsize should only be allowed to be set on files with no data in it.
> For this, we check if the files have extents but miss to check if
> delayed extents are present. This patch adds that check.
> 
> While we are at it, also refactor this check into a helper since
> it's used in some other places as well like xfs_inactive() or
> xfs_ioctl_setattr_xflags()
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Check for delayed allocations before setting extsize
      commit: 2a492ff66673c38a77d0815d67b9a8cce2ef57f8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

