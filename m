Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B713A8E2
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0mx3CguK"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3ba31cc0d77so3835617b6e.1
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 13:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1703021357; x=1703626157; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kbm/EMk0Ly2kzGxZfNyYcrEMRxJGcrgqKmoRxqLVmUM=;
        b=0mx3CguKK/jiViZ0CNMq9O+1nXIi531cfUqACHG5eHcDsZKrbNPnm7CRXoRiggRWHQ
         8KmnWqrHSHU0lDYdQoSu/SWfX5knGPqRDPMDR4bXTlVXZz0BrnuA14LdvtZyNOtODsNu
         LWh8+K3v6yTviurlhm5DRBeJTTy8PZyP4QCvPW8kabF7QJ84dbDbZ/etghzMLKp+NdmG
         L7b+6UlfHQmULI925ZYE4C4aRSUn373X4rdDepcrKFQNMeZtR7E3K3MEjuWSe3emrzj+
         mSlzJ/4SudG3PSSb/RGXCMt+eKVMdvxvJ2OwP2XEFgzDzmvPJUS23mh3d0Zc/55ZBJU4
         KZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703021357; x=1703626157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kbm/EMk0Ly2kzGxZfNyYcrEMRxJGcrgqKmoRxqLVmUM=;
        b=NjBLxdxJd9iSbA3+Tz7PF0Mrqnh1M1gRBHNZmEfW2Z8sagVJaKV/H005ybFE9PsfBE
         9H7ysBmaGjSSzEgikcAsjreZVH4PHyOQSMuRZ53COChZES1F/mHjAHye/phKZwF3fIbd
         0aJQ6K0uKriX2U553MlrDR2TsfEVmdsBVl87jtVLBr7O/wikK3J2CCYuAjgsZ+Khnm1V
         zLD4wf76oJi8qFFaoEe2dEJ6NqGX47a+ocC1myaZd9k+/lhu9/POr0vZAWxDpn3VOqvo
         ej7w+PQuq01u9xxgFYPd5LoHQw/UrjCozh96d6I0kJBFpUdS/pw9XbjPhmd6TkmrW6Uu
         pgsw==
X-Gm-Message-State: AOJu0YxktTWdo/RWQ+EaVM8HAFYQAJavrcxF1+FQq+uWn+ELpnxVet7Q
	iXIRkr/DFXNfiizYGBmsNWV+ag==
X-Google-Smtp-Source: AGHT+IG6gVhXg5TvnAt2BU33CZfNDBBaDipYD/AFhCLF+GyaqEAZlgBzy2AIz3KT+APzFn+atsIoBg==
X-Received: by 2002:a05:6358:91aa:b0:170:ec2e:4373 with SMTP id j42-20020a05635891aa00b00170ec2e4373mr12955682rwa.6.1703021356728;
        Tue, 19 Dec 2023 13:29:16 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id ne19-20020a17090b375300b0028bc2e66f06sm1230406pjb.54.2023.12.19.13.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:29:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rFheK-00AbCG-2u;
	Wed, 20 Dec 2023 08:29:12 +1100
Date: Wed, 20 Dec 2023 08:29:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <ZYILKEu7c/R5zY1S@dread.disaster.area>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
 <ZXy08z140/XsCijh@dread.disaster.area>
 <D074B518-2C9E-4312-AC31-866AABE1A668@oracle.com>
 <6480D0D9-7105-41CB-8B6D-1760DE26DDE4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6480D0D9-7105-41CB-8B6D-1760DE26DDE4@oracle.com>

On Tue, Dec 19, 2023 at 09:17:31PM +0000, Wengang Wang wrote:
> Hi Dave,
> Yes, the user space defrag works and satisfies my requirement (almost no change from your example code).

That's good to know :)

> Let me know if you want it in xfsprog.

Yes, i think adding it as an xfs_spaceman command would be a good
way for this defrag feature to be maintained for anyone who has need
for it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
