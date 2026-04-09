Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398C2E7162
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775761005; cv=none; b=Fy3DPHsXVK1MELvJSTPsAFR0LfdKBS7ck+xG2XDLYKO9DsxIi6n26hH8Q6mywqK/p3p40ty7xKmg+rqaFH3i70ZFbMs7jZxFi4V9kmALOxyKc7oIUafjMax2D+/oqS4SaEzHaiEX/k+Sn8bVQcqKsFRN6e4f6T90xJSVi1YDvMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775761005; c=relaxed/simple;
	bh=s8VtBesH9+RR7p0ccKkYYAEqr9HIwdQsu04bxw86QfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JzI7WWJ/I/3oXM8UYtrVsNzgai5XmM75Lg24kAtgwCDMLKPTw7BWh39U2WAxGTzz5qIUp+EZTplMyctjmgDAnc1kSMqcw+LGzLqixHyynS3ldqbpqwvOxcOZKJbRnzoMwlWmMAzS7gHI0h3BqcZwWHeyjn4NKRWBiC9jTQPiZm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=C9NNnw7O; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="C9NNnw7O"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639IuTD72863942
	for <linux-xfs@vger.kernel.org>; Thu, 9 Apr 2026 14:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TidF
	UCcjURxrvT0mTb47uTbc8cUi8gBa7hb58XJT0I4=; b=C9NNnw7OyyNZTpLLiAgn
	1NGy89rwkfGQ8sKW2xsoDs3psZY5O19VidoJhD6BzpRDMyGkFkwTD1iN5wFldI0Z
	7ScowFZ5piO/9JjmpEEBRSlyCxja1P6z9Qy4nAXRuYvh4jS/8CaFyBXH4UDz1vcV
	7Mnk+PrEoPbR8rZZa1xVayXOGGpi39gL3Zntbbd7wmhqBLqzhA7J4itQLNZcZAbZ
	u4loMcbeOLC2TsS69QUqj1tdG4Qa70Zomc4Rnp/kG03BRMGpYgzzi5nZddQOssOj
	zWdOwOHr0li87w5xr9EbzOtHvvqqhmw6SVfAYvLxmRU3ocoFoYt5y+iH6so2OZRL
	eg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4deea524xv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 14:56:36 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8d3bb33c8b8so236284485a.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 11:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760996; x=1776365796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TidFUCcjURxrvT0mTb47uTbc8cUi8gBa7hb58XJT0I4=;
        b=ZhbQ+W96+q+ZI+8K5k4Wyt9FTmPn0zRNFV/U/jKB36I1P4Rp1qMI3exan6y3nYG1MC
         Rgx65QU1toD+hf6DNd5llCU6hQU5qcW/nXvZBVbu1w5fRroOhHtN6vFJ9hTUtaEfCgUJ
         A3WsyhqAeD0CQ18WaFoN3PRbm8o1xsy7/HJqgrDtUmMhpBVUUZZcdo3eudD9DbIlYLJP
         mPA/afRYUVBtfr/VUwEro5ZxepWNwjZeZadZ3xiS1rMB1NfvwCaKFmwqnRb+Y0qifb7M
         0Kbp9eeTwAQsAappyIzmgspFoz2KQAxuaGwBcAS4MQERAnxlNPxdip3juXBCvODJBNO9
         DDRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMdH7ceDG0fpYScosVejteGBAsd7oDkla9DEdv6eprCCD2RjE6xoab0TwwzK9NLJE0kp3kdCEuW+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWf7GwhsfeYIT+kLEZ/fyNbjeKAAm0LRmPrZSo1BNmewsNBrrK
	27YctzWw0AuzUCxXxdMcsW9mcdEVdIs4P5GA/Q3ogzV3CIP1wy10QAGxDcWl0QRKEpMjOj6M0bK
	Yvx0i4pVOAoWnHdDIJ+Yv6M82u9MXQKXsDOHIK/xLVpeCmdGDO8ePT6BmjQ==
X-Gm-Gg: AeBDievC7u4Imzemfas+sLI8qAhebfDzKvdOGBMdhIbEegLtP3hNFQLj9ZAUUmMa/dp
	TGJCajhYA/uH/iMkU+vZAD7AsHUvaeWGcERX8nnL+XoHzJWabx2rTSt+orb3U0BP2CMInS0Mm1l
	0shzdyqM66JNlCdbzRjG9Hpvgt35Rg/uURfJ0DmnfYQoMjFdmn7Sjjq/TeGRyEuTETIAVvE+eO0
	Tjo8SPMm9gOLqbn28HCI2VCZVllgX0lflqjQBTb0a/C2CHwXwJxmWTeG7YD09VvAcEDIEmJ/Rx1
	ZYlQAONAe/JJchvIoo6jJVmN8cu2hdhMDHg5XUGpRjA+61vOudBsPS/gASo/AsFrBR29IgjifD3
	muwnxlOkTK5IIUo/mJY9+ZNimkfuOj/MfSBRPPlmG
X-Received: by 2002:a05:620a:1990:b0:8cd:972d:335 with SMTP id af79cd13be357-8ddcf2be7c4mr2489985a.43.1775760995686;
        Thu, 09 Apr 2026 11:56:35 -0700 (PDT)
X-Received: by 2002:a05:620a:1990:b0:8cd:972d:335 with SMTP id af79cd13be357-8ddcf2be7c4mr2485285a.43.1775760995230;
        Thu, 09 Apr 2026 11:56:35 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849e35afsm4077376d6.3.2026.04.09.11.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:56:34 -0700 (PDT)
Message-ID: <874d1114-b742-4351-b25a-4521e1f8f6e0@columbia.edu>
Date: Thu, 9 Apr 2026 14:56:32 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <addM6bkKKtoMvDIG@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <addM6bkKKtoMvDIG@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: U17u0hmlRTkeXJlkrpnxQzzKOhekZwxf
X-Authority-Analysis: v=2.4 cv=Io4utr/g c=1 sm=1 tr=0 ts=69d7f664 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=cYlWaDRCFYRnH0kQEVgA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: U17u0hmlRTkeXJlkrpnxQzzKOhekZwxf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfX+Oz9AwqraAM/
 WDL+784qoMWQ7VoQ+OjJGewhJ+AcxfqPKGPdiPx3Lpv6DHFT1A3ITuEVlN62XnmZLfPuI8B3h67
 QDMEUfO43P0j67VAUHzeSbfzLVTmSr+D07xoP3QCMTuK0/AbAn9+VSHBTjz/104Id0ovfrBejI9
 TsGRLfHi89fW+hR664u8xzhw50wD2WoCHLJyc5YDTUaZ9Jun6RkedzDr5Xvm1XWtEwM3+6FZJw7
 5OyysPYtJBlfuUNyTeKXiS5qUy1AlPR971Kna4b5WFbqq64DBJRQOJScLoCWSmITAIngYPv6p3t
 GEGd4TJYh1I2wmGjBEDMZ60CHAJTHRmjfGlY1R5dzRndNwd5fBQi5wRETGJ945Roru/nD/10kv4
 IXn+jpVPLbwZbOGmhtgR+9zrQvIs1oLa6i6Tj19YRyfM6lnj+qfJyM5zvwEF7uhvfZujBDkvR1B
 Usy51IkVdRoq/t+3KrA==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=10 suspectscore=0
 malwarescore=0 impostorscore=10 adultscore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090173

On 4/9/26 2:53 AM, Christoph Hellwig wrote:
> What tree is this against?  I tried Jens' for-next and for-7.1/block
> trees, linux-next and current mainline and it does not apply to any
> of them.

Sorry about that -- I had previously based this on an earlier rc and forgot
to rebase. For the next iteration, is there a preferred tree to rebase
onto? I see you rebased this on linux-next.

