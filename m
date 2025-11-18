Received: from mail-m15592.qiye.163.com (mail-m15592.qiye.163.com [101.71.155.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65480280CE0
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 11:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763463987; cv=none; b=Pgk8PAgdy0zboPRJVaO7Xgqyz26RuYI7mET/Zpv28pypBwfmObSNpkmDFJWng7Bm+roLsoS8CWQHD978XAf54+J83fQ+jrxzywQ+AzFLYHXMto0QzPhKTTQZ3uS0kChkr4L1g3MSMPkdwdYnF/aQnjwcon7mDnM8jm6U9YNEsG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763463987; c=relaxed/simple;
	bh=2z5aQ0vWLI3kcmrOdOv2zLqVJ5jrXa47br9lDZqAmfY=;
	h=Content-Type:Message-ID:To:Cc:Subject:MIME-Version:From:Date; b=CgRyIxE6q2dsjWrH3AOSg7G5b/JMP8xfUb4wmmkyOU7jk23fRqi35Clrn3Smms6dXRVhEPNHpWrZU/LiyID59kwsMzy1OONK0ID9OC+ZrK+Gtq7htsdEvtOLmJhIlPKrsaY4co4WqrH90PuXC8PQfozo8hDQ+wiK1nTtLlCDXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=en0+dxec; arc=none smtp.client-ip=101.71.155.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="en0+dxec"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AA6A7gB4JrG-pMrNGmqTzap7.1.1763463974419.Hmail.2200013188@stu.pku.edu.cn>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, cem <cem@kernel.org>
Subject: =?UTF-8?B?W0JVR10geGZzOiBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4geGZzX2J1Zi5oOiB4ZnNfYnVmX2RhZGRyKCk=?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_MAC_1.55.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 2200013188@stu.pku.edu.cn( [210.73.43.101] ) by ajax-webmail ( [127.0.0.1] ) ; Tue, 18 Nov 2025 19:06:14 +0800 (GMT+08:00)
From: =?UTF-8?B?5p2O5aSp5a6H?= <lty218@stu.pku.edu.cn>
Date: Tue, 18 Nov 2025 19:06:14 +0800 (GMT+08:00)
X-HM-Tid: 0a9a969bf57109b6kunm203372683e77
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMYTqrvk2VXm1s3jojcL7ki9S5UDbyOJxmDzs8e
	YzTqMdKwpWKMh6NnGmqzdrLX2gtTey0Qdv8YXgJND7/w1b1SByRcTnbLhobfrm77yNE9B7x4QpAb
	f1ToWR97W4vyvs9YOdxlfU36A3TtdUm6C01vU=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGU5JVkpCTh8ZQklCHRhNQlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlJSktVTEhVT0hVSktKWVdZFhoPEhUdFFlBWU9LSFVKS0hKTk5IVUpLS1
	VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=en0+dxeckYNTdYygY+U7bC4T73Lxvjy8N7X0t0Tvu6qm3cpkvZEkg4bG9GtADGrjAt/7jSPDRrQgsFJtLHdHHvR7LM+0HAPKcS1giLR5tZTTzDXU398UrQgqsRhF/JItjGtda2JEH71dbWxygf8JhAoySG2DTWZl+7aVlgPGHK0=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=2z5aQ0vWLI3kcmrOdOv2zLqVJ5jrXa47br9lDZqAmfY=;
	h=date:mime-version:subject:message-id:from;

VGhlIGtlcm5lbCByZXBvcnRzIGEga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSB3aGVu
IHRoZSBzeXNfbW91bnQgaXMgY2FsbGVkLiBUaGlzIGlzIHRyaWdnZXJlZCBieSB0aGUgc3RhdGVt
ZW50IGJfbWFwc1swXSwgd2hlcmUgYl9tYXBzIGlzIE5VTEwuCgpUaGlzIGJ1ZyB3YXMgZGlzY292
ZXJlZCB0aHJvdWdoIGEgZnV6emluZyBmcmFtZXdvcmsgb24gTGludXggdjYuMih4ODZfNjQsIFFF
TVUpLiBTaW5jZSBubyByZXByb2R1Y2luZyBjb2RlIGlzIGxlZnQsIHdlIGhhdmUgb25seSB0aGUg
cmVwb3J0IHRvIGFuYWx5emUuIEkgaGF2ZSBjaGVja2VkIHRoZSBzdGFjayBmcmFtZSBhbmQgcmVs
ZXZhbnQgY29kZS4gQWZ0ZXIgY29tcGFyaW5nIGl0IHdpdGggdGhlIG1haW5saW5lIGNvZGUsIHRo
ZSBidWdneSBjb2RlIGF0IHhmc19idWYuaDozMzMgYW5kIGF0IHhmc19idHJlZS5jOjE5MDIgKGxp
bmVzIGFjY29yZGluZyB0byByYzUgb24gbWFpbmxpbmUpIHJlbWFpbnMgdW5jaGFuZ2VkLiBUaGVy
ZWZvcmUsIEkgc3VzcGVjdCB0aGF0IHRoaXMgYnVnIGNvdWxkIGFsc28gb2NjdXIgaW4gdGhlIGxh
dGVzdCBrZXJuZWwuCgpUbyBkZXRlcm1pbmUgd2h5IGJfbWFwcyBpcyBOVUxMLCBJIHJldmlld2Vk
IGFsbCBzdGF0ZW1lbnRzIGludm9sdmluZyBiX21hcHMgYW5kIGZvdW5kIG9ubHkgMiBhc3NpZ25t
ZW50cyB0byBiX21hcHM6IGF0IHhmc19idWYuYzoyOTYvMjk4LiBUaHVzLCBJIGJlbGlldmUgdGhl
IGlzc3VlIG1heSBiZSBkdWUgdG8gb25lIG9mIHRoZSBmb2xsb3dpbmcgcmVhc29uczoKMS4gQXQg
eGZzX2J1Zi5jOiB4ZnNfYnVmX2FsbG9jKCksIG5vIHByb3BlciB2YWx1ZSBpcyBzZXQgZm9yIGJf
bWFwcywgd2hpY2ggc2VlbXMgdW5saWtlbHkuCjIuIFJhY2UgY29uZGl0aW9ucyBtYXkgaGF2ZSBv
Y2N1cnJlZCwgY2F1c2luZyB0aGUgYl9tYXBzIGZpZWxkIHRvIGJlIGFjY2Vzc2VkIGJlZm9yZSBw
cm9wZXJseSBpbml0aWFsaXplZC4KCkEgc2ltcGxlIGZpeCBtaWdodCBiZSB0byBlbnN1cmUgYnAt
Jmd0O2JfbWFwcyBpcyBub3QgTlVMTCBpbiB4ZnNfYnVmX2RhZGRyKCksIGJ1dCB0aGlzIGRvZXMg
bm90IGFkZHJlc3MgdGhlIHJvb3QgY2F1c2Ugb2YgdGhlIHByb2JsZW0uIEl0IG1heSBiZSBiZXR0
ZXIgdG8gaW52ZXN0aWdhdGUgd2hldGhlciB0aGVyZSBjb3VsZCBiZSBhIHNpdHVhdGlvbiB3aGVy
ZSB0aGUgdXNhZ2Ugb2NjdXJzIGJlZm9yZSBpbml0aWFsaXphdGlvbi4KSSBob3BlIHRoaXMgYW5h
bHlzaXMgaGVscHMgcHJvdmlkZSBtb3JlIGNsYXJpdHkuCgpUZXN0IGVudmlyb25tZW50LCBjb25m
aWd1cmF0aW9uLCBhbmQga2VybmVsIGxvZ3MgYXJlIGxpc3RlZCBiZWxvdzoKCglLZXJuZWwgNi4y
OiBodHRwczovL3d3dy5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwvdjYueC9saW51eC02LjIu
dGFyLmd6CglDb25maWd1cmF0aW9uOiBodHRwczovL2dpdGh1Yi5jb20vV3htLTIzMy9LQ29uZmln
RnV6el9SZXByb3MvcmF3L3JlZnMvaGVhZHMvbWFzdGVyLzYyLWNvbmZpZwoJS2VybmVsIGxvZzog
aHR0cHM6Ly9naXRodWIuY29tL2oxYWthaS9LQ29uZmlnRnV6el9idWcvcmF3L2Q1MDgwOGZlMzFk
NWZjMzA3Y2MwZWI1N2YwY2IyOWJjNGZhNTM3ZDIveDg2L2NyYXNoZXMtcGFydDEvMDAwOF8wYjhl
ZWE3ZDM5NzEwZDk3ZGNmMWJjNDhkMzZhYzAzODI2OWE1ZTdlL3g4Nl82Ml82Nl9zeXprYWxsZXJf
MDkwNC0yXzYuMl94aWFuK3lpbi9yZXBvcnQwDQoNCg==
