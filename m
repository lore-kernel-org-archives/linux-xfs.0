Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496073;
	b=PSaHs/MnWy5WeVm/G4QqEB+RUK7j+0y+L52nMb9iMlR+FrwlscSyxp+haH7HF2Eaajhu
	 reQJqdonUbL5HBHSEAqe5m068/fi6+jFl0dhr1+0hLGfbhG2paoADYsoHVrv5eErNVd21
	 7mseL1I11qY9IR8oaLUmujDjOUYCBl5h3BwPhVj/Oy6djn5VECF95p1Jpp3n9AXPh+T7o
	 RW9oSyHd9m2apN6etpFzmUQskl+McKGMSJQ4ZPc97xnxxouRxHQHycgiW7cZ9qKg6+CXJ
	 r4DJSmD1gdM+LssIru54Li0sxZmbPBfhN3JXMLC24p8gaqh/JOyQfuBpXRZP6Xwo+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0swBWFYpLWCv2uk3fIn9LxiScTlQdREOnp7Y0vqdXqw=;
	b=WV0F5YdF3jN84npENWwVlr7gmivPXEu4xhO1KfsaUx3eMg3RcperZKYpa/MdTiZF98Aq
	 +HTfpwkzozeSQQNY1Pu21uNT9lnCPzRf51ASkN/rIqdYQIVB5TaJNbgUgDb5aZzcMw7sR
	 I1PfPsmiRoRE44W4NIhqekHjd/GmKsxVxCncVz8K7HmCxlkX+UXfPbCU+avQdPPwBP7lz
	 fZOLv8geEMM8TCu0j2pZoIrV0JD8Rnue+zaIGtBgNimIpcMMSHIcU5gcntxJ7AWfKLKqp
	 cmKWnLD0Sty0h2UrWOu646BczUSsMdKCgwhKqCTOXofdP5Qw85LisdUvZ0yTU7ok50g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=TOcm2Ed1;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB609606A323
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 15:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB609606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=TOcm2Ed1
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-53669f7b518so44047371cf.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 07:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794496072; x=1795100872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0swBWFYpLWCv2uk3fIn9LxiScTlQdREOnp7Y0vqdXqw=;
        b=TOcm2Ed1M3LHQEU0niXvBE4+c3wTGmU7AdtpGS9H7bFvh6gX69rn3aXTdoHmGzgbUQ
         PyiPs9IoUUiEz0lzSBlRajf3Pgrancg7K7nQQBL1iX1iBguiXwUpxEtH0vGtIBZUR8KS
         SCK0yGKpHtvC4efFykqqHlTAiqZZUbc+j4PZ6roA11BSq363ZsVbhRCKZvN+RShcoT9A
         JnQqR8vlGhV0yBhdVEHmOKGVdM9xmxOBLvmRQIFm5HtFHDRT5/s8T9bI/iI5ZZulrAAg
         cnATcz9J8VQZJFVUhiEqXoy/Hd1Gldp83I+Na4H0lbIHMjTvu0nbcTqsPm0G34SYeLXX
         ei1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794496072; x=1795100872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0swBWFYpLWCv2uk3fIn9LxiScTlQdREOnp7Y0vqdXqw=;
        b=AZQy4RKK9wEK4t8QzM4d+6+2ueBSFsVsNIkAPSdI17z7va7jmwmL3FOuWZSHLznwlD
         1XWpgQGCxDcIoM26+R9bZHWuQeYMn1+dwWzHl68fsy1JPGM0oCNvXT7vHjinJsCehOvp
         TIdRnr4m8p+Cso/CvSCsRwVVsoz4n9ptW3oQiBT678rwqT+I8e5cSIxnSNJu5IGOHwzC
         xJBLqrb4yIUR6WE3P0k0dWkTAfSn6576rBDfpYYBGIsRxPV/KFvgMefYL5Neb+iMjBu9
         Ex60CtL1/UggOAwsHBOSAqZLhX0SRMS6rc5I++ixMDLw56RCROh/OE0kCWVDC6uFauA2
         KMVg==
X-Forwarded-Encrypted: i=1; AL+hErEdMKFrJyqyXnlMPwdRQPIczZ0slvcO3P2Pf4CPoY43vmJ0enF5lFa/LHNMgwnHwtqhFzaMebnWx90=@vger.kernel.org
X-Gm-Message-State: APuU4Z/r5SNKEH9SXjzR+JKJagy7q506H2LNXv56B3vfhqi0NSRr8y82
	REggQBQ60RvZshp+zM648kAAfVhv6QJgRe8Q8rgfVGCUP8N9y7D0XkiYHypY9u2qHw==
X-Gm-Gg: AYBFou26YhxqqUtWfSNVuV+jOXVRvAalqp474xVnE9eCKFGz+3xQSXrINeJnJybdfER
	fkO6fNboIWcPz2bcI0bwpPvrfFoYbyYuxx4Dtz8nw7TFxjqL1fWFIkj4xSmlp4RQNhcY8Nw8rm3
	PhDQUfVZZ3Puzb4STVC3zsl3X1EBPttpqwfCyti/uXgdqSXKNE6wlZAcImnv/4NWqebKvn9QVKa
	My+ZLhIjjMB3JExVPSR9H8XLsFAmgWVWVUrrCTRJELy77hbhIin2xGViiVsp5WHD+EupDzQ2gSv
	nT0Qwkg7Dyh+1idvehaOE8RnGsCnfJXe8WpYJwYSCA6uRGsflF6+F9MnLx32x/k2/GZ7HlP2r+5
	oAhSu8BLp8+Zsti7E85pvgaBRrqedm+h59GNZtVTQ6rI//25byiEqT2d6XXaIzUmX8CCsvPBcFi
	qEhv0mH4UvCUJcHeCWG3vVIUe5td6sn4NyNSs3jWDSGYgGXuMW6Xv1BtbXObxr1e9oX1hM32lHl
	ImsTij48/rW46S1d52MBZRfqcXJa1yTJ/XBMQ5PG9KHfuLfF901lqVkv1Ps3Vy6O4MSfW5GNqwm
	LknxCiYP6zvMqCvuhUJpkqF/0TdF8lF99nhUzeC4zv323LAtJLoe7DIBT10GZICgrHxIst8g
X-Received: by 2002:ac8:5a05:0:b0:535:6cc1:5890 with SMTP id d75a77b69052e-556c119bff4mr98545471cf.51.1794496071835;
        Thu, 12 Nov 2026 07:07:51 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550c40ffecsm75896761cf.29.2026.11.12.07.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:07:51 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix f_bfree underflow in statfs()
Date: Thu, 12 Nov 2026 10:07:43 -0500
Message-ID: <20261112150743.241738-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112134434.GA23459@lst.de>
References: <20261112134434.GA23459@lst.de>
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

On Thu, Nov 12, 2026 at 02:44:34PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 12, 2026 at 05:20:18AM -0500, Hengyu Liang wrote:
> > The issue can be reproduced on a new 2 GiB filesystem mounted on /mnt:
> > 
> >     for i in $(seq 3000); do head -c 65536 /dev/zero > /mnt/s$i; done
> >     dd if=/dev/zero of=/mnt/big bs=1M
> >     xfs_io -x -c 'resblks 100000000' /mnt
> >     for i in $(seq 1 2 3000); do rm /mnt/s$i; done
> >     sync
> >     df -h /mnt
> 
> Can you add this to xfstests?

Sure, I will send a test case to fstests.

Thanks!
