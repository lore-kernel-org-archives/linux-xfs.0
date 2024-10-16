Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6648418C33F;
	Wed, 16 Oct 2024 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729076985; cv=none; b=UBTtfT9cT52uzCB+LWz/Sn+1KAyIBOm2OINrWm0P29IoZHZPHB8BuYwIYTE5LmZU9R4iWP2dZvD3/cCNfv9r4joPTZEnZ2TKRTmRzRJVRrSPDXoM9xhHB0VA9sDXNAMkBCp7m6IxnAsRuGMlRqiqq9eINxCw3ypZc62iNgMSt/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729076985; c=relaxed/simple;
	bh=SLcPoBGdRC9UOLWq3AO2q4XKPPr0ypIEKylqHD0nJc4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=b9/Zcy6NP1u/RpGD3Jt8Y1bTouc85ilzKZeY8DaN4PxGt6yMN4z+jhVkxU7yqmgRnMtCajhDxF4vSYlGTSnrHzI1DM9XRbaOi8qPNdrPx9tD/b3gusNcj/zOHtwUw74ydrLQPqa88PdiCZL/eGa4K6jzGyXiIj3V+sU4lyBU0VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hSklbpKG; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hSklbpKG"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e13375d3so5387939e87.3;
        Wed, 16 Oct 2024 04:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729076981; x=1729681781; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JmxNFT1MumQs5zr5JY45ZMTsB54enVuUrCy+urpfilo=;
        b=hSklbpKGUFp6jEI6S4FM5AqmQbKVrhPZtw6QS9I/eMRkcOfa+fcAvn72sqDNp9nGTs
         0/+c4Uqd/LrG8rZiiipnmv7jCVWL9DPeLHvH0/F7bz8UKtDKAAz9SjsofXBm5BoP2C+h
         LfFwZS+WjZe1nvpQsx9Yg2nqxDfsQcgBNYzyH9wnOMyhsuQwuWUAcvHpU23jjeqrv/Kt
         sBNGrsLBoXCQWCpjRnqxJuR7CKy3dw7sdSRnlALmI5mYMsN4yG+raWUfkjIISGm8Fcyt
         lw/Gbq7Z0bJlM4qxbfR3ch/w7epdYm1QpECfUFhDubf4cKfVM7CuvufY+9AWl2bIYZwo
         zBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729076981; x=1729681781;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JmxNFT1MumQs5zr5JY45ZMTsB54enVuUrCy+urpfilo=;
        b=NorvMaBoorZtH9TyWRg2AajuRIkPHsweoDQuVqVVW3HfM0ZRIFru7rLwGq4Y8rtfho
         eXC71/R/cyxQ25AJ/W+lJnIlG/cKZlYXc4+kHhHuDRlVgmY7Ye8lj2IfAzIGV77U80HH
         uVvlyOOwP+45CkINKDCK4KTraua5VXWDb+3uDH/Jx/bR0y63kzleA/c0518XSK+1LwzU
         DAkEeeiSfECkHCxOdpkbvr3AFPBQKy1+3wQPuX9VFJOA1CkOK1DSufUkGcMt54GPS86Z
         ckyS8bVEUo4JZAZgLqy6Fv50ANndel4jh+rBEUi66qg04CcFtqkTTYwyskNarwfx+ZHg
         KZCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkFoBEWgdp321oJtlkvXAVyZZGr+ZP1BPXztb8fbdkFNuEJ1NWUyyHj0gRl4LrlbMmy62d0hTo/nQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa2i11W698vfReH4OO4x2t72bnjL/B26CpZZ6tUQpnULPkmE6o
	AfoyJKnCTSLFZvGvPE0ttYaOlJcWtpE9eaVzK8q3/LFiNX/kB9nEG05v1w34CcwPyLxkvkawIrP
	CMo71uY7BIlpxGZhhGYh/iIbkSqJKn3E=
X-Google-Smtp-Source: AGHT+IHf+WOTS37RhxhEr/sgmuPjCld0APshHwWOoYDfE6FJO7cym/sNDlTzDn2/vPTzQj1X5QbM5iP5skJIoS/uP90=
X-Received: by 2002:a05:6512:3b26:b0:53a:423:6eac with SMTP id
 2adb3069b0e04-53a04237046mr2023256e87.0.1729076981238; Wed, 16 Oct 2024
 04:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiongwei Song <sxwbruce@gmail.com>
Date: Wed, 16 Oct 2024 19:09:29 +0800
Message-ID: <CALy5rjUMnocsh80gPB+4UgaFS-Gsz5KAFnAN8Nj7m_oyohFfvg@mail.gmail.com>
Subject: XFS performance degradation during running cp command with big test file
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Experts,

We are facing a performance degradation on the XFS partition. We
was trying to copy a big file(200GB ~ 250GB) from a path to /dev/null,
when performing cp command to 60s ~ 90s, the reading speed was
suddenly down. At the beginning, the reading speed was around
1080MB/s, 60s later the speed was down to around 350MB/s. This
problem  is only found with XFS + Thick LUN.

The test environment:
Storage Model: Dell unity XT 380 Think/Thin LUN
Linux Version: 4.12.14

The steps to run test:
1) Create a xfs partition with following commands
   parted -a opt /dev/sdb mklabel gpt mkpart sdb xfs 0% 100%
   mkfs.xfs /dev/sdbx
   mount /dev/sdbx /xfs
2) Create a ~200GB file named fileA in the partition.
3) Run cp command to copy the file created in step 2. Meanwhile,
   run iostat vmstat and blktrace to capture logs.
   cp /xfs/fileA /dev/null

To narrow down this issue, we also did some experiments
below to compare:
1) Run the test with dd command with XFS + Thick LUN
   dd if=/xfs/fileA of=/dev/null bs=32k status=progress
   Result: also meet performance degradation
   Speed: around 650MB/S
   Speed has changed to around 350MB/S since the 60s ~ 90s of cp run.

2) Run the test with dd command with raw device with XFS + Thick LUN
   dd if=/dev/sdbx of=/dev/null bs=32k status=progress
   Results: No performance degradation
   Speed: around 520MB/s

3) Run run test with ext4 + Think LUN
   cp /xfs/fileA /dev/null
   Results: No performance degradation
   Speed: around 1080MB/s

4) Run the test with cp with XFS + Thin LUN
   cp /xfs/fileA /dev/null
   Result: No performance degradation
   Speed: around 500MB/s

5) Run the test with dd with XFS + Thin LUN
   dd if=/xfs/fileA of=/dev/null bs=32k status=progress
   Result: No performance degradation
   Speed: around 500MB/s

It seems the issue only can be triggered with XFS + Thick LUN,
no matter dd or cp to read the test file. We would like to learn
if there is something special with XFS in this test situation?
Is it known?

Do you have any thoughts or suggestions? Also, do you need vmstat
or iostat logs or blktrace or any other logs to address this issue?

Thank you in advance.

Regards,
Bruce
