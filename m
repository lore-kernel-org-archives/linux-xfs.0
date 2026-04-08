Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C9A18DB37
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775688698; cv=none; b=V0fQb7wiwEOxO6exEtg/Uvoq7OGpDCL92WEomiozijFhwbvuwgqaKmiawySpvXToiRhPw+2rzvowZFSXYOSxGGI015eJvUZtWerbKNOwqpXEZHPiZHH2jyQZiSQIAhr0b5kae3A0pLkzmXsB/AdDcQ2YUfUEhTvoRUG2As6EXA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775688698; c=relaxed/simple;
	bh=NP/NrnNRzZkpV1grdYgncLQy+kN+d6bh/MFF2s6ctT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oztnr5uAS3TfTHrAK4P4ZV2xXsAZhDtn87fH1pomsm5+ua1F7SU8vljkn1ned2+Std33ZY4nixzN41X2UuV8p9wu0vOpY7HoKfbpc3uSuz8MEWP9X2DzWd+PnVz7D+HATgu6pn/ltB6tIbC8qIEM7QzwjBTGk7Z93bDvMornsgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iYLVepDS; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iYLVepDS"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638MgQAK3195886
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 18:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0HMT
	yjU+3VWME3neIOtWAUbmcTCr0jHyC7V9xVqa7uE=; b=iYLVepDS0lKOjgw+ZsdC
	ZWja2OTdpkfhNueRHpTof39JrY0XGw5tnXPdf8MWu7FTxzuJk1ppxGkISTR1zMwH
	zjK++sUyrla/vSpzgaHI8mCeaf7oelKQ2DsSDzEpYDFy0sBiv7GyYPjIlQlQ0xNa
	f94iycbv0Iwc7JlBKB4Z69n3gBmRaEplbtA3GkFBc0/EF80LNlS2CFtrEjseHD/2
	L1ndgJl5EST0f9oHbXarVMmhw9ub+TTHdIN5V8O6mhR0lretkp9PlaKbCmGkgmbp
	NoWaIr3WXzAG3qKJ/Cb82OrDBLMMiaHr10ys2DtT9AZpBvFuhP8jVx8vV/B+0AyG
	5g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3n0keu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 18:51:35 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d890580e1so8720611cf.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 15:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775688695; x=1776293495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HMTyjU+3VWME3neIOtWAUbmcTCr0jHyC7V9xVqa7uE=;
        b=NxaYB3YvcTA8phjJtgzchRAKHZ0vqAlcUeDqXttB+3yu7wN6FgAMTacSc+yDfNQJqE
         att2A9XTDWe2Lj4Vqt7qXWZUveb/JenQ4mLwtUJ2dR8HsGatGIM1Afzl2p/M08S7yGsu
         qILDZo2oPo96mWoQbnXTkyfZEXh4XeXzZpiSnDw1uqR8GPR5Av66rhrPLzDAQACJfehv
         pUQ7EoCRfeuLrYJSRACONPKRpiAwbiqrlNHTjA+4NwmRX38Bkc7E7RNtNDJvlOuP0Jss
         dpteLm380nmyQKQmwC88s+adGdFUpEefFkcceFZ3QJCKUBKHe/Cf4RRU7U8RuRjxDt+p
         QJ3w==
X-Forwarded-Encrypted: i=1; AJvYcCW2aFcYKaEOj3G0v6Lw/IiClclsQGD6WGreLnIyOfHflpSe4dhqZv+100Xvf2RWZ2+O4FuQV1g5wi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YygoNh7Auv6fiEzp5zGfRRVc+GxmfTLw4IT58e44jAuaJMa0jdD
	1YuLedrqXONmcTLcCccfNGrGyHMMIA2NS42QgaW/yAX2XVtyfqNFkyx7gHzomNYLM8srfwAmsac
	Gom9a382yzv/2We9NrjRUqihFnbIF8ht2+/FxcN25aOKKNpFP+QYRdFBgGQ==
X-Gm-Gg: AeBDievcwg79wMr2iYBxlufsTFq2GG4ysChS2ppry9UghBcYE5IzMraRTjRp0KTFDXK
	fjfiHQQqvc45MK1x7+81SPAooIDEx3ymUsO5ni9bo5fj9RcoRFiyRfqv5uiVrW2w+rdJFkOYmaN
	Rg5WwKI5bPEt/0fxZPccyCeEINTAOUACalrdc+6G1c/WUD/yvHPoRtEq7u7IIa6ehxBAXiyIugL
	b9Ej4KosK9xEygLP/JunIRftIvGZeQ5hterWve3I2dR8+TZx/7vAcmQhAnxE9YfqX8xKhr882Ts
	gGg4fudLyUlDE32S42QnoiIQODngfDNSb4Tn6BVUOa+NvkkWh5A8senelMVG0j1u9A9Z3KbqSq/
	Z4n9At1TBdCpC2tpM24KksKcB5XgZBDJ80XEZ5Gym
X-Received: by 2002:a05:622a:51:b0:50d:9e36:f95e with SMTP id d75a77b69052e-50d9e370192mr170670251cf.39.1775688695360;
        Wed, 08 Apr 2026 15:51:35 -0700 (PDT)
X-Received: by 2002:a05:622a:51:b0:50d:9e36:f95e with SMTP id d75a77b69052e-50d9e370192mr170669871cf.39.1775688694967;
        Wed, 08 Apr 2026 15:51:34 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d521952c4sm164382331cf.4.2026.04.08.15.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 15:51:34 -0700 (PDT)
Message-ID: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
Date: Wed, 8 Apr 2026 18:51:33 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
 <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
 <699933c1-c150-4e10-a5fc-6f128260d0c1@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <699933c1-c150-4e10-a5fc-6f128260d0c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=RMCD2Yi+ c=1 sm=1 tr=0 ts=69d6dbf7 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=lI5dGhs4q9fbHD95aMQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: kX2_UiHcIvPNkcDQp8sB1yJLvVUIc_U6
X-Proofpoint-GUID: kX2_UiHcIvPNkcDQp8sB1yJLvVUIc_U6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxMSBTYWx0ZWRfX0REFscxZzZfQ
 tyu1mqZuKIDfWx0fr5fg19JNrAYSw7tUssh8diDfR/jwTvPfA1V7PHlxR6HpF02cQJmVAKF3rao
 VZObZfKIXdz7awDfoPj4Z8S5g3BEnCYJSobkw55Vrie127UTB91rC/Po4ZISOJQpx1b1uwCok0x
 4hwBhvX7O3r8gtYyD4h2uMGP8KYeKkSwpITxwb0rBUuktFk1VoTd/A7lR3BuiWiRMC4I8yZNd2j
 DUrfq44QYBFmAmxGHR/1ysGfQus1pqvdnB1v7hqV4SIjJ7QFaIUUVT10h/B8ZpYkzJOLp/9khLi
 fGc4EO2WOQEzKKSQEzgA1SM6DmIGMLMLKKA2XdsDmWbOVNxodmhDUlu/cuouMIlQ93Z/H6+YxDX
 BZ6+6qvLKuqdAYN4SLMcrPS/FebepQbzBITkAUuWqurBp8hr87CC3KTVkoYRJzWx9j5C0l1pLhO
 jlnlkKR0HosUJA3tAQg==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 phishscore=0 impostorscore=10
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=10 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080211



On 4/8/26 3:51 PM, Jens Axboe wrote:
> On 4/8/26 12: 48 PM, Tal Zussman wrote: > On 3/25/26 4: 14 PM, Jens Axboe wrote: 
>> 
>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>> this as it seems like it'll simplify this nicely. Looks like that'll
>> involve turning bio::bi_next into a union with a struct llist_node.
> 
> Since these lists can get long, I'd keep an eye on llist reversal
> overhead there...
> 

Going to send v5 shortly -- tested with and without the llist reversal and
it didn't seem to make much of a difference. This was on a single-disk VM
though, so any stress testing you could do would be very helpful.

Thanks,
Tal
