Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF088828
	for <linux-xfs@vger.kernel.org>; Sat, 12 Apr 2025 06:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744439487; cv=none; b=iS93MAi1SWIPzgrElFU1OAIZLYIpxNCVaOK/2QuEB4veXDq7XZJeUzYBf0N9Lah0dXGFodKCd3RqL0MBSWzDyvqCUHehIZuLgG9hdq+74n3RlpGmjlP867kbqT3ww6Qji0gyhynfZVynDuCMV9b7Hn9qLEhgAoR8qoS7QvpTn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744439487; c=relaxed/simple;
	bh=cWbyxzYaQ8PQvTy8fzH4oopioQzE6j/SkLKkpleZ7v8=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=GBIO+CYkXT60A4fpKl5a+kEm0ArO8MJVD2ecoI8Q/ci5sBBIRmOVHnk0PXcsFYGN85ADozGlu9Qov+/zbcYT9WWzKbDxQ1fSU8tfdf91i2oOb5eAv5BGTno/KZwgqpui1b6Hrt5S0ima4YaK2ovcSn7WPY7yviRm55vu/pWA16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPTflgZq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPTflgZq"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22928d629faso28283825ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 23:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744439486; x=1745044286; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r9tu0iAn5P4lQWuPqv/93PAcgy4Sg/n+WRSJjXauFSw=;
        b=DPTflgZqJ6zoevDNIU6kkWQm6tgixloZc465ZMQVO45wM+OWi4pnHUnCTDq2JiPSqs
         E3ew32LNxPL51+ux+3sdXfFq1yUwJ9x0lM9HzSBWszj/6CzB6w5Eq9s6FBScD4Tcr6pn
         jY26v+65kr/7gTxq9AifdXb1wRC1JTrMBYFVjqZemat6KbJySZzbWy7tW3fX7UfxlwrC
         9PaADEynx0iS5goHTuiGAadSrD3nQq5E5pwfK2QTpqk7vr2gWVMEV38PzO/Ol/ijsW2x
         kHY3DpDz11am3cGjIgxQztPL2vWcSdrRkY9HVsE7XoqRJHQrFGk9exyh6qu7g7p93z4x
         HjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744439486; x=1745044286;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9tu0iAn5P4lQWuPqv/93PAcgy4Sg/n+WRSJjXauFSw=;
        b=K/A3cDOcu+Z83nVqeJ2ocUQd8Vd3C6ouS4KtJ3pCrsoR60ASrjC8dRgUJjg05cfKee
         Ik5Fb+55oOzry0gjYwAaf8OrJM8zShwqHdDrepqxd4er7jnxdDuWvzCBB7vVgUFK5ytW
         5C+YpPi0Uo+kI4ZKbYfM8cbWZ5GOEbG6AVPxKHyFAL3w7OVXVuQDMfrEz5cqxh8qqFK9
         fGLwXw0COINl85EHAM19ksJLm29H5oMBGsMMEepLxL+laUvl4dGyiiPtfgTmr/n5uLg/
         mcyEcgIP1I3wwilOLzJktl40LtlusI1fnbJDCx4zZctkA8kObg85JT27qx7pRVvZr2IU
         Mkvw==
X-Gm-Message-State: AOJu0Yx8RQ7PTtnTYuOkpNHEQUc4qjqcmtp3yKLBG/54275YFaa7uigH
	v6JOyNiRs0EPlTIVs2EFYSBhOkYTo61CAIXQMjVT7geYUlH2CEJg
X-Gm-Gg: ASbGncujVFIhCe5/z+IOJfM1zJ4Uoug1F2YH8ayR6Nh8oozgyBpYSYtppODAmM+o7ZP
	HnWkcd78mYjRcq+ouzBVdsjcsmPUdaRzzj83LYoyfCxy/0f2oIwEeqGZn0qcEeJ/tf9OpVesSp5
	xikw094lt8w70m6CUf4pvX9d18sP/uUwRtKmceDygAnag0BBfTcbXbET/13ZyNsf9NSPaaM7Qah
	+zFYmSVjR5m6RPfvnMN69RLWGD2T/hlfp8W8n3OdI6LkbfJaS5XMvu3DFKDsSkyweVL+ktPc378
	iqy1blgzmx1PN2Hdyb6f4V/0fke+saggq4qhYpBlzT2v
X-Google-Smtp-Source: AGHT+IGP9FBvxOYi79mbYsCgvfhzMLSoR2OsDfnP8ENmdgMz6zpMSyo9wMHCGXC5RyIP1SLdCwgwuw==
X-Received: by 2002:a17:902:f685:b0:224:26f2:97d7 with SMTP id d9443c01a7336-22bea4936bemr58294795ad.8.1744439485574;
        Fri, 11 Apr 2025 23:31:25 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b628edsm61236205ad.10.2025.04.11.23.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 23:31:24 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH] man: fix missing cachestat manpage
In-Reply-To: <87o6x129bj.fsf@gmail.com>
Date: Sat, 12 Apr 2025 12:00:24 +0530
Message-ID: <87mscl28ov.fsf@gmail.com>
References: <20250409160059.GA6283@frogsfrogsfrogs> <87o6x129bj.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> "Darrick J. Wong" <djwong@kernel.org> writes:
>
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Fix missing cachestat documentation so that xfs/514 doesn't fail.
>>
>
> Thanks for the fixing this. I didn't notice xfs/514 tests undocumented
> xfs_db commands. 

For xfs_io, xfs/293 tests for undocumented commands.

-ritesh
