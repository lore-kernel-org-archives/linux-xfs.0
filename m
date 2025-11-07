Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4E61D61A3
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 19:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762544879; cv=none; b=qq+1R9D2DSVKWqD9ztRn/rUW+wKU4EvgbeLUg7Q9w7BzXYI0yhV7d5VDcVsKjtGpBcheSjyDiumWR19GYuC7Xumvjduh49BcjUS9OM5x8kcEJHOXwXjnbj9BG3NUATN6Qvcd7sP05nndyZKOGy3sLE6ibqhADoGqVZahQRAGHWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762544879; c=relaxed/simple;
	bh=crDtNp7DFMNFe28/f5JxM9VqAwosYQKkPk4uzhNkWkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SChpDXLnGS8ijXVbTDIkuuzwjptg4jUf1GSx6jVxFWRQvyfDRhuqE3DGJHV4t69ArIwABk2xve5kOGO41i47gqC0ixb1tz4hHMC6LsuEHebbmQVaJMqGhrY8bWgDpQy62RfcpP/68zy42aXbiS7QuD+o5LGurYkDZjhyfbiOJoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rkvbqOoL; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JAQh3Slj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rkvbqOoL";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JAQh3Slj"
Received: from pathway.suse.cz (unknown [10.100.208.146])
	by smtp-out2.suse.de (Postfix) with ESMTP id 9CF432057A;
	Fri,  7 Nov 2025 19:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1762544876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KtC7rzSK0aTgwHJiLrZd7KjHwgNeZ15oPHoIeGdUNXA=;
	b=rkvbqOoLf/C/5wQktFj0MjJl0kWvB1Y/VlxHjJm4yYgjz4pdo+nzkCZ1V1IbsAY+whRSDQ
	8CuVv8FFzC9Sk/cgk8VuWeB3rBfjguZB3bBmqQTT08wgh5S1kls6Sz/KprVLoEkK5pPk2P
	JtchIAocLGTX7/9zj2+n1bQ/IK6D5C0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1762544875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KtC7rzSK0aTgwHJiLrZd7KjHwgNeZ15oPHoIeGdUNXA=;
	b=JAQh3SljtpaRNpy8XtXBtdDrcg6qpsHyxTJ69siFOUXMzSS2fh1Ov9qye8HHQ7UNaWOGHf
	Ou4vNqzCdzWFhe4qkvH5EdXRXLW52AfxJ43Us360WIQbeGPMUM+7tnzlTWpowfNzpRxsr9
	+gAGBHFsXEtmbaOqJeOlNdRoJLXs5+I=
From: Petr Mladek <pmladek@suse.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	"amurray @ thegoodpenguin . co . uk" <amurray@thegoodpenguin.co.uk>,
	brauner@kernel.org,
	chao@kernel.org,
	djwong@kernel.org,
	jaegeuk@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/2] printk_ringbuffer: Fix regression in get_data() and clean up data size checks
Date: Fri,  7 Nov 2025 20:47:18 +0100
Message-ID: <20251107194720.1231457-1-pmladek@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.78 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.907];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,thegoodpenguin.co.uk,kernel.org,lists.sourceforge.net,vger.kernel.org,googlegroups.com,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.78

This is outcome of the long discussion about the regression caused
by 67e1b0052f6bb82 ("printk_ringbuffer: don't needlessly wrap data blocks around"),
see https://lore.kernel.org/all/69096836.a70a0220.88fb8.0006.GAE@google.com/

The 1st patch fixes the regression as agreed, see
https://lore.kernel.org/all/87ecqb3qd0.fsf@jogness.linutronix.de/

The 2nd patch adds a helper function to unify the checks whether
a more space is needed. I did my best to address all the concerns
about various proposed variants.

Note that I called the new helper function "need_more_space()" in the end.
It avoids all the problems with "before" vs. "lt" vs "le",
and "_safe" vs. "_sane" vs. "_bounded".

IMHO, the name "need_more_space()" fits very well in all three
locations, surprisingly even in data_realloc(). But it is possible
that you disagree. Let me know if you hate it ;-)


The patchset applies on top of printk/linux.git, branch for-6.19.
It should apply on top of linux-next as well.

Petr Mladek (2):
  printk_ringbuffer: Fix check of valid data size when blk_lpos
    overflows
  printk_ringbuffer: Create a helper function to decide whether a more
    space is needed

 kernel/printk/printk_ringbuffer.c | 40 +++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

-- 
2.51.1

