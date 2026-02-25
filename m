Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572FD2D46A1
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 05:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771997072; cv=none; b=VPb2O+Gi41m+2zvJ9UAbiqL7GdoJRqlQOYw+OLwM/O/4L0q3pJm0FLDwKymipDWNpsA4ujrFmJVj197Va3dC07BAYC5GUZsPVraiQHD3aW39BQQ2NRxCStUE3NruOGMi1APks5y2v43fgsT/49qHmLpRSwtykIH8+wb91x5jaHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771997072; c=relaxed/simple;
	bh=l34tSCvGC42EyUSp8qcSQNBClPGGwkcKluKp4Zjzov4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=JHZKTo1MVOwK4S0sC/EJ1/PB0RU78Mxm2q0bwjMBokQcbQx3pwRlnVCU/3WE/U7PCiOSX29YvmVmqiDbTR8k9T5kXxuiOFJ8YaUmNckvDzuyc6wJCelXKDJB6iebGPmXkGCrKyr7XNaJt2fLUYIBLB9ozhYUw2/CfarAmT8WFQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lB5WZ8vt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lB5WZ8vt"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso29090215ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 21:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771997071; x=1772601871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RP5pxbrjsJQ0eXWB7/Uudx6F0MefVV0OrNtMgZFRCjM=;
        b=lB5WZ8vtgl/Oz7tBYN659+S7GaeD+TjYG6QTTg6W2s/Cra3p48l2na7eKm67Dppsf6
         2B284vpumc4U7PgP8o8rFY3Xeg7bu0IY2Tkpxl46ck+a+6XJUNhcu3wsxurgd7ExZjs8
         oJBZGf1SNWPrLK5Wm6j2/2ER4eFMyc5a5T4d2euhib1VpD6DcXMgvQCh9/493pwXXHb1
         2hUtw8W8SMVoJRHS4r2u9YdgT75D/Kb2cN6WocYa4h+FCB0wH3MnuXREAzSeprM7lBXn
         G5axBoIUwTl5myp0Chb8a3TbnWKhj32TC786sCZXg/b5K8KjNdi5vxjOgc69H6gNdE06
         ZidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771997071; x=1772601871;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RP5pxbrjsJQ0eXWB7/Uudx6F0MefVV0OrNtMgZFRCjM=;
        b=VaniZ2GFMXDqPT5lSW6VNVcCA8B0ZDMEwhUZlxiNNotBvYcukRN4vG2uWboE9R/EE1
         KzIt0mdmb8ympSoEqla/AmRoXzG8nVV5303CqCVcqWKB2oJ4Zhp+TQIEHTz1H++3FA1a
         UwQHogd3jyfCnsxe1sCbunGnsOEnLAQ7bZLOilqRM8EIkKNjX+lPZ1zkp1TuMvPGG9Up
         NNX1O27+LGsEJAXip20k+mJ5um6LSZib2tuHFxFBjiJc1P3Oilnr2NlS5YeanYkt6RHf
         Re7wPaCtw2oLiQv7Q/JJfXKZ0eUx+Xc7cgX641WYkX5cOv0/sLmr098wIT4eub1jYlD2
         R0rg==
X-Forwarded-Encrypted: i=1; AJvYcCWJl9w5umNfwUd+uh/5iHUIlJsLBE8z0TqV/SAPPytj282SCjRlDzn9jrJk27BnXDHHu7Q0C+ycYlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY3dYlC9v+J190/GWfvppt7LbKzptmkYU9zwgcWRC4v0uk71kk
	nNoJmZsqRgbKjcHQYWhZhpUMbS6u2pZUJttUqWZUBLhQLRrTsk5sQiGJ
X-Gm-Gg: ATEYQzxfp8nnWij+0ZNVBND4Kq2UMrnQoT634VEQoONGIvq3WjVTPir75DzoKkKOpAv
	lVXvtbY/fIue+KkSVwKHYNwQ6kDg32ZErPzEyW+mfEFpI6rSuEbPeoEQ38brwahuQFDcgKxUtFX
	OYG+94i5YBTQgZUz6Ta+cVctD9P3MF43rprRT+yZtAb952E8xmK2DEPQ8EU1FDRLOQfd4SWghVH
	VBbwIVbodmuCE3eHOy/gc7MJEwu/tiCJmHZ3CFYXHr0h6hIsORlKlmH8sdwZIZsWTj2XxP7gCdg
	SZlapa30kaU/Z97GaY3XjHI2AoCRoBTGULRwdxOlcwxUbJoaJx4bVV1GNrYHozuwnhqy5jqblzE
	A8Lszvoe4HoXQWsPy54u4upbwF2ZVBj58rCY+yXpWvKEO9oMBTjSSBZ17FhV2FG6l5WMvQTjtgl
	PiMsdvqv2ajCQKuZgc60iERR+kCYqXcZIM6jB6Z6G6WexlRwFwazc0C0GgmAS0LQgMkhpJ74mKv
	ow=
X-Received: by 2002:a17:903:1105:b0:29e:bf76:2d91 with SMTP id d9443c01a7336-2ad74539cf8mr136106825ad.42.1771997070718;
        Tue, 24 Feb 2026 21:24:30 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74f5dae6sm130398475ad.21.2026.02.24.21.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 21:24:30 -0800 (PST)
Message-ID: <b424960f4f5c91e1a7d5aa7f3b89569789bfa7b4.camel@gmail.com>
Subject: Re: [PATCH v1 3/7] xfs: Add realtime group grow tests
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, david@fromorbit.com,
 zlang@kernel.org,  linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com,  ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Wed, 25 Feb 2026 10:54:25 +0530
In-Reply-To: <aZawVm-cjoyM7ErV@infradead.org>
References: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
	 <f1230eca56f32e26b954be6684d1582dacf2aef6.1771425357.git.nirjhar.roy.lists@gmail.com>
	 <aZawVm-cjoyM7ErV@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2026-02-18 at 22:40 -0800, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 06:10:51AM +0000, Nirjhar Roy (IBM) wrote:
> > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > 
> > Add unit tests to validate growth of realtime groups. This includes
> > last rtgroup's partial growth case as well complete rtgroup addition.
> 
> Please tests these also with zoned rt devices.  They are a bit special
> in that you can only grow (and in the future shrink) entire RTGs, and
> don't have the bitmap/summary.  For some cases that might mean just
> not running them (if they grow inside a RTG), and for others they might
> need very minor tweaks.

Sure. I will update these tests once I am able to make the shrink work with the zoned devices. Thank
you for pointing this out. 
--NR
> 

