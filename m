Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377C2622
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 07:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718262293; cv=none; b=ha2JfHGT71PH4IQ78exctRKZwllR0/jJB2j3ag5z77/3a+CC8k0CblVEaXj+NawaRnGxBpFfX/P6plQHgBum7C506tm+0dEgbPQWNn5tdr7QZSDxjUrU8MezBvpEd+/aYzpDz9QlVyM41joL65gyCW8klHovk4VN/BfEGmaRAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718262293; c=relaxed/simple;
	bh=tqf57pEXZhdQY5whDZtFCCyrgmnUa5qs9xklpUcLzmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJPAH2OovV1EHWZrXJaZCV7EvKstE9DhRG4LEX5vTJS2UqoHY6WXLAhDolSCuhwjPkj/qOY7mHN7ZkK9aPa9cqSwroBIo95V3jQNr8cIOHxbABiDiM9aE2n7+TdZQtbCwi/XETdLdmACICHACcYBnDYy7kXrvBJbE2zPSwFVXoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qN1ynwmg; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qN1ynwmg"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70436ac8882so513629b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 00:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718262291; x=1718867091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGxhW9jYu4dvA/FVC0x1GQpkugwpaITEtOMCepOdfrk=;
        b=qN1ynwmgFH6m18ukBBbsAuWq0rrY2AxkeDNdzJbs8o8qcbKsglbDiBZ+ZgJQQfYVrj
         KCpdUGnxul68QuPNza1eFJV3rIDRaRHwsxKKCp1kEtfyfZWWW7IyYvo1+Plo+V9cJn2d
         tQyd4DRTRlqzQw63dG/JkdkVkGfl7wJ1sc+kN38eX5p7/C1HT7gNb929pGfEvsULqb9/
         +bRXaIAhNdZk5nNd2KYPJYLVZDEnCXH/asZfDYrh4E7iu+3aAfLzxdApsEIzfEn/ByBO
         a7lpgnxvEN6lkHIBt9+vDaVVP94tbYv9wrljBl2Yoye5mR9pbEx7BN3eJk9Ogyf+ithf
         rK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718262291; x=1718867091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGxhW9jYu4dvA/FVC0x1GQpkugwpaITEtOMCepOdfrk=;
        b=e7E+Ci9BaBpIcAg3EW8lHIa06d/+SkWjX6KXxwvapJnxmb+lmxMw+zvhSlDBmkgq/d
         Z1MnDw9bjuKYhbdCRo21nsclD9PE/FRtEsxEhTlKrdHkYE4Lk58YvKBprsL/b4PpnnXF
         CimyoPCYVbk9rXRcE5fAzeC2einN70bx3Xri8tudOQdVuI/Js2ohFqUKw4QgA3NSIlN9
         lwG1TCvx7fbIHtAqNR+J1EPRmNlFsma1w4RMCeYKDu4W1XHSzAlWbNsOiILfk4agf899
         ni83ZCAh6TvrOBw7kMLsy/654jfeodxClXLegFikDa2CVhkCp4LW4mnhzAJkxgt2ndgr
         kZNg==
X-Forwarded-Encrypted: i=1; AJvYcCXc66FOZpHeIOgEVL+rorjdMbnvtfmoU1wQRtox7k4LLbrBZp9WeNVMerfpFgcETfHYFHgKfvLKjyv+vRxaP6aFQUIvSJhDfQJT
X-Gm-Message-State: AOJu0YweNSzGe3b1aDyDsLbgCd+Z+i5jON+aCTSS954nwq4WSH0eCtYt
	24TN7pvSfWEmveTgJB7ou9Yu8cikrNYCi8C9tNz4dLzLB47DtlY6PjCDr2FxbjQ=
X-Google-Smtp-Source: AGHT+IEQ4cuF19QtIsRvSkkS5xWGhxUxN8Ymqyh99CzJs9BE+jcoqj5LYl3za3TJyzgCqI2Z3FAYoQ==
X-Received: by 2002:a05:6a00:1acc:b0:705:ca70:27c1 with SMTP id d2e1a72fcca58-705ca702aefmr1617993b3a.25.1718262291141;
        Thu, 13 Jun 2024 00:04:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb93e11sm661929b3a.198.2024.06.13.00.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 00:04:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sHeVr-00EEug-2g;
	Thu, 13 Jun 2024 17:04:47 +1000
Date: Thu, 13 Jun 2024 17:04:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: verify buffer, inode, and dquot items every tx
 commit
Message-ID: <ZmqaDwbXOahCAK1v@dread.disaster.area>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>

On Wed, Jun 12, 2024 at 10:47:50AM -0700, Darrick J. Wong wrote:
> The actual defect here was an overzealous inode verifier, which was
> fixed in a separate patch.  This patch adds some transaction precommit
> functions for CONFIG_XFS_DEBUG=y mode so that we can detect these kinds
> of transient errors at transaction commit time, where it's much easier
> to find the root cause.

Ok, I can see the value in this for very strict integrity checking,
but I don't think that XONFIG_XFS_DEBUG context is right
for this level of checking. 

Think of the difference using xfs_assert_ilocked() with
CONFIG_XFS_DEBUG vs iusing CONFIG_PROVE_LOCKING to enable lockdep.
Lockdep checks a lot more about lock usage than our debug build
asserts and so may find deep, subtle issues that our asserts won't
find. However, that extra capability comes at a huge cost for
relatively little extra gain, and so most of the time people work
without CONFIG_PROVE_LOCKING enabled. A test run here or there, and
then when the code developement is done, but it's not used all the
time on every little change that is developed and tested.

In comparison, I can't remember the last time I did any testing with
CONFIG_XFS_DEBUG disabled. Even all my performance regression
testing is run with CONFIG_XFS_DEBUG=y, and a change like this one
would make any sort of load testing on debug kernels far to costly
and so all that testing would get done with debugging turned off.
That's a significant loss, IMO, because we'd lose more validation
from people turning CONFIG_XFS_DEBUG off than we'd gain from the
rare occasions this new commit verifier infrastructure would catch
a real bug.

Hence I think this should be pushed into a separate debug config
sub-option. Make it something we can easily turn on with
KASAN and lockdep when we our periodic costly extensive validation
test runs.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
