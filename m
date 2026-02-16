Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A367726D4F7
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260266; cv=none; b=Djncasifd4YhdbD0YZHG5ReBmSk8Z05tTThjUnNHmEXLpjJuEg9JZ+/L+TD3C9gc9V5cgOl1ikJJRjnWMf2A8ISEUrGabgjjfhBB1c1aGRBc+chtbkCoSVYqDmHLqzAm3g4Relr2PgBvUMmbcWVpK9fWQBWvrnHczE+DsObGFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260266; c=relaxed/simple;
	bh=01BUm6vupQUJj+W8CM5eFv2R/nCyeeP+YWbA+GAMWpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPhkLlVWueAZ2S+EhnkXaE7U8jTd/Fm8U8R9wvpAa5He22pZqZOmza6qourZ/DtBPXL1Df4XyNA8c4bExVaHJgLvmnd1r4/i/ZlZZ9UVPi/RVUaZshcS0v0cYeBbIJ+QAO28GAzKMOqN+DP90E67lsDYsMpBoG4nPUywUu8PKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bacljIRe; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bacljIRe"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a7d98c1879so17590145ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 08:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260265; x=1771865065; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=spNlGFpNi5MWe107Led6DbIFlVpyBUXIz5HBdej5nNk=;
        b=bacljIRecP2GDs3NGgBbAV29rAb9fVK1Lsw+Hl3OYO/myP+XFRp10LzbDy6E7R1eVa
         GO7iOiGm7OZAJ/uNBecl/0AvV23o7P47KE/W79BjwD95x/9XN+/pg103OrPrezI9+KKE
         tNatF9OQMrEqadqCnx2q4I8+ACRiHZMJUclzeqZHZRUhPxE6vBArOnIQ7mVXR/DE1yUI
         59Wr79U+2GiSQRikSeFE2cnLPPFXN7hvhGdQwb2XQYBVTCTVXU8fJPbFMpoUsx3T4qeY
         6VrUGnd1JSKNmtQQTfZwqzCXbpNTRSDtUphIC5/xT230EH1zCJuko8r8KqJv6cGk6K9V
         GZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260265; x=1771865065;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spNlGFpNi5MWe107Led6DbIFlVpyBUXIz5HBdej5nNk=;
        b=GlNyGSNTeDSYMPDiJu8edTAXQAKIraid/+ky7+5GBDTBNqLjRF5JwubFKH98PEslxj
         l/oLXf48tgMNE4dfOxDxs7sFIUhS5HF55BJzs6t9ftVRP7dEX4PkowZmNHfBJ6oZN1Pk
         Ko36hVcd+D91PvrHMwzgQeYLApFUjkn9a7L4A3zmer/cTJIYU4zG+LwoyrQcDCY+g5To
         C6kZ7Cv1ZCwDF2yqbEwiFo5cJBO+mn4aUDcBHwtPym0R8rKNU8n346ZWiuhkIL46EyoZ
         mIao/+DzQcIjg0c0UT5GRMLXMxjA6HRtX9AH7+Qo/9UFBnNzpK46xb0lf5zLapONnsPP
         6dsw==
X-Gm-Message-State: AOJu0YyGV3b1uQY+9j492mTm8IrB+d6aISlBJIqWukvYVtThFTYoe4DJ
	dqPqJ2w+THzQ849/teAf50ab//JRNg4BbQbs1InmaeskO6pozXYHcpub
X-Gm-Gg: AZuq6aIX1GCjStzMznU6LYJiPYtyDnfmVO6nCoOi0aBNnGU4YXU/9oglrFUana6IGFH
	W/xDRRvKeXKfiHv+unTiovMgFbDsft6uvLgcwg6RJ+vkZTQ97gSxsArex7xWfnEASX9gpBk8Wiv
	bFBspd1RrGRV0SMxnvjLGBNSweMvpahYBQbbNH7W/FyBVTGDusVxwD1/InElyIzvwfKc6vaLfNM
	C5PSJA3FHQDggDPa7H0MPLGXHM8FvCHJJlY52GBJEiu+F2QYh5q4ie7MTvWwBY4MbJATcDuuRu9
	IymXKqibXUSaRLRN8ZRwpIuj9FvvhU+Sfyj3/ps+JtskQLuhtaM8FgdBQvNq6NH5rbgCoCjKLX2
	QITPndyo06J5mWfrX/hF/vJbJm447O4wpoTzYtEmlIt6Df0vP7GVrbJO3cqEQsIt+gwwg80OvEn
	f/D4xOuSLBFGKX4jsgLucbUIRJRapIVy6P42Lbgw==
X-Received: by 2002:a17:902:e74d:b0:2a8:7814:47cc with SMTP id d9443c01a7336-2ab50557773mr105409735ad.16.1771260264932;
        Mon, 16 Feb 2026 08:44:24 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6fa33esm78139495ad.13.2026.02.16.08.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 08:44:24 -0800 (PST)
Message-ID: <987df03d-fc31-42ef-a81e-da3caaa63cf1@gmail.com>
Date: Mon, 16 Feb 2026 22:14:20 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] Misc refactorings in XFS
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org, hch@infradead.org,
 nirjhar@linux.ibm.com
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
 <177126014661.263147.1931052626585278722.b4-ty@kernel.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <177126014661.263147.1931052626585278722.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/16/26 22:12, Carlos Maiolino wrote:
> On Wed, 11 Feb 2026 19:25:12 +0530, nirjhar@linux.ibm.com wrote:
>> This patchset contains 2 refactorings. Details are in the patches.
>> Please note that Darrick's RB in patch 1 was given in [1]. There is a
>> thread in lore where this series was partially sent[2] - please ignore
>> that.
>>
>> [v1] -> v2
>> 1. Added RB from Christoph.
>> 2. Fixed some styling/formatting issues in patch 1 and commit message of
>>     patch 2.
>>
>> [...]
> Applied to for-next, thanks!
>
> [1/2] xfs: Refactoring the nagcount and delta calculation
>        commit: c656834e964d0ec4e6599baa448510330c62e01e
> [2/2] xfs: Replace &rtg->rtg_group with rtg_group()
>        commit: f0d0d93e22e52a56121a3d7875ea7b577a217d62

Thank you.

--NR

>
> Best regards,

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

