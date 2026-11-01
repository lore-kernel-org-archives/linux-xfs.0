Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550477;
	b=f0zMzjEO8sSK25o3TgMnXX6PuUaY7Wc9pL74rhlZac6QQooS46nwqIF+IH5itXL9UQoQ
	 oqB0TxJSrpkNRsD03EGZU2Crh3YsONgjweCxWtkwclX6EvkTs4JbqpKfDzTMkd15ghTAI
	 OIXfDIxPKJt/nGfhAckcQ5ICaKnh7itu74vRej85OrSx+NJJNnsVqWTNY5VDG3dEpHaBp
	 Z8uFmOTVBJbpvcTuIEVac/OojRyrvPKMJxKR46CrULa1v5H7sHr6k9+HZdHFaf6uJdtZK
	 71ddXbC1HRcKXun0EwrcDfAIvcDo2vpncr28Jy2gIabSG0wBr6mhQ0xsTCBqWKQXgLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tc5C0CNkfJTLARpctHnevx+G/1G/OIJl59fgi/hJAQ4=;
	b=m3KTLcwzzYbrunAoVakSH3PSFlp+fWYH/o9S+4JN/Y7DuP5/HVXNRMW8bKQOhaxxVNtI
	 ndS1keeKZuBcPH3aoxaE1yvCdmb0YgvQSZ49/8OnQVJRo/4ZANG7mrDCgdCwP8UgurI28
	 gybTW0WoMN2YarDTBr90Hb5yH7l1xbYufVaXUlg2iz5104r/lOpvVFbQsaBLnysKyFjfZ
	 CssNbwIVGq6UO/25/2M7XUQpbFdp+VVEoJ4jbrgzWzQOxjSaSojX/b04KfhTH9jiFXYLa
	 tBxVO9o4LJ0cBnqJ6N+0OKuLucTs4r4py2Zc4cCVdrKTJD7TGgToYiERWXUHNdKyKNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xcmuoaU4;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D152606A324
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D152606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xcmuoaU4
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a215e64962so20673025e9.1
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550476; x=1794155276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tc5C0CNkfJTLARpctHnevx+G/1G/OIJl59fgi/hJAQ4=;
        b=xcmuoaU4AtnjGXzEwG4THXulwnIcdxklU9rBQdL2qX7AqhbNPrLc+oDjZCgzpaMF3z
         8pqINRg1YPiTgQoG/xy7Y6LX1HseECus+exrWTf07ap7jXJS7TQ/DzDL7MX1BdxU0plJ
         QkGHg2+VClitwc7Vg1LZ0+EoqeVhAo88495zIAblk5Y8lA4192IsE1rOeDFCbv3vPsQJ
         MXSBQbWKibi12KXJUD7auQncWq5f7F7H5YvrM4bGKI4f4rvBYbE8GmrBPKK9phXDfTN/
         M5ksD+IJCPlKCUzNy0OMFtKBmV3D8RI1z+YyyGZ4e2kT87dqYA1CbE9m5jaLSDP16rj2
         DcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550476; x=1794155276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tc5C0CNkfJTLARpctHnevx+G/1G/OIJl59fgi/hJAQ4=;
        b=UjhRnXgtfBQ9u/ECAVUNxfM++4owpX6FSuUhBwaIvEN3Y9XwUsf09Y3HgU/DlSQaZm
         gl+cf3zuefKntD+gxwx6iR0NGzo055++BzKCMMaaxLsrNYldihw/BCTlVryJiS2Ob7Hh
         pt8KtVtLau93/hxgkmd57ApZQtfX3/mXywNxdcc4e3hYisnBv0ys3ZdBuRmowFcFWYwz
         foNbfZMSTT/QTFmAfHN2fgKIH6y9mEAGJA/a5T6QfHC9mXMswqnJl00IeO7RrEHprAni
         VfDKCpCNHlbztqgAUvTCwANApuxF7Nsqg+ZM2jhr4WshU7x/9+MA53bbWgMzP7MHA3IV
         BPQA==
X-Gm-Message-State: AFq9FYLS2ThH9GTofxADc/ejx0krt8ICgAB0jGKp2NmGfQ67Y7d7cHy+
	nMUWo7GWvzUNzMrmgPShvEp6IVhr2P8m4K+GH7cK8WvpCGtLItE5KExGkAek
X-Gm-Gg: AYBFou3l4D26OUjNkUXuO57tk2XS0ayl7OPEAxx/1PmVe/hMQWE/Ki6u+g7E8QnhPDf
	U/EaVtOwgFFvmrOLONtLfldeyfSt6BlRL8rIArWjmtyXb0TaQLV4bvwl1lF27Oujg+bRXmbDSS1
	jaxmfROUdoZL8MO02uhK9VLpyw8yBzxUzrCxGclPtRTTLdUoa7AzejTk2SRL9LIN3Mk7tfK40f8
	teWPrf6WORaF7k2quvT9EuaWlVozHS7fqlHCupBXvhsmxYtMqpdB2Tl0UxSn1kePXH9O4yDo5FM
	IaGljmQgrKh6p0Ql9Jt8kc3pS4C67vnJlFA+B/AFNhOBHEaScjfLxxSoYVpbUC7iQOLV83Lhdh9
	9/9ziF1o9hxXkYiQfd8rPB/DGKNweeSglZ7Qg9+KrtouDNS+gQl3dMtHU6fFgqMz65h/yfgP8hc
	2Fncq1nfvzj1QW4dGbUObvGHE5fYeSiv8mdT+9C0xazyYWjJHeKjWsLS/hranW73qxTsWIavlUa
	lypLHex8dM9Qn2MovTUQFcP6ztu41JMDk42h/8UpRDm3rUZf7Y1wM0A13AQPvOd+/yexo2e7RmJ
	J9apXjeo/FGrvMRzWJlqYAl1mfBGgn0a1A==
X-Received: by 2002:a05:600c:3b0e:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4ac150b2243mr196741005e9.2.1793550475599;
        Sun, 01 Nov 2026 08:27:55 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0a66caefsm167095245e9.5.2026.11.01.08.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:27:54 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsdump 0/2] xfsdump: replace assert-only validation with runtime checks
Date: Sun,  1 Nov 2026 16:27:51 +0000
Message-ID: <20261101162753.1443201-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

These two patches replace assert()-only validation in xfsrestore's
archive parsing with runtime bounds checks. The asserts are compiled
out in release builds (-DNDEBUG), leaving the on-disk dh_sz and ah_sz
fields unchecked when processing dump archives.

Both patches follow the same pattern: replace the assert() with an
if-check that returns RV_CORRUPT on invalid values.

Tristan Madani (2):
  xfsrestore: validate dh_sz in read_dirent() before reading name data
  xfsrestore: validate ah_sz in restore_extattr() before reading attribute data

 restore/content.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--
2.53.0

