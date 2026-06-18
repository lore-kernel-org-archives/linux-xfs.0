Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29F286417;
	Thu, 18 Jun 2026 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792638; cv=none; b=a5lDPKg3Ia1oaSbXC7PRuXl/pYlIjQH6f2LXoPfjcyhwoE+o+WsyxPSRRkQxUCUuL4AEMDG/sKzhCho+7nMdg/g62NX+caOcDolHXain5CNim8ofIBvsujQV1wmyKnJE/MNkiFxrD0hgO0DP7afNNOnyD7dEmZ0A/wGolhZiNVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792638; c=relaxed/simple;
	bh=rKUr7r0TBIB2aJKjp9fzyC4h2HPvxK6GpjkpFSav4as=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tjrwkKwlI7ANBY+4CdC+6q2STM4umDFrbXj1/DL7A3gku6UEKMTfs0gRRsjd6xeHX7I+e6tz+BwZynICEU2WuquuwWvwTOsC/z7MGZJRNfgYBEShg2ZwVzxCtWneK5nw6z/GOuj48d6qITHYS7R/CDeUFTk0YXPRa/cwUvReLV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=eZGND/Xi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UnzgWEAc; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="eZGND/Xi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UnzgWEAc"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 6350AEC026A;
	Thu, 18 Jun 2026 10:23:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 18 Jun 2026 10:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1781792635;
	 x=1781879035; bh=MfU79gB2jY7GUP3YvDiOu94taTP682gF79pMq2QCGYc=; b=
	eZGND/XiejWaS7zm8yEg7uu33p2mkCF9KugWiknTELiaF3NVkce+yKqtynHJQ6Hg
	4N9yfgzi8voB45iIIPOQqcfx8JXz2IXXGOcxYEnhC+eYC+gc6Dn2apCskzW9cG8o
	tsbCObQXMBhT/DunLFD1MXQ3gFrk10jCrJ5XnxKT9IyEh1104Am+jnk2e2RD7z6h
	5lruRCvDFQ+kT2oGptuKUens/IxI+cmbUOlitAavzalR8xs5i7WwcfuroqpwXEGX
	T5vcppBVvTORFjhCmj2/XMhCBaxrwEbuRc7SQ5Ecwbka0l2VPxHSAfB11vBu8/lJ
	4wgl+lIzOfrr7mX88Qojjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781792635; x=
	1781879035; bh=MfU79gB2jY7GUP3YvDiOu94taTP682gF79pMq2QCGYc=; b=U
	nzgWEAc7vANRYJ0glNUDw6Y2gks1qPEl1HhZopaSsKrNzvPvbWOsbZU1AO/va6+P
	JmPDSfFZdIGYPZtm7ddfvVd7lTfwORB8BHj5aiDAGn/ZSjwShQsYvTCTe4oRGrzl
	iIE3d74RtNV+vaInZihC6E7Cr/qPk4di4zuaX6q5P+3JoPguZGoiP8CD5vGTzKOB
	uGcUf9Il8ZIWQZLSEc4iyG26Q4DqSvP8hh3nLdt0yRk5PSOqpTogk3aw5EM/+1Xo
	WgL8Gck3Aq+KdpdfeUgnvvQNzzRoB3J9XaSoXpg87bUBpMeVc65oH9utnXrSXxs9
	/PcxNcMO3+HilsQI602+w==
X-ME-Sender: <xms:e_8zaorfnSpu9YpPm7s0HCg0fH584qnaT_SkdBaTIARn8M0cgBBNEA>
    <xme:e_8zavWX9UmhCthKrP8qJqDRv0rna4uS1N6nJqIk1OIuAwXEM7Z0kzefb_1QAyzxI
    N065qZiGpW-QFqu_nNlDOGNzIhNRt934UEPBKPE3W9T5BjKQ291x3M>
X-ME-Received: <xmr:e_8zaralqPcMUYawenxn8l1Pfcg27gzHLT5L7iDuXUUWqZEc-UG-TTAzLSHFwiscLHl7UGAfiE_K6vcIxq4WN5URFO9FpA>
X-ME-Proxy-Cause: dmFkZTFwKXOv5Jhf36HwedmcfcXPkzbjFO2sYa827fHn4elTj9o2QupGAJ07mM3kdU2bCf
    CmF/PmP73Ssny+Ynh2BuixWxPkCzNOvvjbzWk1W/HmtNuqPnxa2K9Kh6Gn6o4E7EVbaNcd
    V7+c9cacPkUdmuxi7pQBIiRasiGy+L0j0miBmvqqeBdkn0ebhn/hUavjnnpD8ZCopsJoLE
    Toio3RUtU6UTL4M6THDv111WwPgkR6lJ2q+bGLRrTMnipzf1pE1AgAfUpR4g1tt5SjIRvK
    gubh/e5B6RxMQzAyC9N5YzjOw7+CKd5dmWShbrUARktah96lpHWkQzv8UWuDwPYKydWRhG
    nHP+RnYmgtcqu5CW8TrOKIB5bqChgnWvCqOqa/Q+if6AzngfvL/6pwTYMK1bJ79qiWcrUO
    YPT3H+gWfS/Xx6cbEUhhT6bvaMAuRerscHdPC1Khiw+8xcr5yz/16KUPwjefVr58GVdCha
    8yyfti6qtD2jOtVKlgqotQHvCW0Frz+8j9PqTITA+r7edXgQ036RBfBaP13Mu4tNytxHxa
    G07CLUu90iGAEO7zeR/ivDcPpSYGX9QY9w9Y0wO7abzfhX49P6vu0Q5aZ1LIb9lZmmTGDn
    YpA/CbmWo3dl97y0TBqiWoBmvEqTKM6Ne0C+YF5X4/7Sgj9OiQA+O1ShKI5g
X-ME-Proxy: <xmx:e_8zakdyxeFBUYjfTtp2ekuMoCN6tDZynoZq5b22wjOcVoHFjvv8QQ>
    <xmx:e_8zat3NC-WcVMEwy4IM2Kb6ih5iEnm6DZ29PyVo84pM2rFGv_hxxw>
    <xmx:e_8zajIwIB3c6VyjbbJxKUkR1ulaUYvG4FtHP2O7M4Hx09GfjXGLXQ>
    <xmx:e_8zakEvpq_6485_QSnHLdjB1kP3txyMX0g0g8KrWp6coji_gywLuQ>
    <xmx:e_8zajHbQwFPNRp5stKO_PxYZ80eaUcERi9BjzzJ6Cj5RPQ_0fFsjpsD>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Jun 2026 10:23:54 -0400 (EDT)
Message-ID: <325bdef5-487e-49d7-90d4-3418e2ae7799@sandeen.net>
Date: Thu, 18 Jun 2026 09:23:52 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs/078: disable all concurrency scaling
From: Eric Sandeen <sandeen@sandeen.net>
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260618134834.237647-1-hch@lst.de>
 <20260618134834.237647-2-hch@lst.de>
 <997e50d2-83d8-4b41-9c2a-749e5c85bf4b@sandeen.net>
Content-Language: en-US
In-Reply-To: <997e50d2-83d8-4b41-9c2a-749e5c85bf4b@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/26 8:54 AM, Eric Sandeen wrote:
> On 6/18/26 8:48 AM, Christoph Hellwig wrote:
>> Disable concurrency scaling to avoid mismatching output on systems with
>> a large CPU count.
>>
>> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I think this papers over what I still feel is a problem in mkfs.xfs
> behavior, but that's a different issue and making tests pass is good, so:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Er, hang on - let me retract that. Lukas sent a series to address
this problem too, right, and one of the things he added in his series
is a helper to determine whether the concurrency options even exist,
so that this can continue to run on older xfsprogs, which seems like
a good idea, no?

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?h=for-next&id=7f162f5bcf50fc32c7e3b432e7ff189571a3151f

which added _scratch_mkfs_xfs_supports_concurrency()

>> ---
>>  tests/xfs/078 | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/tests/xfs/078 b/tests/xfs/078
>> index 6057aeea12ab..8ef52614b125 100755
>> --- a/tests/xfs/078
>> +++ b/tests/xfs/078
>> @@ -57,9 +57,11 @@ _grow_loop()
>>  	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
>>  	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
>>  
>> -	dparam=""
>> +	# Disable concurrency scaling to avoid output differences due to large
>> +	# CPU counts.
>> +	mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
>>  	if [ -n "$agsize" ]; then
>> -		dparam="-d agsize=$agsize"
>> +		mkfs_opts="$mkfs_opts -d agsize=$agsize"
>>  	fi
>>  
>>  	echo
>> @@ -67,7 +69,7 @@ _grow_loop()
>>  	echo
>>  
>>  	echo "*** mkfs loop file (size=$original)"
>> -	$MKFS_XFS_PROG -b size=$bsize $dparam $loop_dev | \
>> +	$MKFS_XFS_PROG -b size=$bsize $mkfs_opts $loop_dev | \
>>  		_filter_mkfs 2>/dev/null
>>  
>>  	echo "*** extend loop file"
> 
> 

