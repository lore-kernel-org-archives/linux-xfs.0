Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F3D535D0
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 04:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708402431; cv=none; b=WnynOnOa4LouE2b3kVSYhqI5vEFSZwQvYM1tIZatT2pxbC6l7BnrpEykzCQmIcfzl7VVEUsPNXIETGL9TjRsJLMl63TuBev2Nr6Mvt/6rPhUvekdGGtqN5A2oR2TTSIk+m0jFCBBUG2qgWJyTjHxeSksLuBmNafRkOT4FLoGOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708402431; c=relaxed/simple;
	bh=41CNtQgwX8RxHE1lX1LzPFYarVEK6rsM7apxC6t702I=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=TQHRE4V9IlyauZGLv0g6qnmTaaGlhLas66L33eEeZVCcEzHVN56+vhfZb4tZy4nDDakCUqG3CzW0jKOFYz/NbaDhi22U8tI9wPXmj4Ipol37JSA1/OozoFJATAX2d9IG1BShIfkFWmoPOeqVjAY3RhSnnceIqrf88WlI1ic3NzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1yghm/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1yghm/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26FCC433C7;
	Tue, 20 Feb 2024 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708402430;
	bh=41CNtQgwX8RxHE1lX1LzPFYarVEK6rsM7apxC6t702I=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=D1yghm/YTt7NSMlPQdGpDB2z8J52y8jlUXumtuSJmah8n5cqQBSF8Bek2g7+iFEet
	 by/D+4HR5hHZi254hNSpW3qMD440BiqZxW4rvMxnszde3U4N3hzPX2nvmP8Vo65ecU
	 U1hRrREZWrQ/lDYQvqMt50zNYIaQyPdkJyor+y3fkk3GSO1aBwXpjy1loBEDN2D6yn
	 aU+mIgZC8qrzdOZJ0fINW0RBgu8P9m4/t446Spzu46tjBRN7rqvRi6zEa2OHE9F7Uk
	 cgFsvbPUV6BrBDv41Qt1OQw+3sX9CWLQNW67inPZw0/bEXlsuwKhfZzeOD04lZjgY6
	 6WdLpm6HRknOw==
References: <20240219062730.3031391-1-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v4
Date: Tue, 20 Feb 2024 09:42:23 +0530
In-reply-to: <20240219062730.3031391-1-hch@lst.de>
Message-ID: <87ttm3hix0.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Feb 19, 2024 at 07:27:08 AM +0100, Christoph Hellwig wrote:
> Hi all,
>
> this series refactors and simplifies the code in the xfs xfile
> abstraction, which is a thing layer on a kernel-use shmem file.
>
> To do this is needs a slighly lower level exports from shmem.c,
> which I combined with improving an assert and documentation there.
>
> As per the previous discussion this should probably be merged through
> the xfs tree.
>

Can XFS developers please review the following patches,

xfs: use VM_NORESERVE in xfile_create
xfs: use shmem_kernel_file_setup in xfile_create
xfs: remove xfile_{get,put}_page

-- 
Chandan
