Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E49322B6F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 20:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776198584; cv=none; b=ZgKB8aV7CkDajBsZS7LCZvoAjzmcXgySQisW1s8o+q+Y/peQ1CwYjyuznP/34BnzqItH3HJf+upiQSFixZTPtDgeO8gSQdzia4QA5Qh3AnMR4zD9bD+EjeFgwylVkUGG1OqzfRsPwspllSxouIo2crcOUAFTfy2AHFLj6jvxxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776198584; c=relaxed/simple;
	bh=yQFz8DM3su/UkwgPRuXCLRbPCiZ8ugq/3jme6jahFPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gd9B1Gm2yv2bX+mTAJHT7PqrbOX4QpvJTwqWw0EBVswCgZ4CGpMNrELfC6IM9lTGlUnbkAfMjL+j/P0KWP3xAcG4yyk1am4FV3LbwRktxPiTFbqDuUSEdmDdjMVtgAOVZqWCXfxJ9rwZCAut1PbtMy93HEJlYQYMVmFrCw5a574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=k22q0YhV; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="k22q0YhV"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EKR5hf1371596
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 16:29:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WXFq
	nVJ4T9hxAVeyiDV1ooSXjwN82kyD0WFAZyEIayY=; b=k22q0YhVQZiPT7EsK4qY
	kXKKf20d6Eyoq5zv/bCMosbe1p6ZTAAFqGYN1jql5TMO79N5C7HaZt6Z/cwriJjh
	i908rxBG1P3Tp2CF3EvYaZY5/Hh5bH5gz+cbWycowOy/ULW12oZEyg7fnlzlbtCW
	g1tmittXLgbbnNnyoVTcES5p2xk8gc68UqDO+MLS2VTyn0RAe4ulKHNSip2O7W0f
	wus22rwT2+tQnLCpj7WtrZzSZq7OwUEon5xcKGVHybeez2whx+pca7FQyi3SR4Su
	EhEEbwNysh4gXoSo/YVDtxTkm4zxUm6aRBUNyXOKjCaGjPahOa1IEuFxK2LP5O6s
	qg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dh87b84m3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 16:29:35 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cfc1634e43so696928085a.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 13:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776198574; x=1776803374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXFqnVJ4T9hxAVeyiDV1ooSXjwN82kyD0WFAZyEIayY=;
        b=BayClIK2V1tUQvS79awMmQylR3ZGkrErViYmA1ncpgkasme9SewTPLsYTu5Ss/HSUK
         58fjyN+YMzMCMgI0MVWB86S2oZuIY8h74d/U0PHY8HamXwXSEhe5wX6te/2/OXD5eF6/
         bnJ8aqbJIRM8+NO5aflMww22Tb9vdRWfyjxqP9nbIVn0RbYyMkFAh8Mij2VeiFeTDERO
         7JkHsU6V3wHv6aJDkPhJUDNITiwrc7uxxIMs4B0Hp/NmI+MLWDmzP1ijNrm21uzzkLrw
         ZWiiOc+mK+S5YnCX36jr02+aKb7vRuLfyxPeRTpTP6r9wrKxMlUwX6rPkaG7XyyfMpuy
         EZQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9VuxLfuAD3MAU5JLBl9oBblG5mL6QmKIFA0woeaT4j/hidhiDqoM1+7XvBo78ZcS9x66lwixFsVcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBwNtbSazBAN2tSK9LyzuJezJxvu9pHeXG6GKF4IRsyNyexonD
	HH+2BGxlw+rIH0zO4zJ699M5jutuJahBXQ+1rydEPmuH7hBHptns5b+4ONxGkY62WX+Y/RelVgf
	s3c0MHaaLpMbexb0qgCTQytJIBUE0zfJ55Ha4id05bThpuOIgLKrkqGwIhg==
X-Gm-Gg: AeBDietJi/VYDX/VTsUbaJCSimbS31y8rMCuj7wNGkjJPjDzLLHrViNbXma8cyS+HYb
	VyfTxOQ9/9TXr2DkoM800psLImjCyaN25A652VXHUf0NI9B5tnbRrYXBWmvhENkOBruQ6M3/iuo
	jXYPE+tmCC1RnwLxwsGdR3WnQhfjUFfV0vRiY9C1Sn9ApVUes6HZzjLhiveOK/yyasMZ2gHj8t+
	+6PBgHoQ9s/vkLxSVbyFKQNuiJDv0EoAJgH2JNk0gBOQNH5agMigtYKzl1qhSs8k+0sp7mRs+ch
	Rj129S0BJmKrxtTDhE9BkSqel3mRafClluM685i5ZPOLfV+bT8/OaaH7A94Hegjqs+in9YX3SDV
	f8hZl3gBkc41Cfa6dXzao3LGv1hzlJbvLmup0wXcqMPawVpXzCaAdZVShT8Z0v2TwKeHiZT0=
X-Received: by 2002:a05:620a:a281:10b0:8de:b9dd:8528 with SMTP id af79cd13be357-8deb9dd85ebmr1694559485a.24.1776198573930;
        Tue, 14 Apr 2026 13:29:33 -0700 (PDT)
X-Received: by 2002:a05:620a:a281:10b0:8de:b9dd:8528 with SMTP id af79cd13be357-8deb9dd85ebmr1694555685a.24.1776198573428;
        Tue, 14 Apr 2026 13:29:33 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db4e6sm131911086d6.4.2026.04.14.13.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 13:29:31 -0700 (PDT)
Message-ID: <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
Date: Tue, 14 Apr 2026 16:29:29 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
 <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: xkV-jYTvlEEjh673bjYLAVDX2tinXXqI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE5MCBTYWx0ZWRfX1cISAGNZ6PEw
 rKB2kylRi5Py/mF2+qq06moHJX8j3spG+tA+0iE8mOhL/oobaOc8hZqgz0BOgkRswum/Ge/tGZw
 EQRN81G12x9eF1V4156dEv6f5Bq9tJ5v0lDAkrwKkVDgZ3JCsIlAI6oM58cNjsClsAfxeWlWkrv
 3KWDE2ylSginAPckGRsHtRiTCKc5pPWJnm4mi2SrTS7t9Y9/ArMC2o/I/iE74y+r/KJ1yFmRR8i
 ZkryC3lOJcnjY7UgmkiQpDZhAcwIRHOfVNvQlM0Y6zS1nHBzBUDHKYG8YIBvBKlVty8BPcHzt1w
 YICvHjT7UHXx935Mo7I0sdymoQMqDDVz6jzcMsYvDRqVuDjqU5LZbaitkJOTZQtJF8tGBZdmKSO
 45Z1XuK7EMHTt2jGYS9fWoAxujpSG0DTkAkCO+e74A462LlLMqYmCRqSuahM20vm6XdGTlvP+fj
 av1/3biHcri1OWKQldw==
X-Authority-Analysis: v=2.4 cv=PanPQChd c=1 sm=1 tr=0 ts=69dea3af cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=g0XPL2zXmNQOemVH8wcA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: xkV-jYTvlEEjh673bjYLAVDX2tinXXqI
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11759
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 bulkscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140190



On 4/9/26 8:46 PM, Jens Axboe wrote:
> On 4/9/26 12:54 PM, Tal Zussman wrote:
>> On 4/8/26 7:36 PM, Jens Axboe wrote:
>>> On Apr 8, 2026, at 4:51PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>>>
>>>> Going to send v5 shortly -- tested with and without the llist reversal and
>>>> it didn't seem to make much of a difference. This was on a single-disk VM
>>>> though, so any stress testing you could do would be very helpful.
>>>>
>>>
>>> With all due respect, a single test like that isn?t going to be that useful. I'd be wary of making that change willy nilly and just thinking it's fine, worked fine on the one case I tested?.
>> 
>> Understood -- unfortunately that's what I have access to at the moment. I
>> can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
>> that before sending the next version, but that'll take a few days. You had
>> previously offered to test on your big box, so was hoping that was still on
>> the table :)
> 
> I can do that, but I'm OOO for the next week, so won't be until I'm
> back.
> 

No problem, thanks!

>> (Although Christoph seems to have proposed moving away from llist again)
> 
> I think that's a good idea, not a fan of using llist for this, in case
> that wasn't clear. These are per-cpu lists anyway, and having a constant
> overhead is better than needing to reverse an llist. IMHO.

Will change it back for the next version.

> -- 
> Jens Axboe
> 

