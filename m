Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CD3CB8F4;
	Mon,  8 Jun 2026 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929676; cv=none; b=TPdlmdhb+TE7ZNHufXSxwLLOqtUC2s7Ki9URLrVDKoToo/ENcNhUXw9JZVpMvmUoMzk7AxkRmA6LWfBJQXnIMith+z52R7U06isRRCpoQ/21aBCij6IrDEoHwuOHlN7MDI6YDb2C8BVZkonoExxxlNX9dCHmLWnjLnCEgKMXBzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929676; c=relaxed/simple;
	bh=Ec0rZ8UrPZFQWM1HibIqRRp34MqeedlbJiUqxfufXY0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZUSonqli6dJ0Eqnabiv9u4FJWGYZZ/8NnsgndPwczuv37jJtMKcWnP+TO/ZRaoE4urn2p/bl0LrfMeQeTVmL+VFfMo+RPRsHETBpsPRdq/GZIN77wJmvbFaxroIIA7neoyHsYEFPCsanwXiYQKgmN8K3LjmWk2aDfMOcFHF7Z8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4mtJ1L3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4mtJ1L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCCD1F00898;
	Mon,  8 Jun 2026 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929675;
	bh=rnSeC72k3jfwAJFo9DXNXEkyjXtYEwqhDK65JbAiMEg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=A4mtJ1L37lSvxT4FuxMY+NOf+tpa23K7Wec+UwtgEdf+7emCOq7qYQhBNSYDjjE4t
	 tCv5nJ64IuZg71ns2H3kGLDtEo0+uWXQZ7wZ5fAY6DumHnA72XDAISYf8oww8xzWJw
	 n6tMBlwDb774v18NsHF+xyx1jRgVLbM3uYaNutx6wIgAIJYN1pcwSAmti5rum+ZsiN
	 i0ALTI/4Wjpbzcx/LEnIvEhoa2KE/kcXesYlvhVWWrBcQQcB21eA2RxQKIfiefgsin
	 cdTz2ifN2XjWZcZfv5lPPom9cdaRBPFhz9T6zGfDIsk+GX2fAKDIK4fKis2VXr9S5z
	 cuuZnQrqpvSCw==
Message-ID: <81df0458-5cd0-4d02-8382-36c583e5ca26@kernel.org>
Date: Mon, 8 Jun 2026 22:41:11 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v6 02/11] fstests: add _clone_mount_option() helper
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1779939330.git.asj@kernel.org>
 <4346c80089c61c8f0d62ea696f9d73f2a9669297.1779939330.git.asj@kernel.org>
 <20260529042834.GC6070@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260529042834.GC6070@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/5/26 12:28, Darrick J. Wong wrote:
> On Thu, May 28, 2026 at 12:05:33PM +0800, Anand Jain wrote:
>> Adds _clone_mount_option() helper function to handle filesystem-specific
>> requirements for mounting cloned devices. Abstract the need for -o nouuid
>> on XFS.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index d7e3e0bdfb1e..937f478963b4 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -414,6 +414,23 @@ _scratch_mount_options()
>>  					$SCRATCH_DEV $SCRATCH_MNT
>>  }
>>  
>> +# Return filesystem-specific mount options required for mounting clone/snapshot
>> +# devices.
>> +_clone_mount_option()
>> +{
>> +	local mount_opts=""
>> +
>> +	case "$FSTYP" in
>> +	xfs)
>> +		# Allow mounting a duplicate filesystem on the same host
>> +		mount_opts="-o nouuid"
>> +		;;
>> +	*)
>> +	esac
>> +
>> +	echo $mount_opts
> 
> I probably would've just echo'd straight from inside the case statement,

Nice. Let's see if there is v7, I will change this to as below.

> but this otherwise looks ok,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 



diff --git a/common/rc b/common/rc
index 79be51e4da31..18d4f73cead9 100644
--- a/common/rc
+++ b/common/rc
@@ -418,17 +418,13 @@ _scratch_mount_options()
  # devices.
  _clone_mount_option()
  {
-       local mount_opts=""
-
         case "$FSTYP" in
         xfs)
                 # Allow mounting a duplicate filesystem on the same host
-               mount_opts="-o nouuid"
+               echo "-o nouuid"
                 ;;
         *)
         esac
-
-       echo $mount_opts
  }

  _supports_filetype()





>> +}
>> +
>>  _supports_filetype()
>>  {
>>  	local dir=$1
>> -- 
>> 2.43.0
>>
>>

