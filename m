Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002F418A92F;
	Wed, 10 Jun 2026 02:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781058088; cv=none; b=SURf48aXqNFjfNdC4i7zV24oatCcyJjUSPILqExFnwrpowGZfM4Z2YhrwXQJ4H9Vm2piNZ32k1/ovxwmQoz7KAC5b0jlSdUDsKMpOl/ZiqnOFhIlMFu2oJnQIYMm4WJu6cjArJDkLOL9R5IVihhgq5JY58zVNOgHwSX9yMXAsQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781058088; c=relaxed/simple;
	bh=gbpuBTeU17SdSXnpOvKz9hOWcWFbWZ6lqnh0u7bY5+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hQJ1UqqFuNOMJkxUJwx+J2hdpZZ37+IldNkq17WYGbnVsx/oRtp0JZCRRLBBMZfsar9iIIUVsG6nX240BoT/2UPDpFklQy4fDttiEPg/rB1/7k/2zs9fVtPmnGBdmNUhMVe3nlbIY7B6G035LRKKiMDrVyh0geh+1lXn1uEofVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IQxaL9sP; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IQxaL9sP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781058072;
	bh=sWwNEq8PjeuGp2AxBPwr9eEAuNXwpfqFST1e3+sy8D0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=IQxaL9sPa8A7qSFCGfVNae3Uqlwww5Hs3GqsOv1TlPI+AzVLCN0rFp8W6jzwM0OSX
	 KtNgwBEiydreyy/SHalbCHVBo63WtAB1DO677Vlf17UJTdOQd6ZPLqiohOMNVZmwGK
	 8JIWP6RKj6QzX0W2qagiCnvC1pX3qsXbtyQyOAXY=
X-QQ-mid: zesmtpgz1t1781058067tafc53c03
X-QQ-Originating-IP: dSr6Gmd5pUHn5/ziyKQ3neZxtfBFaA24Q8quLqbrleI=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 10:21:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17177030974009897277
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v2 0/2] xfs: fix inode leak and clean up attr intent recovery
Date: Wed, 10 Jun 2026 10:20:26 +0800
Message-Id: <20260610022028.79846-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NC2w3cfSaNL61pBCkx0T7oFCekOIcsWLDAMzIkZS5AgHxyfc7zsMLIHt
	3YdmbxsXR+4hJlIMQKJMugIOQDqZq5l0yuEokUuzBm3XyAEuqnZexsuPJ5fZhO44Txix2hO
	UbTNsc8NCll+rNFrFBjPNp49leBnpzGA7KFBL9URtivDnwwH1e3WLPI9Wukr+Dq/D/oQP/v
	tislSCQDAN2atoVbpMrSdvHHY6ZnWj+Zcp20pSA2En2TqoBur6oVuUIjFQP+cFAPcFG0kqH
	rT0dIaEqP3pHswf9q7lfgBHYWuNxdJEhOi4w5PXnNY/TsLW0TA9qvF4TMDu+fAHcx8TQ6GP
	MHM/NapRhlQKvAWvz8PRIQIJVrCQY6igKIVkiyMEmffchqJpfDXY6GXQG2X147HVJLHB6Gn
	dEQ01SVKEz7LzPsPmW6u0jNXfvjZ/2CHhWTO7/JB6JSFzl1FNMj8qQ0+Wlfh0jn1pv+CyET
	ItydZdgiTbyPP99PTwmvXn1gyA1TjXBlc6HyKigFKdNWPE+9eLsAi5s49QGOyuf4G4C5ZSC
	cJbGFYwmMMAZ9IDdcQlyLu6vQuTq2AuXRLIEZv66i50NtEHXaPs93zZT4xs6Oc7GjwOKIWY
	ErK7E6Coud00542p6YL7PUI6ifZ1JYKMDieL1fuWpaem+vsmAii92jPRGwjm4eVrfkNfEn9
	hijIHy0fpQGOMjMiMkBEr5RGkNSc0DjzaMv6VrmtQf+M/E8LYwN5IwAyhffhgazmFPRI+Do
	rNKmtdgFCrQPE6gzCY7iiNWzu7bwAazgUoUTT+NSWkS5rI+9Jc/zz4tAw4SUZqnW03ZAOFw
	Nc+eRBjSk6RNWemdSngICzx+2oZY8ZgSehZZksBwxqbtdartMq9Pd0XqZDDHCrPS8tGmNLm
	MOKQQ8XNsNc1jjXb8HNkdq2vZ1Ikrjy/WIoS30pkgptZWTEKp/48W7B8axfB+lXtkrvTNNt
	mssJJlsSCBH7qNFyUoZP0ddgF/qkC1j6LX7LWZy25A0qWNv2aNlcxtp1osmkaiMiJH9Llm9
	eVmcGL87Q+WiX5pJ6gT8VFvrMtfdWvpdZ0jO38x27rY8HY/zBsx1ovThOMb69+TzXF1bgpC
	Q==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hi all,

The first patch fixes a leaked inode reference in
xfs_attr_recover_work() when transaction allocation fails after the
recovered attr work item has been attached to the defer pending list.

The second patch cleans up the same function's exit paths so they follow
the same linear cleanup style as the neighboring bmap and exchmaps
recovery helpers, and initializes the local error variable in the same
style.

Changes since v1:
- route the transaction allocation failure through out_rele in patch 1,
  as Darrick suggested;
- keep patch 2 focused on the remaining cleanup-path reshaping and the
  local error initialization.

Thanks,
Yingjie

Yingjie Gao (2):
  xfs: fix inode ref leak in attr intent recovery
  xfs: clean up attr intent recovery error paths

 fs/xfs/xfs_attr_item.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

-- 
2.20.1
