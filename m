Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BE62F5308
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103503; cv=none; b=Nj6/8TfVNOr2da5YTcdAED3otEwXGCpLRmWAt0Z20P8+G5dUVqaUN5ZJkPh4JDDLsjkOv3/75R+150tH27NcOilrMYaliIf2ZBuDOUi3Y2yW2ULSfTlo5vA13p6YYzAyEOQx+lw/WYzbFDk94kNNVhYa/PgjrtuLuwN3RHg61Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103503; c=relaxed/simple;
	bh=lBGN/E3o0ims3twKotLfitBVKmj0AuLfoiwiB7+J1p8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgGJYy+yPlc18xfTSWEZYYoH8gXzcZ562RXFs61mYgze9d5ydDkPK5+FTuuvhlr1A4JM0aGu2muC9nUQXuHT1T7dmmyboHitS2pDWta2DDF/FD6HomwDAXxjUTM7xizf1+OQSlG1t1P5q2jHqIKovmJ7MIahqqN19u6KNvVdnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9q3CW2H; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9q3CW2H"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c5e051a47ddso3180520a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 23:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770103502; x=1770708302; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IsmVdPX+KOxRuRNxeXQ+psXlNFJq+vNz0Df73CMU8rU=;
        b=I9q3CW2HZOveqYAC/d9adGPxcY6DTCN6g4xmjpUhgiLVXMqK1I3PPmeyRn4VxTn+n0
         1rEu5xwhzx55IdA6tdDS1oC+L5K8c1DmpWnLeNDjdT/XUx2GqkKkTAqWFsED9SlsNuY4
         fMJ2kusFiKxCkIp3T9QO+jX13kVU98SByL9zYze3PrTVCpJZ3QKHEjaEVg561h43w82E
         2v6bUU1bUUn0aYxGHengOd3Q9oNXFF2Cg/SupPpBBupmj9bMzB9inXlZB/rcMKu/lPNM
         ZGq8IRI/q3csNMBDRUWWRsrXeZAp/8s5IKV9CkrjpLQkDQ8pa5hBXT+9Oabn1tT23o1A
         T6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770103502; x=1770708302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsmVdPX+KOxRuRNxeXQ+psXlNFJq+vNz0Df73CMU8rU=;
        b=mRUE2Y577cG1K2KSg5nvGgxe1prTZbY1/PGZW9e3COim96TmNn0ooWfpGmB1uKhKWj
         OIXnJd8tcW9pHSV6aT9C/e1vhXlhOv8Zhrp3JFYC81UlBHNOPBPaOeto5BgRULvm7g+s
         sTqQOvvrpHBPaUgij9hzgzqMl/1NzbgvP+X0VSDrdUpc4Csk+f0m9Rsi5X8K/o2JY4I6
         4aP8Fv9SAfNPidgtcxmk3wj3iipuQ/nVhDeELGQX6mqke6y/BgJLZFL1PyE1KXHioAhv
         NsxOL/4b1k+odu7MUTyul5MMtQVc/ueSmsA1I9dh1NiZeqx+LFFUA8gF13xuq6Y7nJ1R
         UpJg==
X-Forwarded-Encrypted: i=1; AJvYcCW7PwdZsOUA/0x8pkl4cLb83b17aDEDeQ0tUTqxCCrX39sYxAEs3HLDEaP8IgQEoquP5CFIc8K7fr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUD+LXfzce6jSK5jHHxB1MCAIDtC9zwbsp1luzwRlLEBEXtk3U
	vEcKoBAHU0fl7HXTyuV2B8aW7cbRJOssYnzsZ/u0IJe+eX3L5PbSQHeA
X-Gm-Gg: AZuq6aKvq4Jb5NSJCixOzab24h946e8cIYfeolBaCCsmUA4smQrwyq35nvv087QFBm7
	Dw5GX5J/qwwnnqSgqvJzrc5gWKvwDv8o22y5ddNUJDQFPL3eLqmYFopgK/2cBPxqTnqtaILYcSB
	mglog4o1HBSlXLP5m9I6OKMa/srXZ7Cyqo6u0H8uJwA9LlWJwlTPHVQtFBzAfY36HaLg6J6kJGV
	cGw5jeKYnB3yODToIaFgAIPygfQ98ZuZBOpmop5uTu8gRLEiheKkDzxXApmgWO/JQbLX64w2X/4
	PoI+u9gVDendG4HBXJRr4VmXNyGl5ei+mHAZmhFAqnwo7Ia80QzoRdOALP1hLFaZhlXfnBlAnp8
	Lt/5E9rbqB67Hmjfdde64TphiHpoqd3B32wFRLiiCY0+2qag/jNbDy1V8TehhyaXhzxnn6shbKW
	CPiUy1HVTut/avRepWUSyijeyVOEnr1lFK
X-Received: by 2002:a17:902:d485:b0:2a5:99e9:569d with SMTP id d9443c01a7336-2a8d96a6db8mr150735375ad.18.1770103501815;
        Mon, 02 Feb 2026 23:25:01 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b417394sm161212325ad.42.2026.02.02.23.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 23:25:00 -0800 (PST)
Message-ID: <66aad774-2bfd-4a7c-8155-d11638643034@gmail.com>
Date: Tue, 3 Feb 2026 12:54:55 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org
References: <20260202141502.378973-1-hch@lst.de>
 <20260202141502.378973-3-hch@lst.de>
 <00fa6edc7f0c324ceb95f7181682d04ce3f53839.camel@gmail.com>
 <20260203071434.GA19039@lst.de>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260203071434.GA19039@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/3/26 12:44, Christoph Hellwig wrote:
> On Tue, Feb 03, 2026 at 12:41:23PM +0530, Nirjhar Roy (IBM) wrote:
>> On Mon, 2026-02-02 at 15:14 +0100, Christoph Hellwig wrote:
>>> The active inode (or active vnode until recently) stat can get much larger
>>> than expected on file systems with a lot of metafile inodes like zoned
>>> file systems on SMR hard disks with 10.000s of rtg rmap inodes.
>> And this was causing (or could have caused) some sort of counter overflows or something?
> Not really an overflow.  But if you have a lot of metadir inodes it
> messes up the stats with extra counts that are not user visible.
Okay.
>
>>> This fixes xfs/177 on SMR hard drives.
>> I can see that xfs/177 has a couple of sub-test cases (like Round 1,2, ...) - do you remember if 1
>> particular round was causing problems or were there issues with all/most of them?
> Comparing the cached values to the expected ones.
Noted.
>
>> So is it like then there is a state(or at some function) where
>> xs_inodes_active counter was bumped up even though "ip" was a metadir
>> inode and here in the above line it is corrected (i.e, decremented
>> by 1) and xs_inodes_meta is incremented - shouldn't the appropriate
>> counter have been directly bumped up whenever it was created?
> xfs_inode_alloc doesn't know if the inode is going to be a meta inode,
> as it hasn't been read from disk yet for the common case.  For the
> less common inode allocation case we'd know it, but passing it down
> would be a bit annoying.

Okay, now I get it. Thank you. So we increment the stats for regular 
inode (since this is more common) and later adjust if our assumption is 
wrong, i.e, the inode turns out to be a metadir inode. Right?

>
>>> +/* Metafile counters */
>>> +	uint32_t		xs_inodes_meta;
>> uint64_t would be an overkill, isn't it?
> Yes.  Sticking to the same type as the active inodes here.

Okay, makes sense.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

