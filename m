Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A2440C03;
	Sun, 20 Apr 2025 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745170980; cv=none; b=hvmz8Eku1z4pE5ZeaDjwePKjqVWwdfWv3FAt1mkMZWq+uYCWxjwSINd0Y4OlQh2YgbZqtrRvnPbWy3sCRQz1mmUWQRcXpXoNgTQGQKZJu4AEorU6jLCmqJOOJf7OymcBfMOQdT2a/im/LygCt5aDad3iwz21sYO72ZOdMx5rRQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745170980; c=relaxed/simple;
	bh=+igs/Q0i/60Mc0K8am01LuEwk+mgWMnGSBEf1Dbtm0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AcPQTkOhdJAlzf3JbctZk+tWD+ZFBqXjpCE/fTO91q4sMTtEL7NxqTDAw7XaUq357y7RVDIqDCUCUnzZvUGxHnzEDu5UrNOp8+ZMfESwO75gGlMDT0NkapWVj0dYZ2zGyfc323Ojc3VTPu90554MrGxqmpPaPVsGXwJaz8u3LwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SJ8LkUhy; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJ8LkUhy"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-73c17c770a7so4318006b3a.2;
        Sun, 20 Apr 2025 10:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745170978; x=1745775778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=EJLK4+os2n9Ce1TXsvYhjNreUao2C8NKHuRLJi9oOQE=;
        b=SJ8LkUhypcMJtIMcvpzcvmlXGUEgb2NlyU5m3MI2sl6Ct7sCl+/v0HSLBGjpVNfAcO
         zJh4i3spEUCe88OwRluAJSSNBlZ+2gj95ldCzZOybMDwqpzavP+KCTPZkoP6SuwMhtYU
         mGO8ge7Fe7j+TY0N2HzX9RhmkNDluwCins6seeqzHRYlGtsnFZOw4MDFxbY8PVAjQWwA
         63a9A/1kx2GD0dAJpeI3OHW7RRPlE/DToUjWsKnFU7+e1J6qhMV93Sh3ui5l5dNVbywJ
         2JFJwGq0oGCStGksIaMpaRw8a0liecGC/Blb+BK9knnx8CFHmqR7CYzBm0Fd6EXzimIH
         clrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745170978; x=1745775778;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJLK4+os2n9Ce1TXsvYhjNreUao2C8NKHuRLJi9oOQE=;
        b=KbIoUOxqIAxgbFCgqXZpgLE5D9Y4oRcye0p7Qz1qVmYNPaLclpTEpKEB/GR7s6dH5T
         TSknQFYZlik7/HBhmNDli1IcFCh+G7nbfjIiuu+VjVLuuF1kuwKnjv9mJ3BboBHzxW9V
         oMPtzkVmWeKme8r5fRcWSqP+nnX3ziQjWvQBDJz1GqZ8hny0Ifb/ZohGl58J5kHM7abb
         5tZZO6Qxl3fBCcBahIL/Hcvbe3OAHhh1SYH7uEcmB3l5lvzBS8pq1zC98rxj2acgSIK5
         U/b1qcObaQd1OVm/YRTK7qudpjjHUFDms7oZhcKGnKs3AmjRAtTZj0yNgFNntjicVJZ+
         Pa8w==
X-Forwarded-Encrypted: i=1; AJvYcCUEON2m4bi5eBFFo+7dSo2hTNm17Tmujl0EkWfFAPhnrzMx6kSXCAR6Idsm+kpIRCCdTxUGYN8hBGM7C2E=@vger.kernel.org, AJvYcCX2nbkVU33ksCZ970v6zglOSDwhn4ThZfWC7tv4aekDcOKfkrIv0SMdEGIdBe/X400OlmGnY8jsYDr7@vger.kernel.org
X-Gm-Message-State: AOJu0YxdNGPb0RTqB/LYc1zKHjV7Fvg/OvB4mqu2edPfvEkGJnswOjZN
	cG9Te0mWfYTpaS0ShfQdMmR/SvIOJRDK8OOvWEJrROeWvi9S0YBd
X-Gm-Gg: ASbGncuFrE3B3qec3jq81ByOFtmGQNkTB9xFRkCG8ocyS2IziB2frtJ2kj/nrW0apHF
	Yi7jJxq0FNyXGek0ztNzqfQQfd+NnrO8eM0v3+9rPHK7XWAQFy5lLYY0C+VYiPy6XTyC1/MPGLa
	7ehqgj2xuG7MhknL+P5NorB27h7Zmll9Bg04nR3SC5iXIDGLDlQA6qKUoGhy0YvHnNM4CSiOqmi
	ieRPbk/sXVwCjXDqoIkrmN+Ler57a2ryh2+n2GpggtuHOSd1yM9kdQbjsWFQUKZi0bDMciCjCv0
	6VuHFjR236SStuvofW2QUucRIGpbI7XUXZWKBFHZMNNozXyLFaL7ieYkHEbJuNJcSS1tTxER1X3
	QPbtWzQltwKYHTg==
X-Google-Smtp-Source: AGHT+IEm3r5970TN7mP99u55wLAP6j1CI2GxhSlzLZoAP6NfVT+sWvxG1nrNvg5GXbT4cXtOWP5Khw==
X-Received: by 2002:a05:6a21:1193:b0:1f5:8153:9407 with SMTP id adf61e73a8af0-203cbc746d2mr12814949637.20.1745170977872;
        Sun, 20 Apr 2025 10:42:57 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db12743afsm4340690a12.16.2025.04.20.10.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 10:42:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
Date: Sun, 20 Apr 2025 10:42:56 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Dave Chinner
 <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>,
 hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/25 03:53, Carlos Maiolino wrote:
> On Sun, Apr 20, 2025 at 02:47:02AM -0700, Guenter Roeck wrote:
>> On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
>>> Presently we start garbage collection late - when we start running
>>> out of free zones to backfill max_open_zones. This is a reasonable
>>> default as it minimizes write amplification. The longer we wait,
>>> the more blocks are invalidated and reclaim cost less in terms
>>> of blocks to relocate.
>>>
>>> Starting this late however introduces a risk of GC being outcompeted
>>> by user writes. If GC can't keep up, user writes will be forced to
>>> wait for free zones with high tail latencies as a result.
>>>
>>> This is not a problem under normal circumstances, but if fragmentation
>>> is bad and user write pressure is high (multiple full-throttle
>>> writers) we will "bottom out" of free zones.
>>>
>>> To mitigate this, introduce a zonegc_low_space tunable that lets the
>>> user specify a percentage of how much of the unused space that GC
>>> should keep available for writing. A high value will reclaim more of
>>> the space occupied by unused blocks, creating a larger buffer against
>>> write bursts.
>>>
>>> This comes at a cost as write amplification is increased. To
>>> illustrate this using a sample workload, setting zonegc_low_space to
>>> 60% avoids high (500ms) max latencies while increasing write
>>> amplification by 15%.
>>>
>> ...
>>>   bool
>>>   xfs_zoned_need_gc(
>>>   	struct xfs_mount	*mp)
>>>   {
>>> +	s64			available, free;
>>> +
>> ...
>>> +
>>> +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
>>> +	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
>>> +		return true;
>>> +
>>
>> With some 32-bit builds (parisc, openrisc so far):
>>
>> Error log:
>> ERROR: modpost: "__divdi3" [fs/xfs/xfs.ko] undefined!
>> ERROR: modpost: "__umoddi3" [fs/xfs/xfs.ko] undefined!
>> ERROR: modpost: "__moddi3" [fs/xfs/xfs.ko] undefined!
>> ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!
>>
> 
> I opened a discussion about this:
> 
> https://lore.kernel.org/lkml/20250419115157.567249-1-cem@kernel.org/

A possible local solution is below. Note the variable type change from s64 to u64.

Guenter
---

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 8c541ca71872..6dde2a680e75 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -170,7 +170,7 @@ bool
  xfs_zoned_need_gc(
         struct xfs_mount        *mp)
  {
-       s64                     available, free;
+       u64                     available, free, rem;

         if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
                 return false;
@@ -183,7 +183,12 @@ xfs_zoned_need_gc(
                 return true;

         free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
-       if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
+
+       rem = do_div(free, 100);
+       free = free * mp->m_zonegc_low_space +
+               div_u64(rem * mp->m_zonegc_low_space, 100);
+
+       if (available < free)
                 return true;

         return false;

