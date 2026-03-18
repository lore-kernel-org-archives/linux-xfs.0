Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333943B7B9C;
	Wed, 18 Mar 2026 10:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828760; cv=none; b=i+iEWlhUf2w9YXbp1rrjvNoSPNA216sE3gEnauvsHVZj8dUp+ryyRTikVDJhOhFQKSD/mD2O69uL65eRc6ajYPr0FUDnJ17Lv9RYmPflbqkQU1ld9LbVjoz7o+DYWosBsUPWKjKbJFrBFYMw14UNkML0VZH/34efbOboAIPn3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828760; c=relaxed/simple;
	bh=XNAxqAwFJBlndSAv/Ci96W8QFhAYf7HD13zR0bPnZa4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ArvDMtMdaqn/YWcNJbZ92VWLpoRjelkD1zewwzmmP7G8pDqvF/vw2jMSPt1y72SMhW/Nx7JmL4DnddrQZFZnH2HdLpKkfUkqa93q8w1Tj23jol19sr0Jb88jWpOubWARh4xBUOEp03t9glLkPmgHJjOoGdYhXGCUNMnMSfW5SJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbWDpubR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbWDpubR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3577EC2BCAF;
	Wed, 18 Mar 2026 10:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828759;
	bh=XNAxqAwFJBlndSAv/Ci96W8QFhAYf7HD13zR0bPnZa4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=hbWDpubRHXyEKMw8xc3HLSwUDnR0yS03RPnnhTPxbgY3+mCmJfG5A8fyhMWYA3Imb
	 gnYoQ33isBIAoHez5tm/FepRgGh1l4ho1AntTU8zFH9hdT94J5LEZB+05uKdSjNCmn
	 807b4/DcPlAov/g/y3wYwrNBI5q5LdT8kt3iRcWi/PEPD7BRUuRMGa+ohm+fb947Ae
	 pETNa8JiiD7DYsVUj0WodkUuJmtvct6nyjat7/T9YcZq/Esyshnh2BEot4xXDLm08e
	 69mQDNhC+wUHvarUFNl8kfUdV0gUi9EJNvgcTLMT0m9ntZvsv859UXUoOFQwVGCgE7
	 kpKYp+BPKdVFw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-kernel@vger.kernel.org, Bill Wendling <morbo@google.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Gogul Balakrishnan <bgogul@google.com>, 
 Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>, 
 linux-xfs@vger.kernel.org, codemender-patching+linux@google.com
In-Reply-To: <20260316184200.840020-1-morbo@google.com>
References: <20260303015646.2796170-1-morbo@google.com>
 <20260316184200.840020-1-morbo@google.com>
Subject: Re: [PATCH v2] xfs: annotate struct xfs_attr_list_context with
 __counted_by_ptr
Message-Id: <177382875793.271956.17392392871867238671.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 11:12:37 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 16 Mar 2026 18:41:58 +0000, Bill Wendling wrote:
> Add the `__counted_by_ptr` attribute to the `buffer` field of `struct
> xfs_attr_list_context`. This field is used to point to a buffer of
> size `bufsize`.
> 
> The `buffer` field is assigned in:
> 1. `xfs_ioc_attr_list` in `fs/xfs/xfs_handle.c`
> 2. `xfs_xattr_list` in `fs/xfs/xfs_xattr.c`
> 3. `xfs_getparents` in `fs/xfs/xfs_handle.c` (implicitly initialized to NULL)
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
      commit: e5966096d0856d071269cb5928d6bc33342d2dfd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

