Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886BCD29B
	for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713685797; cv=none; b=TGqy0q99hfKDg2t3UjANfHP8FsuVkhFQl2ZYPJL3lrzdqGaaJ8ReICdZwQdNiqqYr9vIJCIsX8+PuAxo0HiQdPfuB8yRYG8EW+ylHqpsPEDAEtxuq13MCfddeIJSCZQ5Z0SE7KsBvDnqRT69XQHZ12/m/nORWV4JKrZcZCOkuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713685797; c=relaxed/simple;
	bh=3GQVNMqxP/s02oDlHle2FhFdWAweY0epPbSKo2Lav8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iv3lKmnJD3m3c2Ln+5LXPRpEsb1cGckbSW3kwD9xOZq7V70jBcozqbxKMzx0jG1lLB6Fo9xdINnP981e3yE+95r2+wTEdwxQ1Q15dDlK40kCdelxZjZogC2/Zag1xwL0kI3ArF85ShcCxqkqhYsj7u+I2J7tv7JZmjl0M6vp4/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NgtrO1L1; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgtrO1L1"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6eb96620559so2248788a34.1
        for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 00:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713685794; x=1714290594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mh0+fNyPZf00oIR0FOIUU7+WxSVE92FfGyoGthkKOUo=;
        b=NgtrO1L1SboCx96HsdVhqRwNIDwkpZ22HPkHJ8iZ6IYVljNuCXp2NdNQZFswk5jln/
         wWSvrWPQTQWyq3Smsdg0ctG2mkws2vUmfTvP4AGDuWV3FkNxy3XIXPlQpZ5pcPhZv04O
         VPM9BefsTc0bnn+wGr6R88diV+gH0c+orAJoKMX4L0PXDYy6Y+lSW5+YKEm8/0rAo5cp
         cAxOdbDfmVjLKeJqXDQslkXOqnfXLqh9Oj+uaW196ZXm/endKqlotJhyxf8kqlpc+gWX
         juiu+pJ5///TS9zPUFvRcDz1At7MOo9lZPdmgjdGHklwTct0xahuvt9C9sSKzTtFXg9h
         8NiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713685794; x=1714290594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mh0+fNyPZf00oIR0FOIUU7+WxSVE92FfGyoGthkKOUo=;
        b=SjqbEHhsp8ZoEo50kF+Vkl6MnKjaTae+4GIFv0HTcZAIVjy0ixt2S3sbwHeTZLKTBO
         y2dC3ppaNGx7T7sKSxokItTekydTL2wf6GeahpZru+dPQXGFNbZM1mdOBd1rcdf0JNCm
         nLAVWxu33WedJQEPinYv1SPkZsK4MWlF0/c25aF7ZDrpJGd+drsZBjxouFbFJkavzn7y
         cLuJMqTtMUDUqPxEUqWOQb+WlN53j99MX0lIextpxMTxilvPxdbcLTOLuokvZviS+6tu
         Zx5ujvtnIKuVhX7/Ah7lqboQPWJM9hACEqah1xuL0FFsxiF6+v5n757xSxlTyHQz8mCu
         ClcQ==
X-Gm-Message-State: AOJu0YwpJn4ENIpDJKDsJcJJ0woFvvQWv5d2GnsXnIEZXmSAlHnDuMnw
	P8CtxONv7SLN9wkPZdWDtXRzkvUMve0HWqnzZUKvJOCwmZayqttxblU/Wg==
X-Google-Smtp-Source: AGHT+IHyvZ189UENlBsRhF6Ya+KIX5C5qQaEm7oPF31+6hBv2R2h4GeIx3Xg7PtJWiWnaGeYYO7Cbg==
X-Received: by 2002:a05:6359:5088:b0:186:1152:d741 with SMTP id on8-20020a056359508800b001861152d741mr8294135rwb.6.1713685794410;
        Sun, 21 Apr 2024 00:49:54 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.85.139])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902820200b001e042dc5202sm5944695pln.80.2024.04.21.00.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 00:49:53 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH 0/1] xfs: soft lockups for unmapping large no. of extents
Date: Sun, 21 Apr 2024 13:19:43 +0530
Message-ID: <cover.1713674898.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

In one of the testcases, parallel async dio writes to a file generates
large no. of extents (upto 2M or more), and then this file is cleaned up for
running other I/O tests. In the process of deleting this file, soft lockup
messages are observed. We believe this is happening due to kernel being busy
in unmapping/freeing those extents as part of the transaction processing.

This is similar observation with the same call stack which was also reported
here [1]. I also tried the qemu-img bench testcase shared in [1], and I was
able to reproduce the soft lockup with that on Power.

So as I understood from that discussion [1], that kernel is moving towards a new
preemption model, but IIUC, it is still an ongoing work.
Also IMHO, there are stable kernels which we still do support and such a fix
might still be necessary for them.

[1]: https://lore.kernel.org/all/20240110071347.3711925-1-wenjian1@xiaomi.com/


Ritesh Harjani (IBM) (1):
  xfs: Add cond_resched to xfs_defer_finish_noroll

 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

--
2.44.0

