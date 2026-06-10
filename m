Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B5C1A6839;
	Wed, 10 Jun 2026 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781119547; cv=none; b=mCa7gfU8jmxhYOx2AZo/hOSQz4YIPiqQovfvJY8MRoMKiuq3yvWGKfUOhFFX2gclWhKzC3fwPF1aMygMqvcsJ7s+1oeZ0gBzFlLrpGAY/PL7l57dmPd+RANtbpZ/S9yXykSZoAKZCDYHptcBfqAmjyu7CErm6Dc/TffpKexadx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781119547; c=relaxed/simple;
	bh=WFWuqCo9h2QdJMTW+mCQx2f4CR0L0xkzEqeDQjGw3Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YSryE4w78VVu2beaKeQH3QJyxBxgDze7C3G2qyWDZ5aKhEzioacEIOz3F7LucsL+kd4jp3CxvPzhwH1CLRpgFiR3uw9lT8e5YoGa3QJKqSTJzMgRg3usCrppxrOSXtvW1m8wW7TSLEcqAdcEEpJU9WF9INUgWNciQl4rGZxgkj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=Y/F5kVJI; arc=none smtp.client-ip=178.154.239.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="Y/F5kVJI"
Received: from mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:2281:0:640:870e:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id E57DD8045F;
	Wed, 10 Jun 2026 22:25:40 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (smtp) with ESMTPSA id cPQTnIPg2W20-gBx7LPjB;
	Wed, 10 Jun 2026 22:25:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1781119540; bh=7+P9mwI0dgMAqNlW/13IePvhGHIL9xk5p1Y0XOcKhvQ=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Y/F5kVJI6OOgqkTu7PHzyL/spcE3gVR5MquZpwBV1LgpB5v8wN4U6XTI2l2X7gKjh
	 n4HJhfWACB/IIPZLvoIkjMW1yWkKbmrWZjEGJKLyvJPyktan3JsfHOsogCga0J0aFw
	 TmCKUr78D1dV1ujaMAjt3wgZOzNe2qH+P6Eu6v/0=
Authentication-Results: mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: hch@infradead.org
Cc: cem@kernel.org,
	m.lobanov@rosa.ru,
	djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH v4 1/2] xfs: skip inode inactivation on a shut down mount
Date: Wed, 10 Jun 2026 22:25:38 +0300
Message-Id: <20260610192538.13202-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <ailUyXryJh3gFZJR@infradead.org>
References: <ailUyXryJh3gFZJR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph,

> we'll probably want another patch to exit early in xfs_qm_dqdetach for
> that case

Before I send that, I went looking for a path that actually reaches it and
couldn't find one in the current tree - so I wanted to check whether you
had a specific case in mind or meant it as hardening.

xfs_qm_dqdetach() only touches the quota subsystem (the final
xfs_qm_dqrele() puts the dquot back on qi->qi_lru) when a dquot is actually
attached, and a dquot can only be attached if m_quotainfo was non-NULL at
attach time.  That leaves two windows:

  - Before setup (failed/partial mount): m_quotainfo is NULL the whole
    time, so nothing ever attaches a dquot - the existing "no dquots
    attached" early return covers it.  (That's the window the v5 series
    fixes, but it faults in dqattach, not dqdetach.)

  - After teardown: every site that frees m_quotainfo reaches it only once
    the attached dquots are already gone - unmount detaches the quota
    inodes and reclaims the rest before xfs_qm_destroy_quotainfo(), and the
    quotacheck-failure path flushes inodegc before dqpurge (0c7273e494dd).
    Runtime quota off doesn't free m_quotainfo at all.

So I don't see a reachable NULL deref today.  I'm happy to still send the
guard as belt-and-suspenders - an early "if (!ip->i_mount->m_quotainfo)
return;", symmetric with the attach-side quota checks, with no Fixes: tag
since there's no regression to point at - if you'd like it for robustness.
Or if you have a path in mind that I've missed, point me at it and I'll fix
the actual teardown ordering instead.

Thanks,
Mikhail
