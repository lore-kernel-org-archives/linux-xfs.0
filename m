Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B808C1F63EF;
	Wed, 18 Dec 2024 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734552050; cv=none; b=MYKk5+N/hBJXM3QVZ+EMBTrRK311EE/vlO2vvk96fcVuQ4gh9QiFHoAqKtLwU84OPQuT+eiFbWG/Ns4KTCzrm6/Gy1KVZiOAOJqQVrYn4wMSx69LrLPAFWOv5y8DqZbAMe3SYqyw5fQ4N7g57fXRn95f3rN7Kc25Ao2tw78JRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734552050; c=relaxed/simple;
	bh=aHdOoP210TcHhZvvp742WWJ7QL8YgwtrQkc7hbv5XCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gW32OTisw6303q96T1XGOtrwY8VsX3eIA9aZw0WN+xANwljxcvP8BXZClk0PG+18HjzOQFwobiLCYh/ks6oGXy4vEaeAxhc5Atoc47v3UdolgRIpj/77X3JLzr/x2HhlvAcnPABLMwThLAFPgYbxafR9QEP1+cv3VWz7yC+aS7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw3z0n8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw3z0n8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4181BC4CECD;
	Wed, 18 Dec 2024 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734552050;
	bh=aHdOoP210TcHhZvvp742WWJ7QL8YgwtrQkc7hbv5XCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fw3z0n8sP2EtOjwZ9r76ncjrCSexUaMO7syH6NlleHvjRt6eHTZZBi8dAw62tDcyy
	 39of4DW9iDYJsRwiEEtIyP/A0cxIYSuLa2HmDOJelyfYx5q5no+5/1cuBQX6CZeGnf
	 CPrjQYMlZ4t5S1NtyINGoVJ6MBXR+ABxd5xXT+v6yt0ALT6Mz311/u9a9R4Jy2fYHY
	 eFae81fmdYaVHzHvsK8SS+Cl1It7ebkO97QX8O9RLS2mAs28CY5dgJy4UgZPFA7mrM
	 AMSmYJQeWyVJitdkUfbeuIoeBtnzS4rrJpCPdgLTiGVjrjexcBZzZ4CUbLrkdflVPR
	 rFEmnMuz0459w==
Date: Wed, 18 Dec 2024 12:00:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: syzbot <syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_dquot_detach_buf
Message-ID: <20241218200049.GC6174@frogsfrogsfrogs>
References: <676216ed.050a0220.29fcd0.007e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676216ed.050a0220.29fcd0.007e.GAE@google.com>

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git fixes-6.13_2024-12-18
