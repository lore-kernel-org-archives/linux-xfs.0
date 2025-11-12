Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4582E62D1
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 21:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984622; cv=none; b=sj8mkp7dPzztUNni1XKZ6wEWk144pX8pEhZ/qJZxzmExLCldm7JhKNELKYQ9Obd8Zk0bEDKmO8lNoI0Zu9NY6L+r1k+wcJPgRrIQRIDDSCr+65EMEpk7tAML8I9LkdJu0+zuVnWFslsoQGY8ACyRDNxXP/1c77BHG9nMLBiaFWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984622; c=relaxed/simple;
	bh=0OTFUF8dKlxaDdn36rkr2KB5xF/wOSqhfWxtBGzWaxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7CTnlVcl6n19Dew4R8UD3ekBrikpldhUC7ii7QHfUWLLbLvSCScnKre8XbPuUg+Nr4RpJV4jeqJjdRRsRywT0VAlWkbzaYcY9sXmEijxxmfEtx3sgN0BH1JGUyF8Caw2Uf+kSBHSUcqx6yVCL3iO4eA/ga//6BIP85MV+IUOP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YTZQqEPi; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YTZQqEPi"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bb7799edea8so94743a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 13:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762984620; x=1763589420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtzYm6CaQwwng4XDexAXOIVM2T8jYsSpOQI11uV7cIk=;
        b=YTZQqEPiaS/si8bOxnMCFdjnMaTXToGa+627P0ihXde9THCYTRabrnR046dIV/9vpK
         /xGW+/fpk3Ayxcxslmwu8IskYnDVZNHuoz9XgU1oKhwcgEecoUEg0CDvUWsiwQ9QhrD6
         qLzuJ3lhLMCeBg24li73qvZf9qJVTZEH6YQ5QfO7ag9GmeW0S553HICngVx2EtmTy1Zd
         W1TXGld4qghxcGaaLTfm/yqBFdwe9/CMI34rzzA0dL6ygouoq7/eAotojbh3vs493UHc
         P/Yptk1U+JYikQORa3NX0S9xOGe2j4bmELyr8Eqj4URJvRyHBtGASEtlIQxNcDPAl4zc
         Shgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762984620; x=1763589420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtzYm6CaQwwng4XDexAXOIVM2T8jYsSpOQI11uV7cIk=;
        b=dvJdU9ycbYZIeVbqMO8kJAiMbpwjA8lFeCN65FkUZz2BFuD3rN++zgVJ9YVhdJhctv
         JJqV5/ep5XPzNW/0LRTb43o1yGr2ka39z48B4RmgCMDNiDpiqmHsaHmnKTZBOc/nAbSB
         fcUf8opptrr0i5nO3r7tIiOUyV7ZICph6oPF/qnGMOJ1JbOocBAP4tsvgYQBNgfTWgUp
         9BHvQf6slxJG9PDye6zUUvw9ZZPULrRMBUaf3uNxijsVuaKihi+WVlMLIGwf3vbnicVE
         dBOWw1F6/SAIA6i+3knxDO9kwxeTgVUdSe94mGuPlnor22T8nWoZPXgI56oq+Hsb09H9
         UjWg==
X-Forwarded-Encrypted: i=1; AJvYcCUPc9ifSMtqAYlZLGshAOWnSlc8H7ZGgEQj2Rzdu+6msiotQHsDsyzGbq9p1Hgbkxry/DKrNwB0Fxk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3kScqF2kKAIeFQSSd2zK9p5rorCLwZg6jntSBUbqlRBSmgCuR
	DH00QfwVIWm0chbxqk6n0FyJyA240quV0IZiQRVmjWSSdQca5TM+W6G4gGlmS+x9Z4o=
X-Gm-Gg: ASbGncuYu/xK8GFXij66Hx0G9B1cxjMXErJiFNxqViqAOQxq6HIbDUfFCvnPv6jzl2/
	7WUStgW5kjQZOelhsn2Uabxx3PpFTJBhOx6p5xph6s8vHhufXIdeamYOSuJE1gmVE5Cy1sSPiyV
	TfLTFW3Y71ASTAbQjQSVz4tk3aNfXpJluWrZdyGR7178VgtOTmogCsXX8HoYSCDXLXqRxff/Dn8
	lzIxNSu9WpeOsWTgc9Qcg2djXl42EMhrJs5DGprC6sd8PZ1+aRZ9VcLMDTHvb9EKeeHszpw0mI4
	RI6ucA7Bl0d6WXlwJxoeyR4hIC9z4qmZJI/yPtZ+yayJx2yLh7A2H3FAua39LvVkGB3VXHQqCSz
	FXz2UYqS2wjv/I2uYNAoCu8cH+UW0GiClvrCtX+ElUtL/41Cih0aPfk5tuHVerweWpiOs224wE/
	+bDduI6f3dHPWsQqkNvjmfAejbzKhDn7jukF5HNS5P3Rkk7VuW9zc=
X-Google-Smtp-Source: AGHT+IGGcSgtma54hv+7RKzmUmjycRVqw/LnJDNDCrdXo50noFmBCjb2IbQqtC0Ft6zra7BT9FpOHw==
X-Received: by 2002:a17:902:d4c3:b0:28e:756c:707e with SMTP id d9443c01a7336-2984eda94d4mr56523225ad.33.1762984620190;
        Wed, 12 Nov 2025 13:57:00 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccd1fsm1507945ad.110.2025.11.12.13.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 13:56:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vJIpk-00000009zCe-0KVQ;
	Thu, 13 Nov 2025 08:56:56 +1100
Date: Thu, 13 Nov 2025 08:56:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
	willy@infradead.org, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRUCqA_UpRftbgce@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>

On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> This patch adds support to perform single block RWF_ATOMIC writes for
> iomap xfs buffered IO. This builds upon the inital RFC shared by John
> Garry last year [1]. Most of the details are present in the respective 
> commit messages but I'd mention some of the design points below:

What is the use case for this functionality? i.e. what is the
reason for adding all this complexity?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
