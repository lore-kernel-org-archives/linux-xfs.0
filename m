Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D443D510;
	Tue, 21 Jul 2026 22:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673411; cv=none; b=EQLtIjYXiVro9gSrceHYaMvZdW/SEEOqckd4QksrF+403Ca7/G6ix35vsXeBGSrT2iIndtSJe2Zse9VBuApoTCfNvAhQH6SxR2vobl/t+FpZpW0TrYP3ibEqzzzAAnY46hFJymGRtWVf+sGjQ5+5RfeKbC2tBYanwB3RA7E6mNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673411; c=relaxed/simple;
	bh=1IyyHVwZBul8YG2zgc5z1ESPv3VduuWrIAqaDJ06QuU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZCzEMdArYReUopkKiXteu0EXDlKznUmEmmL7Zh2VpQBiIG/IzMJ47A13ge6hccYH8t1YHYu2GCWB5Zg1wZDv7GYkoPj2YsvWZMzuzypP9eVkMS3kBuYJregcPQpfh+zwIy/T3EGwIA8kgVLw4g/+4qf7c3Vwg+MyU/YLuwWtiUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlMjBZdd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlMjBZdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368901F00A3D;
	Tue, 21 Jul 2026 22:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673409;
	bh=NlNXfl9pPHGUuipgj86pe3+c/OOyL/s0HmQJZn9uCa8=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=HlMjBZdd0CFMwr3Juf0LblZKfANuFFKKmyJSbr99NSr1UKj7Dm1WBsfTava8rJo1B
	 s30G4phlGrnbyD1USMggWxtinuCqZEmD7S13kTHqhT4M9JJBSZzmwqudWR74ZAUzzy
	 NoX8NIVWzxorgtjuygClmL5lv5OzPDikN66Fucg6v+b7uSx8ToREc33AKjZwoKRZ3I
	 /D1ORajl00iGPQHsgoMPjmJQP4P1646KgOFB3VfgFO1Ik995F6S1pCzqh3hmk3ERZ2
	 NFzaR8/4RKESlpKJauAzuxXgmo2a3+UEQW5cYDd0JXdusP6PfDx27Kdu+AUpEIsyUB
	 r9SBXlKAzMo2g==
Message-ID: <1fb99189-bd69-4618-bd20-f64205159b1b@kernel.org>
Date: Wed, 22 Jul 2026 06:36:47 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v7 05/11] fstests: verify fanotify isolation on cloned
 filesystems
To: "Darrick J. Wong" <djwong@kernel.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1781694879.git.asj@kernel.org>
 <65f6e4b778e85bd16f16e7745eb985e2a70f44f7.1781694879.git.asj@kernel.org>
 <20260701171259.GG6517@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260701171259.GG6517@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


>> +. ./common/preamble
>> +
>> +_begin_fstest auto quick mount clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_loop
>> +_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
>> +_require_unique_f_fsid
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
>> +	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
>> +
>> +	if [ "$semanage_added" = "yes" ]; then
>> +		semanage permissive -d unconfined_t >/dev/null 2>&1 || true
> 
> Needs to _require_command semanage, because it's not otherwise required
> by fstests.  Otherwise looks ok to me.
> 

Oh right. Added

In the new patch:
diff --git a/common/config b/common/config
::
+export SEMANAGE_PROG="$(type -P semanage)"


In this patch:
diff --git a/tests/generic/801 b/tests/generic/801
::
+_require_command "$SEMANAGE_PROG" semanage



