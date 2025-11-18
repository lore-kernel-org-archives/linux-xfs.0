Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1877F325724
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 09:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763459648; cv=none; b=rP9wouG4o4F8UTX538isTh27NDbNrEW7IboyUp8xyW5964/5mVXmF3xUkL3lXnN8KY9V/I99mZ+h1GYCG6Lu85JkN6bqola2ZpDF0h/nJ6xscLVk7qlHagJMB4HtZGDSvUgv3afW7ziN6/I0F0R6ZKiQXHb3zdbyKb9izrm5ths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763459648; c=relaxed/simple;
	bh=QZVIYU1D+53UNjyzsPJfTc/7CW2+2rwtnBOFKszKpkw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ne9391PEIynWCnOW8AJpLOfT9ZW49pr6wNd2BppIqpl/auQrh4psNdKKvpirIWbcwcKZWhsD/gPwtgt+O5yq89+2ipcvwo0FNSXSuOws1u0BfDvrnJypkHp0/8MT5fNBGUo3N1luD9Tg9Obeyvk8wP7FYTSeB6YQfRk+i4YcmPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELshS9WP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELshS9WP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F3FC2BCB5
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 09:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763459647;
	bh=QZVIYU1D+53UNjyzsPJfTc/7CW2+2rwtnBOFKszKpkw=;
	h=Date:From:To:Subject:From;
	b=ELshS9WPfw3B7YrlfrjJnjz4RMOU9GYkjVzFfXvwLhSheqw3UvC2L5fBNQ58MmzfS
	 AvdWxJKV7uHuWhZAx8DzyQe4Fcxcl+sPyDpDOb+fg+B+/IqEiLQlQK2fzNRXSPtVGg
	 d9QFb3NrQwpdjmaQ9/jc1muCpgv3sFeCq+Qhng/l2f6K2Jzp0L7kVlOd91PYxV+JpJ
	 RMuTT7RYPU+Lly5Qhj08ASmYts2EgZJW+O6//ISf7ocECULt0Za1sPdZPZm2w82ntm
	 dEf1IgQ3QPOoxEajPPDyJ/UWrKcj8moahKj3IOsUuS6zTzg4mbkF3+bU+ozP1jd4GD
	 iidfpZCRTuSzw==
Date: Tue, 18 Nov 2025 10:54:02 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9b0305968d60
Message-ID: <nke6jqewffixeqisqnb37kjheeex4fqmlfhz7cpucddrx6cksi@ekbx3rhq5yce>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

9b0305968d60 xfs: remove the unused bv field in struct xfs_gc_bio

1 new commit:

Christoph Hellwig (1):
      [9b0305968d60] xfs: remove the unused bv field in struct xfs_gc_bio

Code Diffstat:

 fs/xfs/xfs_zone_gc.c | 1 -
 1 file changed, 1 deletion(-)
