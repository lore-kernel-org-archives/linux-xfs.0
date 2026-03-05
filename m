Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E434C377553
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 09:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704072; cv=none; b=QcfX74dsKv5dJ9CtMoDSgDRKm+qfzz4tSD70ht3Pc3i9iXhWjFavUYfxlONbmze5RQZq4Ye49v0LCNRh6JELs6lFv0+SpCVRHTGtKu8WjOUCXyunXwphIQi+XlmZX+c3FQUMC4rBcJgMelrG3jAZRzQcWw62XJmimoN16EPv81w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704072; c=relaxed/simple;
	bh=hyfHXBzOq8IhnP1LW/iq3X031ABzjLYw4vyF9biuwlI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aEknk/sUcoaWc/HWDT1bZiyV/wMkHjBavpfDaiTC0Ysh7Yo/b19UY6uObjDzqtIRridCSb2yBBuBfKd5qQjuX0y29TAW3mzAYGCxI13Pcc2cIJNgRbiyYRZiLCy7JD7PajRb7STR8dFOmUJkgQlGiqKvLaaIJrnUmNh85EI84Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcMzn6Ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcMzn6Ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F84C19423;
	Thu,  5 Mar 2026 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772704071;
	bh=hyfHXBzOq8IhnP1LW/iq3X031ABzjLYw4vyF9biuwlI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jcMzn6NyfNgG0g8Wode/oODUAt6pq5DhRypQJ7H8q/p6xEc6XzcXbqMO0jsWDCPTr
	 XcjmWPknWu/N302M25f96RM4XPzx4/Xa6KCtKYh5HiSm824bypnVltReN2OefAcPih
	 IfQe+2yyKUEIS3hH304lfOfZw0UYVOsOLUE4UCuKbBnEfbuRarDCJW88wlrn4KsZBE
	 uM1fihm4IajtQKk0LgIjxbYUat2OL+4WZUbPCD5rqVhzGjoUijDrUA0fyGZS1HCo58
	 oq8erb9o7VhHJdZgDDCGTnCyPo6zP+dXiizwsRk/uVUZXOq8hvdWiXq6+8jNP4mGFV
	 5sH9Z1Q+MUIJQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20260302173158.GA57948@frogsfrogsfrogs>
References: <20260302173158.GA57948@frogsfrogsfrogs>
Subject: Re: [PATCH v2] xfs: fix race between healthmon unmount and
 read_iter
Message-Id: <177270407059.16288.15362198237587970371.b4-ty@kernel.org>
Date: Thu, 05 Mar 2026 10:47:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 02 Mar 2026 09:31:58 -0800, Darrick J. Wong wrote:
> xfs/1879 on one of my test VMs got stuck due to the xfs_io healthmon
> subcommand sleeping in wait_event_interruptible at:
> 
>  xfs_healthmon_read_iter+0x558/0x5f8 [xfs]
>  vfs_read+0x248/0x320
>  ksys_read+0x78/0x120
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix race between healthmon unmount and read_iter
      commit: 0ca1a8331c0fa5e57844e003a5d667a15b1e002c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

