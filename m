Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D03334C1C
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119134; cv=none; b=bLlmOsTMoEolk7eEOHO0rUnAToy+UU1LjCMmLg4TCIUlQOiw98qwJnHvbFh4KDzDXuBj1uiJBH6K4e1879VpQw9ETkGlbLRttT0WRI9U1dDmWNXzN+W38rOfeyN4Fp0mDhHQKstzVPopNXpCaa23TABPiRCJKI0nHQ4g4OeOGdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119134; c=relaxed/simple;
	bh=RbHm+Qxov4Y7EXI0fgMZE7QQEAMLP3jAVpZvcjFSHGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z8Uiz9bZnsYgjnJOj6A9WVOLmePbS82ZNcpKo3dmluv3W38d1xLv7Ew81rBWBOHIPSraJMA2yVniE+ydvOkkCw//C98VVlPNzY3/3/lORWDtgTc1AWujoAb2M6F4E8dJnZaBmQ+8CiTsruaELkleYIL07O4R6jDPsgGtDO0GsuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lc3vU9eN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KgbNRhTE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lc3vU9eN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KgbNRhTE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790119131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RbHm+Qxov4Y7EXI0fgMZE7QQEAMLP3jAVpZvcjFSHGM=;
	b=Lc3vU9eNdAjQHZ/V6VRgotqiNdk3fJ9aQuu1eA9Ohw/wFIxWxk7y6Ys142rccNA6Mxe3Xs
	JRBzwFR8RcQJZ4z53c8CVrrACribG9Tx5etyaiXsT84kp+ZOnMF8VDIAF0VovLYObv0Elj
	DTw7+39tBwrXEELXm5rW4jq4s5RNBgY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-iKhrLcCCPnKkwDiUtJ3p5w-1; Tue, 22 Sep 2026 19:18:50 -0400
X-MC-Unique: iKhrLcCCPnKkwDiUtJ3p5w-1
X-Mimecast-MFC-AGG-ID: iKhrLcCCPnKkwDiUtJ3p5w_1790119130
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-934963b2bc0so85923385a.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 16:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790119130; x=1790723930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RbHm+Qxov4Y7EXI0fgMZE7QQEAMLP3jAVpZvcjFSHGM=;
        b=KgbNRhTE9/jE/q0HVHQ2FWrlQNdCkUa0RTpJJw3kZ+yszAdDA48z8B3AbCBxeTl9jk
         RVRfxQi1pfzl3b4oXp4fStAvKyUACTCMK1eMi/U15lJbNtvgn/+5XoCjjcGwWHGkKvgi
         O8IkW7/+NW6cACVnlTx+hVasZ8edzUxYJ3T4MBt5as8gNRrgx5dDdOjGiQt8oUzpg+E0
         Ur4qcqshxSCeIuuKOhf1TIPOMMRgLHIN36tzWmLjm/oJPSlnUuRLYAsCTio6OYzsYEsC
         2cfRbu49HAAhMkXNhxqpUl3VrvChaKPUQEjFsC56fkaykP6JRFWlwDDBdcly/FzZ1U4A
         xRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790119130; x=1790723930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RbHm+Qxov4Y7EXI0fgMZE7QQEAMLP3jAVpZvcjFSHGM=;
        b=Y1IQWympYS/n2dfqdSsL3EAoRKvC/TyJrXKm/SkUUOxnnpQIPg6az+VJ0Rr+4cygp6
         TjywerZuvUJxez4VLr/nkd5OSixs/gDGmI4gTGzlRvmhq7P+8p1si4BC3X467qCCs2mp
         UHZsEU5QaOeU4UA3lzjNKXWa1CEIhWsIvyPtJQVUGFVTz0ES9arnjjwG5K58Y3vmcbId
         dbyrFlGjYYE30xdQ3nc1B391aTJ5VWAUFFN2gqLmXjC9vkELgb54EkABdFb8KdRqBDtn
         BjslpC5BuTlJYe17LZXVALzmPaejSJs4AOGvaVRIjReKbw+ue6uQftA7gdOYt/mLPXJv
         ncWg==
X-Gm-Message-State: AFuF++nv6N8gcin8dTjtVVCi1uW1q7+i9kkvgzcJ8G7O+L5o5EuUAgHz
	kWPtn6NIofN44G1JXcxKy9sIY/tXDWdmE3AQDHEJWWihNYYM7yBxLcoaxcF4MT25sgnuz77MWvT
	9QiVlcq6pM/nBVNBFm8ppmlxlrZiafk6Bq9MSKTBN7zTG6t8GrfoQKzs2MBhx7Iqukhn6TX0O+Y
	Ohy3LU87XBnZuoE/SFccFDn51paH2NKJcG5IVsyfc54koSn6M=
X-Gm-Gg: AYBFou0tKutPN6fGsU2tZU2W2XBEsayEolSUgUvh0gQrf42qV1pBs868LE6QABzQnks
	kDnnFpu92fHAF2i/v/ljn1EcuW6958ifVHgrMimw2A4JiL7sORhIeCRXbrw/nnCrVF47B5DXX9c
	7YHs6ABDjs4x2dpZdsHjh6e5vn8ttcc2rV7gO+pxWbsW/b95eJW0cIw+N0PXx1nbNKccoJ73ZY9
	mROzQSldF1Y+GjHGFE7haZ2Y1YVossuvwDeYmMxGkQxA07D9GAV1IqvP1Nz1J0nkPuXYKyQf/Tk
	qUgL9XaaU6xxeZOstkIB8Ax9BcHci0ZmUk6c4czX1S8FYFjALRD65RrPv0MA2Xgv23n1NqHYtWI
	paT6y160y9lP6SXSHhb9bRAEdfRs4kxMAgGJnSA==
X-Received: by 2002:a05:620a:3912:b0:939:2d94:667c with SMTP id af79cd13be357-93c250a3b38mr160449085a.21.1790119129686;
        Tue, 22 Sep 2026 16:18:49 -0700 (PDT)
X-Received: by 2002:a05:620a:3912:b0:939:2d94:667c with SMTP id af79cd13be357-93c250a3b38mr160443885a.21.1790119129123;
        Tue, 22 Sep 2026 16:18:49 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248b84fasm91912285a.40.2026.09.22.16.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:18:47 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH 0/2] xfs: share rmap & refcount btree ops
Date: Tue, 22 Sep 2026 18:17:07 -0500
Message-ID: <20260922231845.3266784-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch should be what I sent before, just combinediff'd.

The second patch does the same for the refcount btrees as suggested.

I didn't keep prior RVBs since it's not the same patch any more...

This elimiates almost 250 LOC.

