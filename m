Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB93B19A3
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436379; cv=none; b=USWUVPUQVDgnfl6rgv+F25z0QMMXA2K7GuZ7UGI4xZLDKub+rA+EbOOz3APDEkx/3pirfVpeq0z74nBHPhaUHXXzZf7zkFbD5ThKesSbSH7Znq5TMZhS5U54W5GFgSFSVztQxia7nA/05cPq20z3fDzpwcFFywRYT7dt/FeoRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436379; c=relaxed/simple;
	bh=ESSmAusi22zNrBrBrCZkk53AgiDttI2zhQYE6wfMss4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tyx0ClYG2speY+QvEke3wVDoc3WKiVz8BHIdSX2aNq4JqOMTKg8rJ6Kaoqxdfw9MxOcjyjA6EEWrBmk6lyMPZdPnzyyRteUdEMP16ZD/nBqEgAzMMu+8Ca+DNb8liEVEv7L1uTFHA46GQ4fF4ICDO8DsVAeeSoO9G4H9HdhJ+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TMExgBuT; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TMExgBuT"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35a094cc3e9so4317350a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 03:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774436377; x=1775041177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kkhBUMnec/GjdnW5fmLX7Wmb/ODJVypSPDeWmYyRkhw=;
        b=TMExgBuTCemrOuxxCujCSsuE1yJfYUP7dyClGWoO/so6QSTavU2Q2xGlEu0qorXHy/
         oy3e1MznEJDBJeYVk1VPHynv6r/J0Blr0vUPkPIG430TMIBnOAZQqcX0ScQLutlVCHOL
         cPj9kXZzUIMO8nnhKcuFF8vyVWiUj2q+Ul1fBVHaDMeJi8hVcZnfQQvdK9bjq7WWIMeo
         638f2ADX1TEmNtNdY5Y/qjzzNKACP2wakS9qBdA7F5LMHUjbidliBSs3MO0sBCK6D0LA
         VdZcRadRmRFLvCnqeWNXZ4NqV7tv4meEMInfmgDGKbhPvTIy96dHjnD93lW6L8mJONCh
         m1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436377; x=1775041177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkhBUMnec/GjdnW5fmLX7Wmb/ODJVypSPDeWmYyRkhw=;
        b=owENWFq0ylJxy4GzPl4SDxZo5Gjyeh1I5I5E2ylqaz91I4Z6IXHICzCaqtZc6p+rJu
         IrKJ6zxXaZZUAzVXEyqP5bq+ZjR6e4Winn2rksUe7AhmuFgm9S7W3M0X5/aUbve9fk2X
         TdMgEMa/qhDtaUqx1sZTyIiSYCTGe/KY+xtl3pdpH7n12Q2N/vfrKEnOXv5DAzoHFE/9
         3Qp2d/4CE8tm653r2X4adS+oU+irb/GVDqFQVQpUF7ERLQNVsqs96IblLO8Jmc9XihEN
         EG68QZxvZn7SPP2bs/EAvUsNdS63PGs3PjnBs7JPgVn6P5sEnyfRFLJ6I0zUR/Deb5XQ
         RVeg==
X-Forwarded-Encrypted: i=1; AJvYcCWARiI875jPDPyFokamS6hBA0/hy3i4f1BGKlMOkrA6/sVNd2aRH8rwkzm5eoJ3PCapP2YeP9nZPhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJplLLdNmT2K+wC+HBcBDsTez6GjDPkIKEsKy+U4ksEN/sfJYR
	F/ToV44dfZzoeE8iMr+d/EDP2CGDNlx/aEcjCL77xuptcSkG4w6x40EY
X-Gm-Gg: ATEYQzxxpiHAMsR100GKzoUUb11Kc6LlucuoTShIMp+7gJwdtJq0bXik43QbfGlVXXJ
	Ggrwb2B2V0iAxwvf7N5wjSuLuSCJ/mC4/SeFu+j3QwOKuJg/5ESaZDNGcPdo0IvTDJ+hbn/vL+r
	zAacG84O2Fq1yJuXiYxOguaJwq5E7qNbtm1hUUd1+FiYJTCq/zt703ZlBGbygTf3FC1M2HCKP27
	29D5Ynvz91sp0hr5U5xATRws9cgHjKOC2IHx78DYl8x5tnSdGps4/LpYbmYRsYFKQwBMbMwdQnZ
	UWu/EXGCPWBk4Yuvif3lpbNDq1jq/aupb653zAtx1ot6u2CEtnxlMvyIC6J1kJfyTs+B7efRXz/
	VoCQd8PYQUcWfmqwNb/ILty66o5MeoWDqVkOk8DXXw/K8NMKoCLH5aGAhyW+pdmhlk0mIGXNcg0
	RhpL2ZhkAVhebl0rlQvQylGWu7w9M=
X-Received: by 2002:a17:903:440f:b0:2b0:700e:fc9b with SMTP id d9443c01a7336-2b0b0aea735mr36634815ad.34.1774436377001;
        Wed, 25 Mar 2026 03:59:37 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm182971235ad.33.2026.03.25.03.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 03:59:36 -0700 (PDT)
Message-ID: <91d1e10b-b24d-477a-8724-2a75a710dd8d@gmail.com>
Date: Wed, 25 Mar 2026 18:59:32 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Anand Jain <asj@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, hch@infradead.org
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan> <20260323152943.GH6223@frogsfrogsfrogs>
 <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/3/26 18:02, Andreas Dilger wrote:
> On Mar 23, 2026, at 09:29, Darrick J. Wong <djwong@kernel.org> wrote:
>>
>> On Sun, Mar 22, 2026 at 11:16:24PM -0500, Theodore Tso wrote:
>>> On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
>>>> statfs() currently reports f_fsid derived from the on-disk UUID.
>>>> Cloned block devices share the same UUID, so distinct ext4 instances
>>>> can return identical f_fsid values. This leads to collisions in
>>>> fanotify.
>>>>
>>>> Encode sb->s_dev into f_fsid instead of using the superblock UUID.
>>>> This provides a per-device identifier and avoids conflicts when
>>>> filesystem is cloned, matching the behavior with xfs.
>>>
>>> As I observed in [1] this leads to collisions when for removable block
>>> devices which can be used to mount different file systems.
>>>
>>> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/
>>>
>>>> Place this change behind the new mount option "-o nouuid" for ABI
>>>> compatibility.
>>>
>>> I *really* hate this mount option.  It's not at all obvious what it
>>> means for a system administrator who hasn't had the context of reading
>>> the e-mail discussion on this subject.
>>
>> I don't love 'nouuid' either, because it means something completely
>> different in XFS.  'fsid_from_dev' or something would at least be
>> clearer about what it's doing...
>>
>>> As I stated in [1], I think the f_fsid is a terrible interface that
>>> was promulgated by history, and future usage should be strongly
>>> discouraged, and the wise programmer won't use it because it has
>>> significant compatibility issues.
>>>
>>> As such, my personal preference is that we not try to condition it on
>>> a mount option, which in all likelihood almost no one will use, and
>>> instead just change it so that we hash the file system's UUID and
>>> block device number together and use that for ext4's f_fsid.
>>
>> ...but why not just set fsid to some approximation of the dev_t like
>> XFS and be done with it?
>>
>> st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev))
>>
>> There are a few other single-bdev filesystems that do this.
> 
> On the flip side, if the fsid of a filesystem changes because a new disk
> was installed on a server and the old disk gets a new device number or an
> upgraded kernel with different device driver load ordering, that would
> also be a big problem, as it would break NFS file handles over a reboot.
> 
> The whole point of generating the fsid from the persistent storage is that
> it is persistent across reboots.  It seems like the real issue here is
> cloning filesystem images and not assigning a new UUID to the cloned image.
> 

IMO, sb->s_uuid (as used by overlayfs)
Represents a filesystem UUID that is persistent.
It is derived from on-disk metadata.

statfs()->f_fsid is..
A kind of runtime filesystem identifier used to distinguish mounted
filesystems within a running system.
It may be stable across reboots or device removal and reinsertion,
but this is not guaranteed. It may change if the device dev_t changes.

I have posted a set of five test cases to the mailing list
to help verify these behaviors, for your review. Another
test case to verify device reinsertion with a different
dev_t is a WIP; it will be submitted along with v3.

Thanks.

> Cheers, Andreas

