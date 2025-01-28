Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2445789D;
	Tue, 28 Jan 2025 10:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061869; cv=none; b=H+ZtSKHYW/wXARzr6j2ukUqnat7kKDd5SlL0zI33KMc/7wydY4QvoaEsdnn0lPRkHPdHoGzIkBni3ijNtObdlGRtwDb1ve4MZrI/VRBilmnT2S49nX0hU1yKNh8rFKO6fnW1Bu97m75mEfwIE61vo4FnhqJbJNzKSuS7z+yMKwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061869; c=relaxed/simple;
	bh=OHze50Q3DWl+LePefiX+gCqYSbz7UcQdSf7eE0RkVoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cmn5AdHr6k4i3hucr0xeAVQed+pCF14ZNJVSj9nZUbbRE7g6LVpF+83ukwtV2XkjnlXH7WRlTpT4NOgy6oqEnYMzglgtNscURPP5O8wxpeggvUYgaIfdBwplyqMv7yykvfijTMJRS8byNOoYHE/9DmUt+dwZzubnRnz77N/zxEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HL5o4ctX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HL5o4ctX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22C5C4CED3;
	Tue, 28 Jan 2025 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061868;
	bh=OHze50Q3DWl+LePefiX+gCqYSbz7UcQdSf7eE0RkVoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=HL5o4ctXEG+zPVdIgNVn4auQHb4xWmcV0Ecj4y9nCGN/8nFD47bTNSc3TO+TrdfoQ
	 8ExXVEl+v9wq4Sqx6s7NcvK5hzDrqbhiUaH+v79O8HWOLzB7qKUBfSdy1Ef1YdIhdS
	 t8LmFHavihg3HF8vvJYwigQoZQu56Do+bplWS25e0bxx68KJRxR8F3W92pKB5G7kHz
	 n+Fr8+y4hsPvl445cKIE8HgQug+J0P5IuK2V4EZFLbX71R4Z+0W9NA2ZwaqWnjZeIb
	 kyFNHD3BJOUUqI0trsozITJlfhs7kI9L5ygAU4Yq644XdRV12QBo1+WauzWPNduDYG
	 UXVNbEtoMsc+Q==
From: Carlos Maiolino <cem@kernel.org>
To: dchinner@redhat.com, djwong@kernel.org, 
 Jinliang Zheng <alexjlzheng@gmail.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jinliang Zheng <alexjlzheng@tencent.com>, 
 Dave Chinner <david@fromorbit.com>
In-Reply-To: <20250115123525.134269-1-alexjlzheng@tencent.com>
References: <20250115123525.134269-1-alexjlzheng@tencent.com>
Subject: Re: [RESEND PATCH v3] xfs: fix the entry condition of exact EOF
 block allocation optimization
Message-Id: <173806186643.500545.9968635452635594761.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:46 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 15 Jan 2025 20:35:25 +0800, Jinliang Zheng wrote:
> When we call create(), lseek() and write() sequentially, offset != 0
> cannot be used as a judgment condition for whether the file already
> has extents.
> 
> Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
> it is not necessary to use exact EOF block allocation.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix the entry condition of exact EOF block allocation optimization
      commit: 915175b49f65d9edeb81659e82cbb27b621dbc17

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

