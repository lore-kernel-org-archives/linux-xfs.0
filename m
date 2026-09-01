Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ADC23D7FF;
	Tue,  1 Sep 2026 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270850; cv=none; b=pvVu+SkSLfy6b2qBtofABC+ZuhP3qOAsoWMjlLQg2vpQmEz5IdU5XmBmsXHYK1DSFwDfNClqoM63IrWMH3N/+UuVmIJr/r0omwXjp8xsfZscW+2psV+/kDfeqexVSwnRfmuk40uKpnsU9URYQb/QeR2dTEcFklVS9RJ32uAdTBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270850; c=relaxed/simple;
	bh=U5viYWjTrvcO3tOVzLbI9m/+Bo+T7fF1lJpJgvcRA+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=LBhSCg3FYYeHunuo4FE/6ZNDB58NhXKlAbMqBpr0sx7vWKqfn79CcBZjrHpXrC3FYu0KFXaemxloFS3reM9qA4AS5APGLr3RNTZzb9kWURaMonEY2kZMAImhglunyVytzI5YOA+GhjbM0xXXwz7KqnnUJ9AYwdiK21ps/lcmxW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSWYiDl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSWYiDl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE2C1F000E9;
	Tue,  1 Sep 2026 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788270849;
	bh=FSggidhwF8rabJWJx6KgPECdT7Asd7yKc81seawfoQI=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=dSWYiDl7IbPcUEvGBoMjKlvTjNsW36AK3bd+s7SD4w9X+eXU86uBR2/5xjBvkQGTv
	 wr1TxFSn3WL8+mO9kUYaC5Yaq2eqCVTm4TcHBNW4x0fKJiXKI0F58/gzO2FxJgBJPc
	 DbcaYU56S5l1I40Qskx0Aa0/gBOMqy4Xs3HjT94vDPmM0WceLX/PQdb5+N3iOvRVzj
	 3/kQb5guEuVsyE6aZhZjDJCY/xvdXluaOFwIyF5hXTg4QBIeab6ENaGUyaEVe5fBBf
	 xzVia6FiGjNyzQtPFkUzENxwnLEqAiH/Vs4FfaqbLzBDj2VkXyC/cUxPQ2Zi45rusL
	 wauXay7WULYOw==
Message-ID: <4226c2b6-d108-4666-9ac9-b52830b3fd50@kernel.org>
Date: Tue, 1 Sep 2026 21:54:05 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/13] fstests: add _clone_mount_option() helper
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <75ceae4b427ab53c921af395854794b78d7e07a9.1784949154.git.asj@kernel.org>
 <apbGwZODzZIvOyi0@zlang-mailbox>
Content-Language: en-US
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apbGwZODzZIvOyi0@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 20:39, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:38:59PM +0800, Anand Jain wrote:
>> Adds _clone_mount_option() helper function to handle filesystem-specific
>> requirements for mounting cloned devices. Abstract the need for -o nouuid
>> on XFS.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> ---
>>  common/rc | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index e8ff5be0c547..53e5d9d43af6 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -414,6 +414,19 @@ _scratch_mount_options()
>>  					$SCRATCH_DEV $SCRATCH_MNT
>>  }
>>  
>> +# Return filesystem-specific mount options required for mounting clone/snapshot
>> +# devices.
>> +_clone_mount_option()
> 
> Just a minor nitpick :) For consistency with other *_mount_options functions
> (in common/rc), I suggest using "options" instead of "option" -- _clone_mount_options
> 

I'm okay with that, though this rename will impact the rest of the patch
series too.

Thanks, Anand


>> +{
>> +	case "$FSTYP" in
>> +	xfs)
>> +		# Allow mounting a duplicate filesystem on the same host
>> +		echo "-o nouuid"
>> +		;;
>> +	*)
>> +	esac
>> +}
>> +
>>  _supports_filetype()
>>  {
>>  	local dir=$1
>> -- 
>> 2.43.0
>>

