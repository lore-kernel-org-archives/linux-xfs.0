Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A212673AF
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 05:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761198038; cv=none; b=P4JTObGPoJ/Z/iuy/tUgKXIQvLMoDr56ksb3YbBYocCaK1jJ8gieFYnQCP0lIIlP9HHRJ/o+mTlY/sHhC0/CtxWI1cD+vDQahrI/mmjJjR/M8b6s2Pi8WJAX7txRy+i8gfYx9LeOaE/yFBZ5vtWXlNNnowmFLasX+3L3dTBsF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761198038; c=relaxed/simple;
	bh=vT0/AsjWUFMzr8q/1LLoOQyGcdBcHwNnGr9uaOuSSeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J6izrVkSnj4h1jxsSdyKInaxZmEGTf7DF9R8EK8gy9C71pznYsbl4ck5AOJkxe9oS8/pZBr1j0TdorM1XuPiLQ4blaVXVjhD2LId7wcw3PNL8dKIxxsTHNaaEhztc3Hz6BtQT6CZ1lAYMjE4TZtVnljdh733n8YE3/FNvj21Drc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hK90BWA5; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hK90BWA5"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-33db8fde85cso491543a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 22:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761198036; x=1761802836; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r9igCjTLUw+2haYSkeXhMBoCySdTUl1DQ0YZnCRQwTY=;
        b=hK90BWA5YXoFyvCr5EP86U2XHW7Im/UIChR0ZnAu7fddDGsXfxuo9oJOTfnY/SKLY4
         0Ka2qnpbOKMwSBoiYO2raksRjQgAypvVk2GTGBD05KqJrMa6YJevltjfySXeAyZxct4U
         mgATHggjqow5RRw7BM6G2JCCnef7fenPaydNu/O4H+rz4sd8X7wPShK8JsU9/DrOvmb+
         QQkziUmWjs3VUVnbXsdjKr5r0YzhfOMYsyrR/3Img2KMIlVZy6tyMg17OrqAiAQdSeuI
         b8NjCPlHJ9rwXHYFcbeQO0fINk242gbEjpEH4+5/sz8nVBcpt38TXlybc9G4G0J5mS1S
         0uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761198036; x=1761802836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9igCjTLUw+2haYSkeXhMBoCySdTUl1DQ0YZnCRQwTY=;
        b=ZbSpy9jehAjEztgbgX8uCYIvFc2rxLxtLCtXxGqEU1zLCQ5rvFb95M4BcCewKPl0xd
         XAWck6c4RPtJbh41GSGQAG2COc9jsAznOT1BDyOVj1D5emvg8SPjFQEYQOSePtk3L9H+
         n9C0ft5H/pVOwDZz4UqOBzacYXgw+GE5SRzqAm85VHyB9xPRSBhmnlbf1uHP9Osgk603
         L6Xx9aNsp7fvJ5kG1B9lXFGUPiVxsQQOpKP/4gplBlnNEhNR3qAz2VyE5tIsgP0nTE1/
         c2htMK9MiIqSWFkVPL0lUPN8BckjSHPZfRg0AAWAM0cx3efFoleKoBoq1UVWqqOrhka/
         XvMQ==
X-Gm-Message-State: AOJu0Yyl3a8kDk/XggwAVsXmIAm078aAZskz9zZWQB+lBiSf8zuUk8u4
	Y4mGxW5i2fevgcf2rZz5eArPijEFpe6p//O/UfN5Oe9bU/KyrwZkt6lC
X-Gm-Gg: ASbGncu0qSA4QuBzpxYBLLNNEb4H2Rn/Fr9bU1qJ/djKy1EpJQwcQphjWf3qJ2C6gWX
	zwCwj4t8XIgJRuIbGpQkEJyM8pdpF3BbFOpOJEhAhDsqhztylV/zSYhbOEeTf/k3AUGBnkdg3ZX
	4HvTGVHyWD3lUtwHr0fxVLu9Y3Qf0c3Qnj5XoO2HmsCLsw0DCk+ohBITpIn24KF+5mMYwKzMwjU
	US2G+GZcY3s6VnMHyzfzYld23+FDMCyBhCKDbbPhIN+2c43w02i6M/BJ/nT3QpImZDK2kU3yWX6
	x6vI0T1jsCwV/w+n91IlkK8OWDkW1rrzHgzH/WZlU9pyachuGc19ga6EkkJDRAr+OAp5JZbhCVt
	C2y7W75ICT3gyoE1DcPkpDvvfOWflfb23zx0254bygY3yentQAPr2zu1ArnVhGZDlK0X3wfEvTo
	gGHoT1/I8XpQ==
X-Google-Smtp-Source: AGHT+IGRJE5goJIMFnmFpSByex3hVr2emVC22az3TjXi0P55nhXQze4szi+pUGVBJUTILnokkJc0lw==
X-Received: by 2002:a17:90a:c2c3:b0:327:f216:4360 with SMTP id 98e67ed59e1d1-33bcf853706mr32032156a91.8.1761198036026;
        Wed, 22 Oct 2025 22:40:36 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fb016f83fsm1107812a91.12.2025.10.22.22.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 22:40:35 -0700 (PDT)
Message-ID: <c26f1525-7635-4f44-9f79-2608edb0b6fe@gmail.com>
Date: Thu, 23 Oct 2025 11:10:30 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
To: "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org> <20251022160532.GM3356773@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251022160532.GM3356773@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/22/25 21:35, Darrick J. Wong wrote:
> On Wed, Oct 22, 2025 at 12:17:27AM -0700, Christoph Hellwig wrote:
>> On Mon, Oct 20, 2025 at 09:13:41PM +0530, Nirjhar Roy (IBM) wrote:
>>> This work is based on a previous RFC[1] by Gao Xiang and various ideas
>>> proposed by Dave Chinner in the RFC[1].
>>>
>>> Currently the functionality of shrink is limited to shrinking the last
>>> AG partially but not beyond that. This patch extends the functionality
>>> to support shrinking beyond 1 AG. However the AGs that we will be remove
>>> have to empty in order to prevent any loss of data.
>>>
>>> The patch begins with the re-introduction of some of the data
>>> structures that were removed, some code refactoring and
>>> finally the patch that implements the multi AG shrink design.
>>> The final patch has all the details including the definition of the
>>> terminologies and the overall design.
>> I'm still missing what the overall plan is here.  For "normal" XFS
>> setups you'll always have inodes that we can't migrate.  Do you plan
>> to use this with inode32 only?
> ...or resurrect xfs_reno?
>
> Data/attr extent migration might not be too hard if we can repurpose
> xfs_zonegc for relocations.  I think moving inodes is going to be very
> very difficult because there's no way to atomically update all the
> parents.
>
> (Not to mention whatever happens when the inumber abruptly changes)
>
>>                                  Also it would be nice to extent this
>> to rtgroups, as we are guaranteed to not have non-migratable metadata
>> there and things will actually just work.
> Seconded.

Yes, I plan to extend this to rtgroups too in a separate series. For 
this patch series, I have targeted only the non realtime groups.

--NR

>
> --D

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

