Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4826263899
	for <linux-xfs@vger.kernel.org>; Sun,  5 Oct 2025 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759665304; cv=none; b=sHdRk3Ik/SJK1gcLuOHmplDcn8TKaDNLPhY7tMrUWnqTAGO3EKRMbzYzp5yXQZTQZdnYp8UMcyCPU7W//oWXde7ET6Fwk87Sww2tEHOoI/2U3yAwUSw2SgHpNrJrT23Ua3Kw8zPy5Omxa2//F8D0eaHfIAoip7WxRwgz/EeZPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759665304; c=relaxed/simple;
	bh=Wtyt1KzFariMlIeI+zEEMW0g/K5OklBCf8gbMrkr97g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJJhx87aah+1xZ1b1E9E0gpkXz/qHfnF08eGBIC4JC8S0o+tqGOp48xvEZjcwbooHr2Tr8kfyC5raoqO3a5cijq6GgcAz6KaiE6r/F0jMGB3N0njpeOEFdsWBXc73fYCCuZYzeuuX3fy4QVbnRoGrAPgr/9bjyYpw7G7uk5h3JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aO/Izd9C; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aO/Izd9C"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso3192336b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 05 Oct 2025 04:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759665302; x=1760270102; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=er8GqX660tZxnm8yI7a7bHZtQ/sKKbb/5edfsYblxJI=;
        b=aO/Izd9Cm/ZGC3X5xOU5tFTzId9Re6hJdwHBU4kgov4ZX6NkMa9qOr9z6sMAHMfIER
         3ap5RnUWFJuGdMvpNJg5yhUp8bA3Ol9+Nu42RCW5GEZPGm6ixfQN9qjao/dhZmQm1uQz
         DXvOunQpJrwctf0sO7AWGIbaFYPKuuDa7z9gAKlkSWqaDdMRYianEdqV1AybyILglAI1
         HsrAerPxfDXiM1PU7rJduP1eDQnYGIb5DByef98c+l76Sidpw8iiM/bOh2cHV9xJXqIq
         BTJa+6OjVvQAwscodgddkB/wVEa0uKJrKg7YOZpP3f+AIckB8S+dWurzP3wsKsWCahyX
         aH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759665302; x=1760270102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=er8GqX660tZxnm8yI7a7bHZtQ/sKKbb/5edfsYblxJI=;
        b=aZ0fcDqiEKx6UH6SNyvDCPCppYczN9Mh1Jiit4tL6w38p9h1Yyhp+UTNZhhLt7gsb/
         6BjVzdS3pnqX6/vqWYGnhDRvpnMTcO0en+O9LGfQudSz6mVkDGj+bOshaiz7grTPqX0o
         2AgIE5TqML5hvBCv+g+959Hw2gxSVHR1o7zeXR/fGLwoZYAtF6DZv2JJxVZhqiDC01PS
         DX0LcmxCvT9FLSf4ciyumPb6OfiPTdYnKCjMBAMRHcgpdW3FdpMS+Oc6zPuKqimRWlzj
         SSbknPKbJhr6iyL7qO2MjaLx6Hs37eG9G9HZC4FQtxZNGweaxeUXEBRhAR6IYUea8Y++
         K69A==
X-Forwarded-Encrypted: i=1; AJvYcCXVwDB7yKEhSV5z4Y1pDyMvhpMebsapTF+mImUlefTYC0Mm7xPzhau0hHCzc/TNebP4g7E5NuYdBM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyenAliIBx7JfdPixX9OWJcQO9rmZMSQiedX6zF0IGojsQ785k0
	iHhTx080P8b8FBBmxtHuzjaVbw3Ly2TeVCgFokmQ3+tmrJoOTvFiNKj4b8/4aL5k0UI=
X-Gm-Gg: ASbGncutcXezgF/PSCZRRI+yboDs82NljPpJwVTVruRf+0Rjluu7cOI6VWLNupVfzEL
	MqWUvm8/dtFKdyJJi/yyCGhFsHHeoQrpKJ07BeJYnC9r1SrWMjc9YP2DXh3Ptx6ZfhofxENsq5i
	DOjL3hgDqtgDU4K65Ti61cVUCL1og0ULAY4rkDxcSWIhMR8k2orRYnrXVILFnBBnZDE/KzBcVbR
	Ghimyp0l9/Els4pgvTcBhRDBN5AaJh9MwOlyJKxy0k3H5HUyhirCpNHcIl0YJTuvNx9q9CQE1HQ
	CcQLFVgNWYT8veiY6paFUHsTLujh18w+/80aWYdB+llYYDzn7hBhS4zeaOrf6i0uZ/HFzWV7foX
	9LpBpZLNDHGzuwRaVBA1atfMSsatbm+BQT9cjWbpUds/BU/z9pqEjJ2+ikyCmmvS8/urOq7lfLR
	EjD8vSCJpeMx5l3Ay+Vhb81w==
X-Google-Smtp-Source: AGHT+IFJenQ6xCL2kkGn0U9jKhBNcjWIfEAKLRN1RcMC27u89D+ljxfEAw22GmeKD+TuSCTAFauMxA==
X-Received: by 2002:a05:6a00:2e04:b0:77f:1ef8:8acb with SMTP id d2e1a72fcca58-78c98d45544mr11521737b3a.13.1759665301391;
        Sun, 05 Oct 2025 04:55:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b02053a3asm9874688b3a.48.2025.10.05.04.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 04:55:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v5NKL-0000000Aote-3xSr;
	Sun, 05 Oct 2025 22:54:57 +1100
Date: Sun, 5 Oct 2025 22:54:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: kernel test robot <oliver.sang@intel.com>,
	Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  c91d38b57f:  stress-ng.chown.ops_per_sec
 70.2% improvement
Message-ID: <aOJckY5NnB2MaOqj@dread.disaster.area>
References: <202510020917.2ead7cfe-lkp@intel.com>
 <20251003075615.GA13238@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003075615.GA13238@lst.de>

On Fri, Oct 03, 2025 at 09:56:15AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 02, 2025 at 04:11:29PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 70.2% improvement of stress-ng.chown.ops_per_sec on:
> 
> I wonder what stress-ng shown is doing, because unless it is mixing fsync
> and ilock-heavy operations on the same node this would be highly
> unexpected.

stress-ng puts a fsync() at the end of every ops loop:

	do {
		int ret;

		ret = do_fchown(fd, bad_fd, cap_chown, uid, gid);
		if ((ret < 0) && (ret != -EPERM)) {
			pr_fail("%s: fchown failed, errno=%d (%s)%s\n",
				args->name, errno, strerror(errno),
				stress_get_fs_type(filename));
			rc = EXIT_FAILURE;
			break;
		}

		ret = do_chown(chown, filename, cap_chown, uid, gid);
		if ((ret < 0) && (ret != -EPERM)) {
			pr_fail("%s: chown %s failed, errno=%d (%s)%s\n",
				args->name, filename, errno, strerror(errno),
				stress_get_fs_type(filename));
			rc = EXIT_FAILURE;
			break;
		}
		ret = do_chown(lchown, filename, cap_chown, uid, gid);
		if ((ret < 0) && (ret != -EPERM)) {
			pr_fail("%s: lchown %s failed, errno=%d (%s)%s\n",
				args->name, filename, errno, strerror(errno),
				stress_get_fs_type(filename));
			rc = EXIT_FAILURE;
			break;
		}
>>>>>>>>	(void)shim_fsync(fd);
		stress_bogo_inc(args);
	} while (stress_continue(args));

It's also triggering a change in rwsem contention behaviour on the
inode->i_rwsem in chown_common(), from sleeping to spinning, because
fsync() no longer causes ILOCK_EXCL lock contention and causes the
task currently doing a chown operation to wait on the ILOCK_EXCL
whilst holding the inode->i_rwsem.

Hence all the chown() operations now trigger the spin-on-waiter
heuristic on the inode->i_rwsem as the lock holder never releases
the CPU during the modification. That explains why the CPU usage
increase (from ~2 CPUs to ~50 CPUs) is way out of proportion with
the actual increase in performance.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
