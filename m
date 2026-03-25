Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855C436EA90
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432939; cv=none; b=nrG9V/r3JH5kPq1IO36TY2rcFI+wX1wqmv24iMOZu1bAVeZbBS6Lu/863yMkK6Zw5Fyk38wkeYDFJMvGRg44VJTOrcYqnjHwnNV2e5uIbKp0i1Em2WxiTkI20FhiXz1UNvpXkcyBMPPXXLBaBqDJ1m+SkGEkeZEJ5Votquv6LWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432939; c=relaxed/simple;
	bh=P3rvQK8EHY1Spejs6a+SvPn95uZfEHFfvTlYlTqRmJk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=j4BhH/2EaFr8k/9NTLgxSdACv48DaRhoRvGg5u4WITCgPmjY5Qn2sT+4AaVCR4np+/drqMLhLLfJdt4L1HiTUqYPGf/owy5heDwj8tkO1/TFaHzGGIJx98b2d+35gCPiMeRv1hHnM6PnHRyLlcXNw+mSwb5+0IUNANQJD5vJvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=Ab+nufVH; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="Ab+nufVH"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82ae378fff8so3604807b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 03:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1774432937; x=1775037737; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49iXHKmEQM2dhLWAHUR7DZSBP2ZJdulu8X9K0pNpkxk=;
        b=Ab+nufVHLy+sA55lrtxjk1Nt4BWdJCE9jKwJEgb9PAPwx+KJJXAgOLMEYgcGroSfds
         pYGz/mlzq9WBghl4xG6DUA9x2DI8W/ytiPY85UvEMOJ650pinB0VXSO/SfsCeC5EAZ8A
         5KVS4yWz0F6WmYfkVwF9x09ao7eGFGru8Yc/ohGnYP4cgGfifZo05y8fr72TJYiLqALB
         rtaecIdHfZyijrukXIe+/JBi6rR48jkvQP/Oimml6HrYb0+EiJ4jL4AqwLpiYKnvr9/3
         fQ8mmUhrtA/IPvY83gS52AbdCrgFHBeMn/fKXo+U9Iw/IW6u13KNARdzdk6AyH+ILvAn
         COdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774432937; x=1775037737;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=49iXHKmEQM2dhLWAHUR7DZSBP2ZJdulu8X9K0pNpkxk=;
        b=b+hhumYRnOUiSObbhAFp8dUbYz+p3yuwix3pJYQIcdaU9kRwi6poLtBL0xX2hJMyev
         owHkNIDgEEQ1szGwybzCjbH0Pb4YHCZE4DQUo7N/zFl3URXeARARES82IzAmJxLtOMCe
         KgxtRHCEr7T4TWVH1STGirsR5sHZGSsCc4aBo2086rR5JgKGoUNZiYd8OgDRD9fFRbLz
         pZn7B82Fz7GLLd/L4HbIKaOcDXNZ8fUDAfHNvFhZi36o1wg3dLIccuAo8yBIR3KZgu0E
         ekYgN7OM+eKcZgVMt+2DzkA59UKvqUiHovKht2Jnl+3LdFpbFqXqtP4SSowDEKrpzxd+
         50Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWWDbzv3oCCdmU4WMr5UporhLfwNRgDSVvyFhKOflsq9+pzKpbFxFyoYK8DhuqfSW8hrf+FOjpGjE4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq4BJ+rB6kqrbbweMvTxuNz6WhUgJs3cJJ0zhGvQNqF2O6ZyEK
	fRyLruAFrZU7mOCvj2EXJ/8GKs6eTdHbimt/xgmT+BXuTc6Omz+dMGZQtrY9v4JmQU0=
X-Gm-Gg: ATEYQzxBf2cDDlaSrF2Qh+Ac8Cp9wOcRCt7HgLj3Ot0ZBo7vwpTx4jYK56z3ijS9mkS
	BCa3rqpiIdNPD05qDzLLIlSWNk4eytv2w5/Pt8aoHNw0lLO50rLYhpg6EelF+7+qXiVeH2o4GTF
	CG8cAaUzDQth++OFH0vyWXccBIujOsyX9TckD2+phuKOMIW2a82iH1NwjLkI3a0OcgxosutCBZK
	lzVRPJOisWQNq+/egMXw6ThXEK7ar7ieIYIcKbRSDYk/RjUfncM8FYhz7B8kKU+qnHf12CHjFqW
	CHz2D0OELfF/HVDAmfPJg8roARSXe2JjtUnMrYPTweHY9GiTeIUgMCj8Hm9A7BHNQuwy0nacB+a
	0euNstTgtVhRcauz3Cy2nKskHxonRpF5gPD9Tb+QtwSq/L1w3R2Hp0+MHPqTZ5KdJLHY/W148Hm
	9hWquDHPPu6rrd1aI4cohXAIklfGIcW/dWiU5Hdq5fVlmYYDqm+Lm5LamGiz8+Zk5t1s8cCZJHL
	gSjxw==
X-Received: by 2002:a05:6a00:189d:b0:82a:955:50d3 with SMTP id d2e1a72fcca58-82c6e0d1e4amr3194806b3a.45.1774432936918;
        Wed, 25 Mar 2026 03:02:16 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa79c6sm15938724b3a.10.2026.03.25.03.02.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2026 03:02:16 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260323152943.GH6223@frogsfrogsfrogs>
Date: Wed, 25 Mar 2026 04:02:04 -0600
Cc: Theodore Tso <tytso@mit.edu>,
 Anand Jain <asj@kernel.org>,
 linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org,
 hch@infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan> <20260323152943.GH6223@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 23, 2026, at 09:29, Darrick J. Wong <djwong@kernel.org> wrote:
> 
> On Sun, Mar 22, 2026 at 11:16:24PM -0500, Theodore Tso wrote:
>> On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
>>> statfs() currently reports f_fsid derived from the on-disk UUID.
>>> Cloned block devices share the same UUID, so distinct ext4 instances
>>> can return identical f_fsid values. This leads to collisions in
>>> fanotify.
>>> 
>>> Encode sb->s_dev into f_fsid instead of using the superblock UUID.
>>> This provides a per-device identifier and avoids conflicts when
>>> filesystem is cloned, matching the behavior with xfs.
>> 
>> As I observed in [1] this leads to collisions when for removable block
>> devices which can be used to mount different file systems.
>> 
>> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/
>> 
>>> Place this change behind the new mount option "-o nouuid" for ABI
>>> compatibility.
>> 
>> I *really* hate this mount option.  It's not at all obvious what it
>> means for a system administrator who hasn't had the context of reading
>> the e-mail discussion on this subject.
> 
> I don't love 'nouuid' either, because it means something completely
> different in XFS.  'fsid_from_dev' or something would at least be
> clearer about what it's doing...
> 
>> As I stated in [1], I think the f_fsid is a terrible interface that
>> was promulgated by history, and future usage should be strongly
>> discouraged, and the wise programmer won't use it because it has
>> significant compatibility issues.
>> 
>> As such, my personal preference is that we not try to condition it on
>> a mount option, which in all likelihood almost no one will use, and
>> instead just change it so that we hash the file system's UUID and
>> block device number together and use that for ext4's f_fsid.
> 
> ...but why not just set fsid to some approximation of the dev_t like
> XFS and be done with it?
> 
> st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev))
> 
> There are a few other single-bdev filesystems that do this.

On the flip side, if the fsid of a filesystem changes because a new disk
was installed on a server and the old disk gets a new device number or an
upgraded kernel with different device driver load ordering, that would
also be a big problem, as it would break NFS file handles over a reboot.

The whole point of generating the fsid from the persistent storage is that
it is persistent across reboots.  It seems like the real issue here is
cloning filesystem images and not assigning a new UUID to the cloned image.

Cheers, Andreas
