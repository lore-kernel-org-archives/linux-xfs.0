Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D13A5459;
	Sun, 20 Sep 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789918770; cv=none; b=RHZLE/0ikVDM3+96wE2YSlwS1UmvRcxv9S+pzxehxeNCa01ufCUaaLzr2hUhJ4tVZC5GeLjBlqmmu9WP6/kiNuDfOEx1S0QdkJGZIfu864TUkGnIEblNJ7k2/sr4th0FpyFhcAwWIIEBccGzwnB4LacQpaXXcOn9LEhqnIWJwHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789918770; c=relaxed/simple;
	bh=z3u5ojf2I9hetE4xVmohkB/AyPGmWsJAMrFfBJbfFd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b1dFCfd2YJ5CK2Bmmh8VU9LVNjGi6O5oSoSbboO3+vLZQd5nQgUA4Ur18D6VOfokqLluskpVmqFsxf4AVS7QruRriG9Ut9lpZpkJZe1RSDgp/amdVNfYAQ29BX8VTuFBgO3i+GuHtFzG07vHfugA7+C8fSY3Y2ua3FJ+6DbII7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYJ3ldXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYJ3ldXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEA91F000FF;
	Sun, 20 Sep 2026 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789918768;
	bh=cv3upVLlLJS+6kXvAxKeIkkhG/o5kn6HrkMar9tjczM=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=jYJ3ldXFu9CC6bfen7zLfFY7Aa5jpQes/sdMVcUZBLuoHmoynBUH0e1sdEZY0i0bQ
	 Zjf9ntu8pp5NVcV7DfWhYW8ZjDDe8/zFtECFjrBmKRnXb7yhGfLoiYj6nrCMpsGaCf
	 gaQ7LbgHCkd3KZgzOxhwXLPxAv4jNCI5aYPlySyv0DjSP7H0HMFhQzx3vkxSms9P6H
	 M/OwcBq8zEf7D/dlXacq/lG0IsDMb8oQgzhQEb1hfpep7HqrN3QzV/Vj42HjOI3aRk
	 eBOH/IMPoFdFSSQ81SKpzL7dftlSi2F94tET29QHVfteWqBUcBw4NHglEwwRZiaiIs
	 E7JuUf+DFeIdg==
Message-ID: <124a503d-14c4-48ea-af4c-692cb59fe3aa@kernel.org>
Date: Sun, 20 Sep 2026 23:39:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/13] fstests: add _change_metadata_uuid helper
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <8d69567fb5700c5a4075509bd7272d02ce9ba4f5.1784949155.git.asj@kernel.org>
 <apc6wRjPnQZNYfxV@zlang-mailbox>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apc6wRjPnQZNYfxV@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 04:53, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:09PM +0800, Anand Jain wrote:
>> _change_metadata_uuid changes the UUID of the golden filesystem before it
>> is cloned.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index f73251365a60..45cf9360ba73 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1533,6 +1533,29 @@ _scratch_resvblks()
>>  	esac
>>  }
>>  
>> +# Change the metadata UUID of the given device to a newly generated one.
>> +# Args:
>> +#   $1: Block device path to modify.
>> +_change_metadata_uuid()
>> +{
>> +	local temp_mnt=$TEST_DIR/${seq}_mnt
>> +	local dev=$1
>> +


>> +	case $FSTYP in
>> +	xfs)
>> +		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
>> +		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
>> +		;;
>> +	btrfs)
>> +		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
> 
> How about split this function to _require_metadata_uuid_tool and
> _chanage_metadata_uuid ?

Splitting out _require_metadata_uuid_tool() is more modular, but I'm not
sure it's needed until we have multiple callers. With only a single
caller, an extra helper feels unnecessary. Inlining it makes the flow
easier to read and execute. Similar to how we handle this in the kernel.

Thanks, Anand


> 
>> +		$BTRFS_TUNE_PROG -m $dev
>> +		;;
>> +	*)
>> +		_notrun "Require filesystem with metadata_uuid feature"
>> +		;;
>> +	esac
>> +}
>> +
>>  # Create a small loop image, run an optional tuning function ($2) on it,
>>  # clone it, and attach both to loop devices, returned in ($1).
>>  # Args:
>> -- 
>> 2.43.0
>>

