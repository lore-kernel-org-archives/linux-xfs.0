Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0AE3E314D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352907; cv=none; b=T7h84wnSS4SwaloIZFnRtuIyk47vHChFYtzOGMsf2b33ys27uLtJiuNuVsyT7NyLt6zJvcOYlqjdfq/5llc1vz9KXa807Nxn6+V00B5rk83nGb6GHTiAXkmUAVFSCXqBsLXWFbIX6S8jbtuXf1umbbCRDuFjxCVFBrPHz57jh+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352907; c=relaxed/simple;
	bh=tRMmlzxvSX4htYuEHCnPs/qYReuyqniRG4vNY3fWEME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sABDeTL70i6GsMsesB9WD8XlDzAtz2GadJ5iuDetwh0dFYzLrjyzhIdCfKFqNEEnpqH4bjO9DFByncYvAN9RPfLtLetgjC1q6xS34ltlp74YoC1X5RSVNp2K1v2Fa1sCorrBLgCSmFFzr1vhqESCt2iY8Uu/4LKD4Uhuf8Ird6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrZLPyL4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrZLPyL4"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b4583f0a1aso29652895ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776352906; x=1776957706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQW1GsyE5hA61Va8D6UzmdjO7IhbJJ2/YT9xpWvxTgw=;
        b=XrZLPyL4fI1ShvLs8KDuZaIWdVnzv/9dSzITtZ8aVMmdqiX50nae8FxZrNyx5WAtDU
         JpzkoHH1kStMFeQuP1w5zvmjdO1Qbnn41XVvzJXcXNLqcdHxwNl391mIyhnIXcwXz2YX
         dtYPDr2yzTEzHl44xLZGQFkqmOL4Cv9uHLc8SrthyR96tIesLsQETMs5e9Mlx/uf6Oqo
         o1N5GQXQe1IYPh4t1gkFO0JZkWHd3TZ9VGt6KVhHapzh9iTKSLqvDTnxv3O70uCupPWF
         hOd73FRh/qVeGoNjl4CxphG/3/mLpC3dNnRBhMmKT3hroNaDHse3JgkawwOvRLsMCmcX
         r8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776352906; x=1776957706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kQW1GsyE5hA61Va8D6UzmdjO7IhbJJ2/YT9xpWvxTgw=;
        b=rovaIcWeXRyr7xwlyCJCmoOAni27QzDb5242c/mSXM1lV7yRn9CrNmxrncRafxgjpu
         VXZH6Pic/C+Q4U91UwPqaZapfFXOV0vc3cONj9tMcpoZpf1ZNU5hcs7L86kn2fKKNA8+
         xpeRPbWsUqaAe9E2q3yhoW6fBKqm597fHPdGTNfRkUXKsVSqT5venlLPSlEW7nEm/Lm5
         zoV77NqmyKeK8ackUOuvG9dFxIA4abvmdE+UMFN3mazJaRhbegQYqPnGcS2FpOrxG0so
         rHvOtvg7tyJA8tQ7zFdOu8F2Xk6VmKXcVVIEl4mX9rFdHVqGqn9X/KUDAbkNS6pzgD86
         9q8w==
X-Forwarded-Encrypted: i=1; AFNElJ/N7RtCATL7GhKLxE5bXa5Rz9kQiXawI/JtAD7QXDD70bm/xYZfVlzcWOSHufSaCGsN9l98fGhpPeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrFqtUMhNplhqtm9eeAfH0611akUj08MjzVDn2jHQjm9na6t5p
	53QLFdHB3nDmga11owK/1Gy6X6mx2Cj016OCg1XET0EstOWwy5J5lM5P
X-Gm-Gg: AeBDiesiBsKyklXpRNEkGzWmrx7JsRdrzuixwvHZheh02RcP6gS9P4mGN9NKITBVYsJ
	PWgwvWN3KZl5fqVBVYTo7G8cvTi/9op5qnepMvS6nGxc/Sn6R2YctR6jBD4n2SFWbBCmBDnPahy
	Jmat8YJaxWcJFJrNXAviTAa7ACXqoWHzNBVxLDpyUTnN6jl8XYhio43uk2D6sE9Zx5m7rmY3krE
	RYc3hwDKRCGKy0saHG5EfwGFwW1uO90HnQHG/YUYTy0zDmcGxOtvCGvi3vSrqZqFE4W7S1Ysoep
	TyNkjDJI3c8kdvn25DbOAkWHEI8eWKYAJ/XWz7N5dLJqJ2rQD3L5W3+bv4w76JJfib887Dccx79
	+GklsciJIErm1ku5tuF+5ckCUb+E+KXa78bw+yHOOhXyNzRlpdNAAKDZCs/8hz0AwU+A7u2535P
	3ook/zuZvkHU9N+OFeXFYYJdYtzfeH3Q6Qfjv56Q==
X-Received: by 2002:a17:902:d583:b0:2b4:689a:e420 with SMTP id d9443c01a7336-2b4689ae791mr137815045ad.8.1776352905586;
        Thu, 16 Apr 2026 08:21:45 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b47826e90csm57355455ad.38.2026.04.16.08.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 08:21:44 -0700 (PDT)
Message-ID: <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
Date: Thu, 16 Apr 2026 23:21:41 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20260409131238.GC18443@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/26 21:12, Theodore Tso wrote:
> On Thu, Apr 09, 2026 at 05:45:24PM +0800, Anand Jain wrote:
>>
>> Got it. Do you mean that since both filesystems are identical,
>> statfs(A) and statfs(B) can legitimately return the same values?
> 
> Yes.  f_Fsid can legitimately always be zero (which I believe is the
> case for FreeBSD, but I understand that there are some programs, like
> systemd, which subscribe to the heresy, "All the World's Linux", which
> is a variant of the "All the World's a Vax" or "All the World's SunOS"
> at the beginning of my career :-).
> 
>> I'm not entirely sure what the correct expectation for f_fsid
>> should be.
> 
> That's my point, there *is* no correct expectation, and I don't
> believe there can or should be.  What we should be doing instead is
> actively discouraging people from using f_fsid.  I suspect that's one
> of the reasons why FreeBSD may have chosen to just return zero.
> 
> Which is why I don't think we should be testing this in xfstests's
> generic/791, either.  (Unless we get consensus across file system
> developers abnd willing to make it be a documented behavior as of a
> particular kernel version, and we then adjust the test to skip it if
> it's older than that kernel version, so it doesn't break LTS kernel
> tests.  See below....)
> 

Yes, the idea for generic/79[0-5] was really just to make sure
we don't accidentally change s_uuid or f_fsid behavior without
realizing it. It gives us a baseline for current and LTS kernels
if f_fsid/s_uuid is changed. (Some of the submitted test cases
may still need revision).

>> My initial idea was to make f_fsid behavior consistent across
>> major filesystems so that user space benefits from predictable
>> semantics.
> 
> I'm OK with that, so long as it's unconditional across all file system
> types (ideally) or unconditionally across all major file systems (xfs,
> btrfs, ext4, f2fs) as of a particular kernel version (which is
> probably much more realistic), *and* it is documented in the Linux man
> pages as this is the standard behavior starting with 7.1 (or
> whatever), and that the man page further cautions that programs that
> expect to be portable to other OS's (MacOS, FreeBSD, Solaris, etc.)
> should not count on this behavior.
> 

On second thought, we should perhaps consider a more robust ID,
let's call it `f_fsid_v2`. More on `f_fsid_v2` below.

> But given that you originally stumbled across this with Overlayfs,
> because it was originally using s_uuid, and that didn't work well for
> btrfs, why not change overlayfs to just use s_uuid plus kdev_t in its
> xattr, and just fix the problem for overlayfs?  That has the benefit
> that it will work for all file system types in Linux, not just for
> those where we have changed what f_fsid does.

Using `kdev_t` (or any derivation of it) for persistent storage, such
as Overlayfs xattrs, is problematic. Since `kdev_t` is transient and
inconsistent across reboots or device re-discovery, it could lead to
broken associations.


It seems we've reached the functional limits of f_fsid.
If we want to solve this properly for Overlayfs, NFS handles, or a
complex system monitoring..etc, we need a new identifier let's call
it f_fsid_v2, that meets the following requirements:

  System-wide Uniqueness: Must distinguish between cloned filesystems.

  Persistence: Must remain consistent across reboots/HW re-enumeration.

  Non-On-Disk: Must not be stored on-disk.


One possible implementation for f_fsid_v2 could be:

   f_fsid_v2 =  hash(s_uuid, block_device_serial, [subvol_id])

For pseudo block devices (virtio-blk, loop, nbd, brd,..),
the serial could be derived recursively:

   serial_number = hash(backing_file.f_fsid_v2, backing_file.ino)

Note on Hardware Serials:
 Standard storage protocols (T10, NVMe, SAS) mandate unique,
 persistent serials per LUN. While I've seen T10 protocol
 violations during my time authoring Solaris HBA drivers, I
 believe these outliers shouldn't dictate the design.

This approach provides a system-wide unique ID that is persistent
without being stored on-disk. Effectively solving the cloned
filesystem identity crisis.

Thoughts ?

Thanks, Anand


