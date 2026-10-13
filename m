Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254F395AE4;
	Tue, 13 Oct 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791877249; cv=none; b=RJoNqwyqDyvKFaINlu16NoCbqnWyKpqLUFJgJfUy+hgloSMKB3IpJZRZNXctgnIZCa/OHMFJHp0YGi+iKrJXnhEyCZJD0wFRx4tRc0g76ca14eLG3U2ZNfAuogX0xeYg8IqaUIbrDtkhvSEH9SV1vqHTis4XNkzw6hE6TKqYGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791877249; c=relaxed/simple;
	bh=ZTnOrsti/2w8yAPqPu5abDI5OT9mEbN9qOXIuqgEeYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPy2HSJzx50dR6jXHBjlzzCroxgh67mawVXAkbESjSuZQ1PiQOgqxXMvnQLXErZRtKL1HQeVmE0cbU4eYam+yIptebHeuv1UXDXik0mGar3p6+0kwSTjPXnH0XxMJSqeaphbij/middSthT6Ffk2D/0E4ZpnZ+Nm726TMFhzX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AaZbjD2s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AaZbjD2s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z8P81LjS8NfdOGd3+gt4wOMwgwV0ZCatSPsh7k6dc2Q=; b=AaZbjD2soi/yvHMBw/9GVnAIAL
	shFTyE+Qr1ymdCPeMyfq5lqtdeYZcJr5NtEdEZX2Vr6tV+OH3rTBCbMSILJa0FCBM5oY1X2nIYdHG
	l2eFb4GevJeSaAAC5jieCXubo7+NvjOvWM5to1Pdk/7OseD8HtAKx2Df7vHzy+xPq2RyWyhU29uJB
	hY54yKFFTpgtZUOGihr6vdbSwshF4EuWVcQDT+aoKgO58YjUwvk0mXiYWfXd3/eMAMBGFOQrta/jK
	wP6eABRMv2mfrN2+yN7hF8PYvYzHoaBLB/FBlXBYjnQR+JBo1ykn4SIKd9wbj1Ec9NexumPlQ90QL
	5Yjx4eTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX7w-0000000CEmo-13nh;
	Tue, 13 Oct 2026 07:40:48 +0000
Date: Tue, 13 Oct 2026 00:40:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 28/28] selftests/filesystems: test xfs remounts after
 a shutdown
Message-ID: <as3ggAvyiKmCEG4v@infradead.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-28-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-28-60743a3dc326@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 12, 2026 at 12:21:13PM +0200, Christian Brauner wrote:
> Add tests for remounting xfs after FS_IOC_SHUTDOWN with the default, the
> logflush and the nologflush flags and after a shutdown that the remount
> to read-only causes itself:
> 
> - option-only remount keeps it read-write
> - remount to read-only works
> - remount to read-write fails with EIO
> 
> For the last variant the image lives on a tmpfs of its own. The test
> punches out the log and shrinks the tmpfs so the log write during the
> remount fails with ENOSPC.

Please make this a xfstests test case, which has the infrastructure
for all this.  And make it generic, as the same shutdown ioctl is
supported by half a dozen file systems, nothing really xfs-specific
here.

