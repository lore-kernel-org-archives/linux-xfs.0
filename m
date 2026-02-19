Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F53033E9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506983; cv=none; b=YHNzKuyeVpTuXAomb/9qxcxii7spfm+zdYWoGl4qT+PmWuhBoF3qnULo26fTeQ8a81UrYRHJZDSApbughpV6CJ38IkCZfHyHvvifU3kcv/UehJGLryBbZqGMZ0Uk+zQG382H1Y7a86wKvovZHZGReleSbHNXQEVMwF+qSM0rUMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506983; c=relaxed/simple;
	bh=DbA0pVvkD81yH1UFr/+teBp0AtmqQoNA59E1qisFcRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKmr7DpHtF5HsrKG5CakFzr6guv46VTwWiHymjKZU+YmgFiwStMR6kKOdTxJ0VBKKX8IoCujZbybMQlgYbbPmhzRETOkep1V4LieQ/wA9EudO7Zt8BNASGNcybfhHO5gwzkSKNnZchu1XPlARabI6HOlnii6OxTMbLEgvXF8ZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QMseGHyh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QMseGHyh"
Received: from macsyma.thunk.org (pool-173-48-113-47.bstnma.fios.verizon.net [173.48.113.47])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 61JDEfrH015259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 08:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1771506893; bh=YvzVGXRA9tq4Mexi8H81CMjCPQQmDTjjwr0q5r4ZxjY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=QMseGHyhfBaFWPX10hbUsMCruhrhgp9Y/y2cMCXsfRSODON0B5P+fIp1gbQDE498j
	 3kKA0mEvpnBkxC4fOP6ZE400XvESf8AzQ8W4hQYtEoVmenggeiuCZAsgDBp1wUb2cT
	 X6xiagrW3q1RCtta1iKSfDQKms5OjV5lnfxVAv8Q2AfkIOYoMk37GhEy8mDWLba8oU
	 +wzfcZxoHjbivvm4nlALGSOE0Sgx0+Y+qu96lZShmvpLYtEHFmEOzfCJdgvL6N1a6T
	 adL+YMa067AgExO/2xBFBiPTBuMQzJwlEaf6kQsPMFWsEHJLIbYxEGHfhvJQevk+z6
	 +8ydG6It0w42g==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 51D465919577; Thu, 19 Feb 2026 08:14:41 -0500 (EST)
Date: Thu, 19 Feb 2026 08:14:41 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org,
        sj1557.seo@samsung.com, yuezhang.mo@sony.com,
        almaz.alexandrovich@paragon-software.com, slava@dubeyko.com,
        glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
        adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org,
        pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
        trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org,
        chao@kernel.org, hansg@kernel.org, senozhatsky@chromium.org,
        Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v8 08/17] ext4: Report case sensitivity in fileattr_get
Message-ID: <20260219131441.GA69183@macsyma-wired.lan>
References: <20260217214741.1928576-1-cel@kernel.org>
 <20260217214741.1928576-9-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217214741.1928576-9-cel@kernel.org>

On Tue, Feb 17, 2026 at 04:47:32PM -0500, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Report ext4's case sensitivity behavior via the FS_XFLAG_CASEFOLD
> flag. ext4 always preserves case at rest.
> 
> Case sensitivity is a per-directory setting in ext4. If the queried
> inode is a casefolded directory, report case-insensitive; otherwise
> report case-sensitive (standard POSIX behavior).
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Acked-by: Theodore Ts'o <tytso@mit.edu>
