Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B021CA03;
	Wed, 15 Jul 2026 06:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097331; cv=none; b=f4de3sEMncLFAjcAKEs64Y+FIP5jd7duol8Nab3iHstAHU3vW72Bpg915hplQLrfO3HoRkdgE0IqC0zYBgfS+Xg5tvFgeoh2Ldw8XfbYR9ygZ7SAIyTakON8u63rzJTrA0SkwGuITLz0UDoKcYmWyaMFeFWkBtgRUWoQ+v+iqVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097331; c=relaxed/simple;
	bh=f3vBHKL9VPdlVNb5Kni9nyC7b0E0InbzYet1zLSDFNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bjL2V+TBZ+oq2WMRICHPVw8Qn7ObTTZGaWo7ym9TfktCoHNymKCcWqxnAPf4DSTP3URr6iSwMufC0YzoRk6nPL5RQtX6+LBfUZlrLJFBY+zV/EKA90JjQazSeZZBOI+/kEwI8ZL7QXeefru5nHgxUrfvlyTbnSdDIiQwI8s75jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=mn0EEGSD; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="mn0EEGSD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784097280;
	bh=f3vBHKL9VPdlVNb5Kni9nyC7b0E0InbzYet1zLSDFNg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=mn0EEGSD4gcojRwgDihYbJo0+3kz55Y0Or8s29VyZy+/wNT0M0Rg58AvCYkv7W8Ky
	 MwXoGQmomeR9AGsWJ2dlE2YFzsPrhWG0OS/8YN+RxtVlTG/ZCkM83d1sFQ61GcaeZY
	 kFzHh579EJJdM2bpeyGe3vg8ut/AZ2IUKLUvf5nc=
X-QQ-mid: zesmtpgz9t1784097274t5ee81a18
X-QQ-Originating-IP: WNBiEtHq9Jks960L9igCBecmFkEAVqN63lhxelo994A=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 15 Jul 2026 14:34:32 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13376560487774606206
EX-QQ-RecipientCnt: 6
From: caina <caina@uniontech.com>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH v3] xfs: clean up spelling and grammar errors in comments
Date: Wed, 15 Jul 2026 14:34:32 +0800
Message-Id: <20260715063432.26491-1-caina@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <alO0W1-tul6jgB3l@nidhogg.toxiclabs.cc>
References: <alO0W1-tul6jgB3l@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MBUiZeHMdkkZr5fRHzMJqCVuUWmIlKbbuCP+DboWkul3Cxr6tfhaFIlb
	G7oYlAC3vfYdRwURSbDZZcAYoKHOay596PHsaB7j3mGgb/Ho3KpSb2/AIgXxFks2otj/KHf
	qz+zusLd6+/c1QekUsHVODqF37H9Cfo/q9QlaTxwJ5HpWC+fSBNXrb7sjqOazTK2QjGZQ5P
	tILt0d+4ovgNv21x4WB5cDZUvK7asVeYavG/TAXJZAlNzSr8ulh/ftIuMBrQQI63NC7HOKr
	ZObpG56lAVsIAWma8nbn/GaowXuWbq4QqJrK6Cpxa0iqu38lmwIJjTnKU2CC3WvA1ADIE6R
	DS/s1ulECU8NzaeWrEy+0dLkuw9aLWm0RVer2D5wr+UeS3MIu6ztNH2bugWgJzxAgo5TYOR
	HibOmu3Yb3fmYtjPOfuPidn3U3teMty15ILu5HHafwGr0czeoNxHltORYogXtOGyCewVGlE
	UhCpoC2SZkWwMcEjNSXaqiUwkPwhPVa7LT4KY3k6zQdlAlAd3AbmISQq7O5BKTf/uSvKCsG
	Xqyt7eZwqqIK7dpj0fIDkalJBEuBXjyg187XFbXZcapTECpdl/SdAxA0k9RnPo50QKEaF+C
	j+1N89fDS8f5OPKqjVkfIT3bKjLuK9Itdmqmwe8GBlyXh4Dtbe4+0bOycDSPAosG2xauBC+
	OQbqj6CboJvorgTHonCd1L6oCUvAYQEsDkFS1b7PIUhn2dl9vbgdfrxuS6cCmRkIXf/RdN8
	6U1WtcV9ZgiMmQE1tIk97eIljrrfqCNCZ6nSkOyr05hAbmsahxERa7MpW9hhlJrEZtXatJ4
	SwzTgz/CZ7PzDhysQ+aXjEWsHyf49Cv6zKi66vhqkzOwbjD+ULPSlkqWfC/4y6zgcw3hr9I
	ef0tx8odv8nfjB0ALjbRV4SshLcqwo/lBQpEWVjj6Mw1tx/9+LUkJTMviwXyqMJADyShsHP
	8PWGuUlkk6OaKvmu7VeeH4H50N8JFZgYXtppY0vfYGZLJylGWaIIwWpeN8aBv/o4KCmmoz9
	7m+26p2NWhR1UAxM/F/Disc/x/zUFSyDJnimNdOHwwTiNSTKFy
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

On Fri, Jul 03, 2026 at 05:34:02PM +0800, caina wrote:
> This patch does not apply on top of for-next, please rebase it on top of
> for-next and re-send.

> Also don't forget to Cc me to the patch.

Hi Carlos Maiolino,

Thank you for the reminder. I have rebased the patch onto the latest
for-next branch and sent out v4.

Thanks,
Caina
