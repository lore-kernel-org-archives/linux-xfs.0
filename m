Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822837;
	b=YYd5Md1puLE4oEEldfMgIqv4Qa0Z7+MJF9f2HxyP+SH32bCUFWIaRYpT8DxfaYRbRh2k
	 G7BqhkddVILP2XAW3z1y1BCujmtw+OPrbasWJg/9j8yfJ9ESZ4xxhEZf3I/vWg4dfGvlT
	 CK7AEGEY1ahGV+s3VuUJSqNDatdE+gFbptquuYQq5cfx5cg7mRTeZ6Df/godz9yDILovr
	 5Ao6NVw5Hx6yQ0XFp1lOqnRP/RD/lcXEUSJpImlhGV2K2M2ofEj6uwWfqeOedHMFQ2Q9E
	 jgCrRKRo004M92RN8/iSX3jsnWBFuLwt2PORZcoOplePIYTLyBB52lu4v2CiWbZHjUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822837;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZJJAwrYiVuc03fJzpQ6JP1zmHcGVR+cvTb2BYqmzziU=;
	b=SmBS51cPH3PWL4p1jqfbfTq67blorvOMeFK7DxAbpTikmv/sKwdK/23rVrjrD5duUpwW
	 1YzRuPTp5LYuMFr3z9AcvPq6hcCQO+jJE9G5hU286/QRxNC3ol6K0gUWch+zPGKXm1W1d
	 iiudvyXcFS44DvzIajhNo5tJvWeoZKwKEPCoYTgl3/mwmGPxECohO901/oxazAcAQ3lK4
	 EswWtQfuYqppzLRfRc4DxqxF0z+xjuaeTBVrwhC1qikXB0UL/7YYCnXip2W7uUf49iQlC
	 2/VCzE1AkAZy0tioaJxXwdgbxnPkTJAlkti/8EGvWGbNbqaf1P3TFVM7ooqKeDum4Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITfVd9wI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67714606A32F;
	Mon, 16 Nov 2026 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITfVd9wI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755391F000C4;
	Mon, 16 Nov 2026 09:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822837;
	bh=ZJJAwrYiVuc03fJzpQ6JP1zmHcGVR+cvTb2BYqmzziU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ITfVd9wIQ+nAJl70v53f42aDy/XLw55ZzF4oM5tblfEkuK2iHhD8qpLtJZT0c0P+n
	 HTtvLYBRLgESb81dQJ9PMlL8Si8rguYAg3MfEHU2CYldhRS9twbkP4WgHCBwgFXQT7
	 b78SqT79oeCU7aHqQl3icLQCvN74FKTQYOIdftgBB/Pp9sTlail+VAzkjVRGlSgVUB
	 wx6NDyYG0eJRW9+VWuvkpQkOs6ju3VgVddH1fqrpvs7U8MQOKu6shGaFMeZPkgQmZS
	 O/Y6znUt0e5V4BVxF51ykZt+7guJX6IM2GRfuJSgYd1WbVXBzS0acGGTp0MhvwaUCn
	 TYQGj8hI8awFA==
Date: Mon, 16 Nov 2026 10:53:49 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>, 
	Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/33] fs: don't set SB_RDONLY after filesystem errors
Message-ID: <20261116-kiesel-exekutive-liedchen-26b1c45fe533@brauner>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>

This is now on vfs-7.5.super. There's a bunch of outstanding
pre-existing fixes per-filesystems. So please, if you're a filesystem
maintainer take a look.

I will declare this series ready, otherwise this will turn from the yak
shaving that this is right now into yak-herd shaving.
