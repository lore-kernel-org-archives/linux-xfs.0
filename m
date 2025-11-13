Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C874B328604
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053782; cv=none; b=W/lxZa9ZJV6WX56ooIM3x41DUnemF4NEll3BJC2MCaMidh1ioaQhbszT6TVlg3/Hz0SH+hAcIyiYqUuRuU09CV6JrvVRf8SjdA2mbcbGlmbHAXu3K4KfzoMpqnmSGwbCn7Q+PSssxlBKcXBU57CFpH1SBCYWj18Wy51qL/y1Kxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053782; c=relaxed/simple;
	bh=zWvynoWdw7wHKkRFjD6Lw7oxikjttuJ++aEakU34N9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zfj1NW37UuODaPTwao5FVJyDUkSZQsyf9VqNcNKcgt+ABZyMHLWwvrHz0yg34ZsYJe5eDg2Sz7aT3x65P8r4oIrHpR+XFZ8Q4zVDt8+k0PZ5v7SfT5yIEZLypvCjwpfth2Co2xvDEIMc7IRk/K5chDhjWV0mf3r24lCU44ZUKZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ecY8Hi2v; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ecY8Hi2v"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4332381ba9bso11082235ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763053779; x=1763658579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ZBaFvCucR+JNZ72iqSisLCQ+iCppiPliY7657kFDp4=;
        b=ecY8Hi2vSgwEuTOeLxduHUGbbcHl9irSx6/HbCNAyOeopGNC59qFVza/jzmi3KtKRD
         yrFMgwt6CbNTtAOZelsNF5bAxJJKB21D6pamrHF3vjBCaoKu8E/jdCJcRpZ8Q9j95u4R
         LPtbmz5SjoPdxFAqDbNSv/fOH72CjtLCt5UD+H80TdpmKl4lTTK7Bx3vQNME7ftf6crZ
         XX7wg+in4gdNca6KyraP4O498ih0rI2qAPZg3N4VIt+w/mmnvbADApVgiZT78QuxgKaV
         LFvJKKsIyc34bd+aq71/DM2IrWqlHOSTkdIO61nKGekus8T5DUlxUa71OheAJhimTye2
         aZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763053779; x=1763658579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ZBaFvCucR+JNZ72iqSisLCQ+iCppiPliY7657kFDp4=;
        b=Ma9XNgI4c0DkdYXMUP1ceJicTi7sSba4PrZTmIKYzmfeujQMWseEgH5DCO8y7RvJXW
         T7JFOv6Htzmo5OIdbKPw+5BX7MqqQVKFw7/XT0drXg7Hu52IXeIOnEMjl1XdN97XthjG
         Z48KHAD0k17Wrxzm9Cp308XLlEMIT51Zqv/rCmHBlh4AVhz5gyv1B7XhSYepOTzpGVQb
         KBECWeT0Q+ZGzUD9vTp7Oba++j1cede4o+HQIF1r8PELzGysvgKvmmGVPxgy2NbSnAJy
         efAaW/bQEz1lyfIFlMZwe/c9WDQsf1yJVAuumlORWdAsUJWWbKo3yORjGand0sfqCEBJ
         AY0g==
X-Forwarded-Encrypted: i=1; AJvYcCXgh5n9ENeVQe144mp/x1J7jVz5CSq97CbxeQk7dGD6yYaqGbZ1aIABsyv8f6WLs80a9/MzekKiUII=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKP5swnZB2uym0cBgOlX3i1Mm6vBL0k487tbaDqM/1PBTViPFG
	6J3xtTuMAyv5uIdlVZswCPtq+6ScIRrxzr8eW+PkgP03B6jqC+5hZW4Vz1gS1FW00mU=
X-Gm-Gg: ASbGnctQeTZRahukn2Gv+F3EBVkuTccXVkDPZoMkTWzFkbsQJdHZVNViUqz6/uKwQLC
	sNrJPdFdp2CmA8+0BcYw7CY4erx8AmIOOjtyoKfFPUBqX+RuJsR0/QOURScoGPUH58bH5KHquIO
	MNORzMtMLCTdjoM5lWnY3R/AQvEeK7BxNrTDTvw0usAkzToInR2xpscXfwjvu6TDFxWlVSfJZ5X
	59OqrwOHvtCKpStysN/7e7TYyZi7Koic5ajS2vYxxWgGKNJWiD6f+Y+L3eRkwm9XfsBq64SUYSh
	lSLIzDoI0J9pgRbEORfwrpwvzYgjFpT9uEGa1Ethe4YHHudVcfMbd5EO8Zq/+M5ybdF+JrGe7ZS
	7sxA52ailEu5+WFNw8geYds57s4lgk5egE/XLxa4fLosVBKKeHecrMxy7nBrfes/SlZQfozWt
X-Google-Smtp-Source: AGHT+IHUj8FD9xehxpeszXbRgt8Dc9jtfpmge16x+sbjsSz4SJis1QNpqJZseiw30qoDqxfBrlrydw==
X-Received: by 2002:a05:6e02:1aa5:b0:433:28c7:6d7c with SMTP id e9e14a558f8ab-4348c8cfac3mr4356185ab.12.1763053778646;
        Thu, 13 Nov 2025 09:09:38 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd3113c3sm891476173.34.2025.11.13.09.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 09:09:38 -0800 (PST)
Message-ID: <87dfae96-6041-47e3-84ec-643e3aef3dc6@kernel.dk>
Date: Thu, 13 Nov 2025 10:09:37 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
 Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>
References: <20251113170633.1453259-1-hch@lst.de>
 <20251113170633.1453259-2-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251113170633.1453259-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/25 10:06 AM, Christoph Hellwig wrote:
> This was added by commit 099ada2c8726 ("io_uring/rw: add write support
> for IOCB_DIO_CALLER_COMP") and disabled a little later by commit
> 838b35bb6a89 ("io_uring/rw: disable IOCB_DIO_CALLER_COMP") because it
> didn't work.  Remove all the related code that sat unused for 2 years.

Fine with me! Still planning on resurrecting this in the future,
but just never got around to it so far.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

