Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E66364931
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448595; cv=none; b=gQROhM8zIR9yRB8jf2LbOQeltmw7c850Wmace9cpBqh9fKWfbE9yBILOBu8syQtAbN9feWEjHa4FMUbG6K/9VxDC/Ak5Sbdzz0GDotkP1s1WOqsRDO0mMJ2QOjt72dAtodFglfr04iuMJj9bbWGGKyNGiIz1a+Bj0tRzyROvywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448595; c=relaxed/simple;
	bh=H+fC0Aj9lNIMry2g5OLsOVFCk0lkgCpK0rBGdHzX5BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4UNm7fXgSC/jkvyBQVZidQIFy+KRbINmr0rgeXV11Xi+t94hIeWEDW+zoCmfJr+lsvoKc8RZEnQWhwNmoeQNThwrH/dTDdXllib6JjwSG6UX0iAtdW8mRgkDBSRvIkZSDwidGr4oKapKk8OohKNxkQnBrT6WJjHxYejz287GTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=jGegmwhm; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="jGegmwhm"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B8tDuV1515508
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 07:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cKC6
	BNsxYTLmcXQYJdExb4GSON6ipxZyZfpmgIKUU2M=; b=jGegmwhmSmO99x95/UlC
	tB4qPrvgiat4PWc0bh/dTh+Cy51BZB8A8ODqRXDTgijDRrrin8ILnh8ZhYWuQ8xJ
	fGq1zXa2eGVmoWlNMUMHfkjiZ68Ny3UJPcHkNHnFOUXC1ZaqhiHpJ50LQ6rhV53J
	NX7GePWHgDd2LPB51ayPpBtFGpr3bsQUZxmwLMcS8jz5baNtUAphAIok7q/Ve/mG
	RK7gKBKk7u0pNfiFJ4Nt94u3hgZtH3Sng2tXDhDvxNw0eJnp1BVXU4lIQsYhjvsO
	LUe+Xgb7LGfrLeu/lBzY/PHL/7OdsxMUvVXD0OSc/bhOvJLbGr2flpXYd1nmqsHz
	LQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fyj6h4wv9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 07:43:06 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1b4d961dso8715511cf.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 04:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448585; x=1787053385;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cKC6BNsxYTLmcXQYJdExb4GSON6ipxZyZfpmgIKUU2M=;
        b=SoXni4CCR/LvaZELVa7uY+tH9Ywe6mc+qnoz0RMxg80g6FphYmWhkevEmymLiknXVM
         7qlukC2c2dyzwVG43Le8rJjOaHbGOQCRqv7XFJPYmTmh5Bftv0FOkkD6MZsytbIVhoOo
         OyhvQXm2G0ct/2f2t50GsHrfkezpNucCe3blS+oDQF55ayVWSXg7pARrMpkVuT9oiPnW
         k+zA4b3Ll2IuijPnbWS6O1NDyZb9RceYu0LMqwwLYbs81Ig5Fcnhh9WazSvZHQKAEDwl
         O7trx1wEd8b/NuIynLFu/ljDIM95t8PxLVA3ZIRou8X4BcY1NVYvSOZTZ6b9c3jVCaai
         e3SQ==
X-Forwarded-Encrypted: i=1; AHgh+RpxLYMPGeoCZF+X098yGDuJJbtV6zkCPv+smA6P1zVGOpr2MmaXUj8Sqnbo3pMqFaiePRuoCx7kx6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmtGRmwiL/FmQS8edSJF6cbaUasGficH40dBf8eDLgaEtC+lMG
	0iFkYjK7uUO3o5aOYqZekzjMfGHPAZC2x/F6s3wL38tAhtQwInfDrk2QZJNLfDS+bP3SsxXu/lP
	OUSFkmpmVVGJTY+jzHaQwWFpQ6usZV1epZmi/cBmIIC1SgpzTZpA110HINCMkj+yD6A==
X-Gm-Gg: AR+sD12tq05Vy0KHq+0gNFUJ8Ijg2ZqXD28O7DXQdAS8/EfHhEINFYh3Quz3pbOgNXd
	v0MHry9opprkfV+hEMrTQfTI4QmtnWPzEJgM8x1p4ID+00AJMAZ+5+GxWpEUBCJwAhYJUTuXBiR
	paO0n58s83Z3Yx6U6KqqHXd8XMM/LWW6Z8Jxwe6w08nXxAyBL22Ye+a13LNuPVeqbb1UNOw24bV
	g1hXU8stQ4AMJMQBpBcf1h8NcZrMS3KnkNcf+ayc3XZWJJ+p7sX3s9f6MHI8stNHQ1YaFeGjrxo
	sxlNCybIX8vS+sYSH7sG6qA2+mCZjySHqGQzXMXDXL6PIgIjmq4wStdiHWv3F1PWpo9YEuinIFe
	TygSX3yzNeUyJ3A==
X-Received: by 2002:a05:622a:1483:b0:51c:b91a:33f9 with SMTP id d75a77b69052e-52d595fd432mr15006141cf.13.1786448585503;
        Tue, 11 Aug 2026 04:43:05 -0700 (PDT)
X-Received: by 2002:a05:622a:1483:b0:51c:b91a:33f9 with SMTP id d75a77b69052e-52d595fd432mr15005621cf.13.1786448584908;
        Tue, 11 Aug 2026 04:43:04 -0700 (PDT)
Received: from [10.60.12.19] ([199.203.153.132])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5ac691sm4028393f8f.3.2026.08.11.04.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 04:43:04 -0700 (PDT)
Message-ID: <aff781b9-f782-46db-a34c-882b2562cf01@columbia.edu>
Date: Tue, 11 Aug 2026 14:43:01 +0300
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: avoid double deferrals for RWF_DONTCACHE writes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
 <20260810183341.GZ3556460@frogsfrogsfrogs>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260810183341.GZ3556460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA5NyBTYWx0ZWRfX3t3iRkDttlxP
 bGNXEICQ7bhMCgJgaglnlfkKYjgkssX5qSir3gx3D/w3JFMnS7y46lRldzfr9OYuu5s3zSIK2qD
 B3C9Z0hfXJM3Lj5uYkieCB5rCwoXQ5d1+b5ynRNxpyqjcLYvj5XN3/H1OI9S+v4QkUTDH8c3D4V
 S8e+2whfKiLboQIWnIYVhOLIG08jGBwt2Na3gzg1QFqgiEhgzkB+7VbB26uGkp2Mm3p/JFLrq8y
 F4+KIt6c9pNAcWWmSpF9cwfgTgZgzs5dZsEHcOpH4BzJZpdRTJfICrRczANcBE+dZd9rWBxEdy9
 Tohh6EmQer/g08eoiErlSwXMNChthfUXf4cFSPHWKRs7/LDurVkE0ijgd9h6oloiw4rl/FsYsVc
 EwhxFDz98W19mWFgBJalI+J7qk3e/di8w//Ok3ThfikWiiPYkgZP5cOTAiQ2Ny1n+izavAGqOGs
 LweqfvNxuZnQWXL0RZw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA5NyBTYWx0ZWRfX9Sip7MQTuwi9
 oOEi2kYHVv9JtV+EciYRAW+cI1h+WjN7DPsMW2bxssGwPuc8mYBhwdYsnsyNq6zaRWJ5NpNl320
 TyN0ywKbzAX3dVG4D3mi8BkkMXLBf9lEwpEfuKAUiED0X6jxQxWZ
X-Proofpoint-ORIG-GUID: 2Yg-lQuUgh96RndbwBO28Lsc3NYP1iKe
X-Authority-Analysis: v=2.4 cv=QY9WeMbv c=1 sm=1 tr=0 ts=6a7b0aca cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=Nuhq1gQggzmwqSkCDcb0/g==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=8C2fSIT-9AAHum8_5UgA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 2Yg-lQuUgh96RndbwBO28Lsc3NYP1iKe
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11871
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=10 priorityscore=1501 phishscore=0
 impostorscore=10 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110097

On 8/10/26 2:33 PM, Darrick J. Wong wrote:
> On Mon, Aug 10, 2026 at 12:39:19PM -0400, Tal Zussman wrote:
>> XFS already defers some writes to a workqueue when transactions are
>> needed to process the I/O completion. Disable the block layer bio task
>> completion in this case to avoid a major performance drop.
>> 
>> Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
> 
> What commit is this?
> 

It's the following commit in the block tree's for-7.3/block branch:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=for-7.3/block&id=efbde6f9f449da3306f5b5d32f08829954ffb44d

> (If we're fixing something that's not in Linus' tree then I think the
> fixes tags aren't required)
> 
