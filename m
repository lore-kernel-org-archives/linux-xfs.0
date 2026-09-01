Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8176247D95E;
	Tue,  1 Sep 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788305550; cv=none; b=ddH1l6WJkMB86ZLEqnGCcmLq19RRvjc9mU8aQTCUCX6xTmxtRwztzID41v+XtUqd0g7Y7LzXI5y/0jUOM5iLXeWGKFFypwha0YCKrjDBwz5vD61bldWfDIT7jYHF3W83OVmw0pogsmBgYMdrwuwAK1tqvh4v0ZIdPwi5SMRf6ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788305550; c=relaxed/simple;
	bh=LjmVvqDf6srXlfpo5QzsQs336GnWASUPZVD6tiEk+Io=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=JyiM/NwQhj7f4uLJpPIyzkhy+Zmt3ZNEa/dH7mi5n2NJrbqup3OmThIFGXSdomkluqDo2uQVMvaWq4aK+QICe4O06PZlKdIc0pmmL/OvFrc8fIQtV6cWxkEuLnQr1cToD2KxVXysukxUWQ3045C02SsjVeVBXrMJFTi/QCgo/BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXGk34vk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXGk34vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14F31F000E9;
	Tue,  1 Sep 2026 23:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305545;
	bh=03+cdQH6OSkJOrqr1DanmXDylDD6Vi1Wng3BzGHUVu4=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=FXGk34vkpiY0LoHcsYDs7HMl0oV93yvwYDiuF2nT/9etACREQSwVhUxOl0cN2bVMd
	 w1iXNl1Yv599cQuFeWjal/+9Bx6NMi8iv0tkQGVe5wVylk/nYVUtldcb0nZWdkE6xp
	 pLuEo/hN7UizSLQ7bX8hhTlZfBoTV7HvROpWOYPAoLGM5YCWYHIpseZYlS+MKLgaC7
	 BHa4bmYha8Esgvfs5PPyOkM/Q6pm4FmijTJomkuWjVH8s8lUPevKbEevHUbIffU3Aq
	 kPKpP9cG8sEQGyVBw78CwRGpDVAw6W0G95TNUzaHOsFM6VJqjrh0sAYYcKG2Ie0FeB
	 e4y8zATwuKRmQ==
Message-ID: <9832242f-cc39-46f7-847b-70871e52a373@kernel.org>
Date: Wed, 2 Sep 2026 07:32:21 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/13] fstests: add _require_unique_f_fsid() helper
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <878a21ea507cb955ed414072c82ab5e5493b8ae0.1784949155.git.asj@kernel.org>
 <apb19-FLJv9dRFDS@zlang-mailbox>
Content-Language: en-US
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apb19-FLJv9dRFDS@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/9/26 00:09, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:02PM +0800, Anand Jain wrote:
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
>>  common/rc | 27 +++++++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 21b516accdf7..f73251365a60 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -6356,6 +6356,33 @@ _require_fanotify_ioerrors()
>>  	_notrun "$FSTYP does not support fanotify ioerrors"
>>  }
>>  
>> +# Skip the test if the filesystem does not enforce unique f_fsids
>> +# natively. Checking this dynamically requires recreating a clone
>> +# layout, so we use a static lookup based on FSTYP.
>> +#
>> +# Across all filesystems, a UUID collision causes libblkid tools to return
>> +# non-deterministic device mappings. It is ultimately the responsibility
>> +# of the userspace utility or use-case to enforce uniqueness when a clone
>> +# diverges. For details, see mailing list thread discussions:
>> +#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
>> +_require_unique_f_fsid()
>> +{
>> +	case "$FSTYP" in
>> +	ext*)
>> +		# Ext4 derives f_fsid from the superblock UUID, meaning
>> +		# clones share the same f_fsid until their UUIDs
>> +		# diverge.
>> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
>> +		;;
>> +	*)
>> +		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
>> +		# unique per filesystem instance (often by deriving it
>> +		# from the UUID and underlying block device.)
>> +		;;
>> +	esac
> 

> I would prefer to let the experts of each filesystem confirm whether their
> fs guarantees a unique f_fsid.

Theoretically, whether f_fsid is unique per clone depends on
how it is derived. If it includes the device major:minor,
it provides a unique ID per clone.

Btrfs does it since commit
 c2a74ed0494c btrfs: derive f_fsid from on-disk fsid and dev_t

> How about switching this logic to an *allowlist*
> *(whitelist)* approach, where we _notrun by default and only allow filesystems
> that explicitly guarantee unique f_fsid support?
> 
>   case "$FSTYP" in
>   btrfs|xfs|f2fs)
>         ;;
>   *)
>         _notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
>         ;;
>   esac

So _notrun() unless confirmed to have unique f_fsid for the cloned
filesystem. Works for me.

Thanks, Anand

> Thanks,
> Zorro
> 
>> +}
>> +
>> +
>>  # Computes a percentage of the available space in a filesystem and
>>  # returns that quantity in MB. The percentage must not contain a percent
>>  # sign ("%").
>> -- 
>> 2.43.0
>>

