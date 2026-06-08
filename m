Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CA23EFD04;
	Mon,  8 Jun 2026 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929801; cv=none; b=k5H4jCinEcZLuGyGZggxHYGpvRb4uViVt2ZM37g9+FKXX9l1Dnh/+FKYXnQ5hQe85p1D46/kzERH4wADlaeziaIKlsP/McqJXO/4tahBc3g+8uvlDuiBsU2+p7fDi9ijh+Ld3ZCC/zNLnOxJQtw0j30M3uDaFeeJD67Z/wRgG2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929801; c=relaxed/simple;
	bh=wuZc+K7tw+E9I/jGxHgS9mrEe/FWNWNXEHO2pFPn8zQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UtEcPV1AKytQbZu6YFMzqOcea/mbFrCNUkDgRhHgsRPoEbUr3v9L3+VLalUX1amYX0tUk3MEzptX6QYyhWMzgUHycyp7ecdrIPTkqB+kTVxlxyGIclMgZWeuClkVMnObVhMFr3hzmUHIXHc70rarWMFhkrFIUM1UKydlu/KrA7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4i6QXqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4i6QXqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE811F00893;
	Mon,  8 Jun 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929796;
	bh=4dzy65cV98nV8e9IEBBFsdPikjXLTPrbT+oXCXkGHLY=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=W4i6QXqcwQEexyBYFUFdL6Asf/5FsbSgO4HD3O1NcnjlTFB8ltWEMXRy6gpwM2haV
	 tDVv9CAZEgB4ypNEZHpHqsNeqGHVtcW0jE/AVTm7BNXkwysvMRNfA/GkUFcwClDeR/
	 SGgE4/lD7unGzEF7SsaW8Giyg2uCL1EIXWtLQrAKgotIPdNQoF1RAHQ42xRBOR3xAR
	 vH1FjWjdogzYYOc94ME4PkgYHRB1Wta6/29OUlRpmEBBXdXC/3w20sJTDixZVyoomy
	 0IJBHsL7TWxDsR1p/MKKrYTuEjfgLM+so9NY0I0AVXIc9IgzeGEc8kYXcWhIrUU7Ts
	 f0x76aq/fLOww==
Message-ID: <0aa2ec2f-af87-49d8-b1a5-051720e06438@kernel.org>
Date: Mon, 8 Jun 2026 22:43:12 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v6 04/11] fstests: add _require_unique_f_fsid() helper
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1779939330.git.asj@kernel.org>
 <983ed0f63318c930379ee74220f23aa558c16d51.1779939330.git.asj@kernel.org>
 <20260529043056.GE6070@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260529043056.GE6070@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/5/26 12:30, Darrick J. Wong wrote:
> On Thu, May 28, 2026 at 12:05:35PM +0800, Anand Jain wrote:
>> Add a helper to check if the target filesystem supports unique f_fsid
>> tracking across cloned or snapshot instances.
>>
>> Certain filesystems like XFS, Btrfs, and F2FS ensure unique f_fsid
>> identifiers per filesystem instance. However, Ext4 derives its f_fsid
>> directly from its superblock UUID, which leads to identical f_fsid
>> values on cloned images until the UUID is manually modified by userspace.
>>
>> Introduce _require_unique_f_fsid() to allow test cases requiring strict
>> f_fsid uniqueness to skip gracefully on unsupported filesystems.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 937f478963b4..5446552aed92 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -6314,6 +6314,27 @@ _require_fanotify_ioerrors()
>>  	_notrun "$FSTYP does not support fanotify ioerrors"
>>  }
>>  
>> +# Ext4 derives f_fsid from the superblock UUID, meaning clones share the
>> +# same f_fsid until their UUIDs diverge. Conversely, XFS, Btrfs,
>> +# and F2FS ensure f_fsid remains unique per filesystem instance (often by
>> +# deriving it from the UUID and underlying block device.)
>> +#
>> +# Across all filesystems, a UUID collision causes libblkid tools to return
>> +# non-deterministic device mappings. It is ultimately the responsibility
> 
> "device mappings", as in /dev/disk/by-id/$UUID ?
> 

Correct.. I'll make it specific.

>> +# of the userspace utility or use-case to enforce uniqueness when a clone
>> +# diverges. For details, see mailing list thread discussions titled:
>> +#      "ext4: derive f_fsid from block device to avoid collisions".
> 
> How about providing a direct lore link?
> 

Sure, that will be..

Link:
https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/

instead of the title.

Thanks, Anand


> --D
> 




>> +_require_unique_f_fsid()
>> +{
>> +	# Skip the test if the filesystem does not enforce unique f_fsids
>> +	# natively. Checking this dynamically requires recreating a clone
>> +	# layout, so we use a static lookup based on FSTYP.
>> +	if [ "$FSTYP" == "ext4" ]; then
>> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
>> +	fi
>> +}
>> +
>> +
>>  # Computes a percentage of the available space in a filesystem and
>>  # returns that quantity in MB. The percentage must not contain a percent
>>  # sign ("%").
>> -- 
>> 2.43.0
>>
>>

