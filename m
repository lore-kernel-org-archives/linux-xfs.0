Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794447442;
	b=mST/qtk5Nw7iH7Txn/JMq87Ok3vvhFh8/qdKJ72rPS0DgzW9By1Ti33xzoj63Sepm/ju
	 6kXxNWtnL7NzaF78SGDGnDobrr0V8XEdJImMawYnbw0wm54YMkVFxh7aKZwfjySscMLQo
	 rpH/9K0SEqsHF/tW+vffIgqRb/DdSyTrMrRrzAfakpYeoO3GoQrfmo5yMIpr4GLQSGRlp
	 uehi0t5ISO972q6h8ZsmwQ93JYJ+I0wfOsgEHcr9tfkNlWvXoJtychIiNobpBo8/CNFCR
	 ZYg0ySu02z4vaZa3zCEBVJ0OSrbeCJSfUBfEFzwrx4m8Gz4Tr0vPs1o9wtjHdKO9MQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447442;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=/zJ+QBWYT8ns8byJevQlnWL1Hj99C+Kapq5rIS5NlBM=;
	b=m+3Rt9VccT5iiGVsjhzSYlGhGOcKvCJizMGuRIU1OmtMZZYf9vHEFSmIkRC0QryB0TEI
	 h8l0q6/R8prUNrs/6nk4d6bVeTLzd6sSHwW/Ia40BfE+dvjrptDhbwVS0DXnYeXzA6Yfm
	 NgrUSa8Hp9bdNWkSPJnxkpXZ/EsVZ6S+cP7nuqdcwPUkfqwDXsH09l5pe+lgp+luNl33u
	 oXIzeB59u/t0kQS1WdIrFD2sOAkHb4DKe/Z49FwpG+u4h/zaIK57w+lCEN8ZKLmnRzY9+
	 Hx26/wdj0iJWMJJeuqLRWyJD7nHbdO8arTJvUFm0jgMcvFgoUoiyk9PM1vl4D/OxCUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S734oHr7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CC2606A326;
	Thu, 12 Nov 2026 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S734oHr7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794447441;
	b=3I4A7sPndC1nVOYYhwAhm+LtuB2+tfRC//8HzKadmCQWaWsQzMyhheJnqdwz88rmtkLD
	 7JHRBVfOw5PHMBkWE8Ce7s1yHk/3W1n7FWFLjXSne2+4k4BT6rgLRUZk6wXxJGQR4j+0w
	 4bKbKOM4Lv6mHTEDroPkRo4ZCNxLkOUDOs148aLdG4J9G06h/asqZNKJCkZCzcg4WNGK8
	 GydImvZBWVBez8hkIPugTcROtSqctJOq6o0Sn9EBd3oDwRVDJDsZCkD6WKqHRfMLiNaut
	 2aGJOCreu5guO6Ife3bU+VNWgzyOk0nUxj7O5SGhI7b8lkIpzv1QQ9NJlGjOMDMRwEQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794447441;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=/zJ+QBWYT8ns8byJevQlnWL1Hj99C+Kapq5rIS5NlBM=;
	b=XuIRUps3iA4caHowvMT6fi3tYXgBYgdYnvH/ZEzE0MEp5Y0XBqKOVF6E2uo87LxQeciX
	 yY6mnjHNc7qhfK/NUTuSlPYY0e8oqOo7JpS46FUhXzNLv6YjZJJkgu7NDOn0J8IsNBmCT
	 wznqIUt04sVwLUI9kcLRSzq33VX7yq8VEOu07vhZxEf/4+/U3/rC2ao49+a5tgifmatr0
	 Zi+uyNcnC39oMJ7wsHmW7Uust5d9Eqe8V1mKCH94zmBHkfimpduQ80qQmZ4/xIRb9MyE1
	 8oNVEkTiSnMHod3qjnrpt4ql+X7/icuOjnbhXnkdYPcz7tLS8ErMBLLEfvHnGh2EJDQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D0AF01F00A09;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447441;
	bh=/zJ+QBWYT8ns8byJevQlnWL1Hj99C+Kapq5rIS5NlBM=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=S734oHr7eNkvy4gjs/Bn7hfc+Tk57g/QwWOXCux/RSmFwX9j3yzYY6nm7Rf08nOUa
	 bkmb2BIziwLs2h3jfHbC65hUALiHaB5GMmGOpSHwPOx+JvJ3PWQ0BqJAD9Ms5e0gkt
	 15fAlvfNfghb+gQOdJGWOz1FRYfZzIFQ/FPoOGUdYcW45njIE4a7dnn86N0vl4TbE8
	 4xyWLbYVqA0DBRAWHrFfP9nW0qGxzyGztxoYRDi5JkUfjPdolPtWm6DSdejaKuByU/
	 Gnvy7nyMOmpkJNpu7GH1jRY782KlK+GfTMG+ZXBzEItuxFixUPAAPZzyGTTBoflgD0
	 cfjPX+lpsJeVg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B864491B6;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH 0/2] xfs/438: test the dquot retry again
Date: Thu, 12 Nov 2026 10:37:16 +0900
Message-Id: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEwY9WoC/x2Myw5AMBAAf0X2bBNKpPEr4tDqLnvx2CJE/LvG3
 OYw80AkFYrQZg8onRJlmZOUeQbD5OaRUEJyMIVpygReHLGuLIbtWHZU2vVGH5itsc437CCVqxL
 L9V+7/n0/hFAkFGUAAAA=
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Brian Foster <bfoster@redhat.com>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794447436; l=977;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=E0VfzmCyAWgh/Gvr3G6DLo1ndFYwT69Y0tx9eVlLLBk=;
 b=ELg40/h4+AaY+cTKceRIrpCylbe44bs9h1gcrXH6nLKmlIurixHHSwmst3pk2xPJ0SildIS51
 kBpyH3DDcQVCf6fD2DUrs4OFsAdbjnJ1YPL+jPgIV9SWxq3KbDwWxMa
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

Because fstests turns off metadata write retries for XFS scratch
mounts, xfs/438 passes on a kernel that has the bug. Its dm-flakey
table also relies on dm dropping a flush error, and the dm patch [1]
fixes that. Patch 1 turns the retries back on. Patch 2 moves the test
to the buf_ioerror error tag. Tested with an internal and an external
log on v7.4-rc2, with and without [1], and on a kernel with the bug
brought back.

[1] https://lore.kernel.org/r/20261112-dm-flush-data-error-v1-1-c83d3f8f3ac4@samsung.com

---
Daejun Park (2):
      xfs/438: retry failed metadata writes again
      xfs/438: fail metadata writes with the buf_ioerror error tag

 tests/xfs/438 | 89 ++++++++++++++---------------------------------------------
 1 file changed, 20 insertions(+), 69 deletions(-)
---
base-commit: 71641219a506ac62bfa231592394265ca812670e
change-id: 20261111-xfs-438-dquot-retry-bdff828ab6fa

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


