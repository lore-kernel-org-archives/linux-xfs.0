Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3CE2F12AB
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468173; cv=none; b=Djjgt9Sf5RVs4MWiAkyKNCeuFZ6oWLUUN7egL9CnGVb4j01bPID+w3jkvSASiiVbBRyidkfEseb+ktGzlr7OD+vNpHx0lt+uono4s5NJDf24arIFK2Mm85wPI4WI0+EEOF6p9vOczpVwylrO6yFcJS0QkHwAKdjGHKlHKluq1O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468173; c=relaxed/simple;
	bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUf4udel5OrlGEjC5P7uZi7JZGGg8OY5LE65ZOEswEtDBrYVyhRpLx9QMTrzlclBIpsK54iqah76Tsa2AhkgFlui0c5vcejDR93/FixKAWsTpAxQw32GCk3PpJ8UPKjU3gVVX9eLkZAF5K4itYQOvTV7Uf1ek2Udr/aJpfwwqqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ung45Q84; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ung45Q84"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c2f52585fso3992468a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468169; x=1767072969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=Ung45Q84NKJpgXUpj6V9c/ed39FtjE6rEaUqQWkJJFS7fjSzXwil3mKYAY6k0P8R9Z
         ddtgTfoZNL09/7vdeIMFC9JYApmDKSVclj15wMPBUSYzvYzI2V1K6y3+4OrBFi1YYL2i
         Ygo61aSI7PTM3LrIlLqoQR3YIwD47T+aDfeoHcsd1atowsBYoyrx6dnbVIVfEB/MalJF
         2NuWCA0r1bN8toEVguQoOSvqibnOTY8FjNDSkJ/sdULSEVFDzpcjyqioyPm4wEmXqrj1
         ilE8f7MJVCDOQnn9/KIYfxwD2zQKhMHjA+B/jiX/srEFwN0w8KKug3A4yAIpvlDCg4c+
         GzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468169; x=1767072969;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=OqANQJk8qyhq/xxEmTi2OEVUTnLapP0SUEpjV5xyrbSusrtrIHPBXFNaBXEMZdI3r0
         B1iMSh9t8MXi/ZBFYASTz5sabQCFpcc9wWRMA9urM/vHIe5vS3t9/8mgn71n1zLC0M4s
         1UMVLbreWhBzIqMCsNrKMyVKKFXzM82ODtrJrvST9x/OAx2+iNSqMhcSIFl2Jd+jCevR
         WX9LiCTBRF8DFRDcOqwKyW7lQFkNCLayQop1cbGziRf9GYoLQbA/UgGo4D8fLO27hJ8P
         qv5wuNyzMKDfPez0LEMwlICW91YnjWdof7bMSBhu2LdAoOh4BsipFIsW20cCgkUYRYXE
         esfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfTMVoVVNqNq6iD8fR3/jzFAQa/n9LS1IWg2Ws+9QrBZGvavzbV498bslGovil+qThvAiL7Owp9Eg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwePM3cTAoRuXx4pVn1TuOMlrrcxSZlTkbpb2uB/TZWsg2RPQdU
	PiQHIMDlLeldKnijZw94CABmHkT2vyGfy3BTAMoDNHqsdsYMoLzZs9nk
X-Gm-Gg: AY/fxX6Tv+HhETpQxEOtXsKYqg7C/S8joGdVeLn5YrKU9jODOJI0x6hdQVUmPAissL0
	vbdydoQOZ+UlBI4GGHW2ZncZlQxxEztRCSmMU8lHxMyJYyH1tRLzs2BrGt7OuXB5MwhKKZnO0Uk
	6gSKFMmkM2ml5UCM/RkWS8Iwu0UtRHc5b0fa6FKjTxccrTFUhYMnKu4XYOzKAbIlW4FpwOklzyT
	qJpPRyC0F/jBi2+KkQJDLPft0uzej+RECur59LhXl+Wt224KuLslqYk77E2O3yNV6uM88QNUh4E
	sGmKur+i0BbaQ80NRa6Ojlu+ri37wI801Angy0qwPO4rp+jgjKG/1GqSRWgY7W9ap3RMdsmxF7G
	3J4VIZ0dQXw9IhyWZ7iE4lAYonRz29lIG5lJ3j4RiID1a1X54LVtYXarezGEJmXG8eHXgaov5MQ
	qkQruuJw1IkfYqfWj5KBflGiqy2KNuj/xqNzFK7blkzVqA261SljXrplNX62HUFeI2
X-Google-Smtp-Source: AGHT+IH379xsDZ0d7vjKdC6ERRiENfgRNsDKq+A1tK8cXdwsmB2ywvOol5d1N83fquxU7SkCjjJrLg==
X-Received: by 2002:a05:7022:3b8a:b0:11b:79f1:850 with SMTP id a92af1059eb24-121722b7f23mr14589383c88.14.1766468169469;
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254ce49sm52556580c88.15.2025.12.22.21.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Message-ID: <e2d34cef-c0f4-4f27-91a0-439f85ed26b5@gmail.com>
Date: Mon, 22 Dec 2025 21:36:08 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from
 inode_update_timestamps
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-6-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Change the inode_update_timestamps calling convention, so that instead
> of returning the updated flags that are only needed to calculate the
> I_DIRTY_* flags, return the I_DIRTY_* flags diretly in an argument, and
> reserve the return value to return an error code, which will be needed to
> support non-blocking timestamp updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


