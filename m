Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBFA3815C6;
	Wed, 27 May 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779899063; cv=none; b=q+Kv2dH45yBHp6wM+dqCILXuq7oURnVLMgnB5c14iHJHzIXgMHKfC9Oi5tUx2fendBNl41aSeVmrDwAoT8/kjFdUqnQOzDc0DOcau1PK5zPeqMB0k5prpFMr+eu7gyVDL9c3u+OI7iN/MgCb5BPIPM9VbtL7OhZUyd0bIu1GhPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779899063; c=relaxed/simple;
	bh=DJ3ZaifqYn0VQCKdxHWWZlSnzoqGur/EM85UsJ8ZE+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dV6g5pZWlLb83Gh5DI7dQygButyIBnZaLWy/lFgsjQOrqnf5BFxQgE5o6Oih0R3ugEdI3oSFMDH+GdORGvNV/PZBeKf1+Etb9Wfa3iB0AoBB2m81kAuJIYZHlvh6Fmw7nTSyLPraiK8k7q6BPyGFhf/ZQFj0uhm1cPoZIAp3Kxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=L1fN0UIz; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="L1fN0UIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1779899061; x=1811435061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJ3ZaifqYn0VQCKdxHWWZlSnzoqGur/EM85UsJ8ZE+o=;
  b=L1fN0UIzU1coLW7bEG3kxlegAxXs3C0TCOz4wxmZd2MOoWPLFDW8wmJC
   eZYnxvTA9iErYS3cqduHmKn/VfDvSUUbKMFFEn9ELr6eJbGfBFRrWhTr6
   zWmQB38jJRjofNerluWOer5dPGTjJHc8mTDYQDVliMoS0zBiyzrl4Km7k
   pJdzJiTpFYg61Bz7+kfP6jg7WfEkViFa69yMIKDP8wR9Fev1iHeZkJI2K
   ns2+ztmdKQ/Lw1Jz7XvNzoBvONwPfY3nwbuRu0ZtWLiVvi/1exdBCObYD
   lSPpDpkwnLKNOcfL1oY00zGcKOVL9oFmZ4yY7VN8VjIiwWz7JdQZ1v6jx
   g==;
X-CSE-ConnectionGUID: t+732PyMRH2YqSw/d+AZ2Q==
X-CSE-MsgGUID: eMCH7QL8STW+gllK7jzoxw==
X-IronPort-AV: E=Sophos;i="6.24,171,1774310400"; 
   d="scan'208";a="20078251"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:24:19 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:19651]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.91:2525] with esmtp (Farcaster)
 id a11e89ab-846e-4a3e-8685-5a080839ce6c; Wed, 27 May 2026 16:24:19 +0000 (UTC)
X-Farcaster-Flow-ID: a11e89ab-846e-4a3e-8685-5a080839ce6c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 16:24:17 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 16:24:17 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <dipiets@amazon.it>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <vbabka@suse.com>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Wed, 27 May 2026 16:24:10 +0000
Message-ID: <20260527162412.19922-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260506123326.17293-1-dipiets@amazon.it>
References: <20260506123326.17293-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ClRoYW5rcyBSaXRlc2ggYW5kIE1hdHRoZXcgZm9yIHRoZSBjb250aW51ZWQgZmVlZGJhY2sgYW5k
IGd1aWRhbmNlIG9uIHRoaXMgdGhyZWFkLgpJJ2QgbGlrZSB0byBzdW1tYXJpemUgd2hlcmUgd2Ug
c3RhbmQgYW5kIGFzayBmb3IgeW91ciBpbnB1dCBvbiB0aGUgYmVzdCBwYXRoIGZvcndhcmQuCgpT
dW1tYXJ5IG9mIGFwcHJvYWNoZXMgdGVzdGVkOgpXZSd2ZSBub3cgYmVuY2htYXJrZWQgYWxsIHBy
b3Bvc2VkIHZhcmlhdGlvbnMgKHBnYmVuY2ggc2ltcGxlLXVwZGF0ZSwgMTAyNCBjbGllbnRzLCAK
OTYtdkNQVSBhcm02NCwgaHVnZV9wYWdlcz1vZmYsIFBSRUVNUFRfTk9ORSBhcHBsaWVkIFsxXSk6
Cgp8IFBhdGNoICAgICAgICAgICAgICAgICAgICAgICAgICB8IENoYW5nZSBMb2NhdGlvbiAgICAg
ICB8IEF2ZyBUUFMgICAgfCAlIHZzIEJhc2VsaW5lIHwKfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tOnw6LS0tLS0tLS0t
LS0tLTp8CnwgQmFzZWxpbmUgKG5vIHBhdGNoKSAgICAgICAgICAgIHwg4oCUICAgICAgICAgICAg
ICAgICAgICAgfCAxMDEsOTc5Ljc1IHwgICAgICAg4oCUICAgICAgIHwKfCB2MSAob3JpZ2luYWws
IGlvbWFwIGNhbGxlcikgICAgfCBmcy9pb21hcC9idWZmZXJlZC1pby5jfCAxNDEsMTk0LjIwIHwg
ICAgKzM4LjQ1JSAgICB8CnwgUml0ZXNoJ3Mgc3VnZ2VzdGlvbiAgICAgICAgICAgIHwgbW0vZmls
ZW1hcC5jICAgICAgICAgIHwgMTM5LDIwMC42MSB8ICAgICszNi41MCUgICAgfAp8IE1hdHRoZXcn
cyBzdWdnZXN0aW9uICAgICAgICAgICB8IG1tL2ZpbGVtYXAuYyAgICAgICAgICB8IDE0Myw4NjMu
ODIgfCAgICArNDEuMDclICAgIHwKfCBrY29tcGFjdGQgYmFja2dyb3VuZCAgICAgICAgICAgfCBt
bS9wYWdlX2FsbG9jLmMgICAgICAgfCAxMzQsMjc4LjQ3IHwgICAgKzMxLjY3JSAgICB8CgoKQWxs
IGFwcHJvYWNoZXMgcmVjb3ZlciBzaWduaWZpY2FudCB0aHJvdWdocHV0LiBUaGUga2NvbXBhY3Rk
IGFwcHJvYWNoIChiYWNrZ3JvdW5kIApjb21wYWN0aW9uIGFuZCByZXR1cm5pbmcgbm9wYWdlIGZv
ciBjb3N0bHkgb3JkZXJzIHdpdGggX19HRlBfTk9SRVRSWSkgYWxpZ25zIHdpdGggdGhlCmFyY2hp
dGVjdHVyYWwgZGlyZWN0aW9uIERhdmUgYW5kIENocmlzdG9waCBwcm9wb3NlZCwga2VlcGluZyBj
b21wYWN0aW9uIG91dCBvZiB0aGUgZGlyZWN0IApyZWNsYWltIHBhdGgsIGFuZCBsaXZlcyBlbnRp
cmVseSBpbiB0aGUgcGFnZSBhbGxvY2F0b3IuIAoKQmFzZWQgb24gdGhlIGRpc2N1c3Npb24sIEkg
c2VlIHR3byBwb3NzaWJsZSBkaXJlY3Rpb25zIGFuZCB3b3VsZCBhcHByZWNpYXRlIHlvdXIgZ3Vp
ZGFuY2U6CgoxLiBQYWdlIGFsbG9jYXRvciBmaXggKG1tL3BhZ2VfYWxsb2MuYyk6IFRoZSBrY29t
cGFjdGQgYmFja2dyb3VuZCBhcHByb2FjaCBhZGRyZXNzZXMgCk1hdHRoZXcncyBjb25jZXJuIHRo
YXQgZmlsZW1hcC5jIHNob3VsZG4ndCBrbm93IGFib3V0IFBBR0VfQUxMT0NfQ09TVExZX09SREVS
LCBhbmQgYWxpZ25zIAp3aXRoIERhdmUncyB2aXNpb24gb2YgcmVtb3ZpbmcgY29tcGFjdGlvbiBm
cm9tIHRoZSBkaXJlY3QgcmVjbGFpbSBwYXRoLgoKMi4gZmlsZW1hcCBmaXggKG1tL2ZpbGVtYXAu
Yyk6IEJvdGggUml0ZXNoJ3MgYW5kIE1hdHRoZXcncyBzdWdnZXN0aW9ucyBhcmUgbWluaW1hbCwg
CmJhY2twb3J0YWJsZSwgYW5kIHByZXNlcnZlIGxpZ2h0d2VpZ2h0IHJlY2xhaW0gZm9yIG5vbi1j
b3N0bHkgb3JkZXJzLiAKUml0ZXNoJ3MgdmFyaWFudCBkaWZmZXJlbnRpYXRlcyBiZXR3ZWVuIGNv
c3RseSBhbmQgbm9uLWNvc3RseSBvcmRlcnMsIHdoaWxlIE1hdHRoZXcncyAKaXMgc2ltcGxlciBh
bmQgcGVyZm9ybXMgYmVzdC4KCldvdWxkIGVpdGhlciBvZiB0aGVzZSBkaXJlY3Rpb25zIGJlIGFj
Y2VwdGFibGUgZm9yIGEgdjMsIG9yIHdvdWxkIHlvdSBwcmVmZXIgYSBkaWZmZXJlbnQgYXBwcm9h
Y2g/CgpJJ20gaGFwcHkgdG8gdGVzdCBhbnkgYWRkaXRpb25hbCB2YXJpYXRpb25zIG9yIGRpcmVj
dGlvbiB0byBtb3ZlIHRoaXMgZm9yd2FyZAoKU2FsdmF0b3JlCgoKWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2FsbC8yMDI2MDQwMzE5MTk0Mi4yMTQxMC0xLWRpcGlldHNAYW1hem9uLml0L1Qv
I204YmFlZWFmNDhhYTdhZTUzNDJjOGMyZGI4ZjRlMWMyN2UwM2MxMzY4CgoKCgpBTUFaT04gREVW
RUxPUE1FTlQgQ0VOVEVSIElUQUxZIFNSTCwgdmlhbGUgTW9udGUgR3JhcHBhIDMvNSwgMjAxMjQg
TWlsYW5vLCBJdGFsaWEsIFJlZ2lzdHJvIGRlbGxlIEltcHJlc2UgZGkgTWlsYW5vIE1vbnphIEJy
aWFuemEgTG9kaSBSRUEgbi4gMjUwNDg1OSwgQ2FwaXRhbGUgU29jaWFsZTogMTAuMDAwIEVVUiBp
LnYuLCBDb2QuIEZpc2MuIGUgUC5JVkEgMTAxMDAwNTA5NjEsIFNvY2lldGEgY29uIFNvY2lvIFVu
aWNvCgoK

