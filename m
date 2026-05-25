Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E55315793
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779732391; cv=none; b=BzimA9MNDyf8atF6GQR01tDv3EnNljrK9Bp2R8Rrtb6n1WM1eWH6Q+EuPI4mBlKR0S4tBwhn9LWosEGsluNi79C/+0j77EiSf7JkxRiTsclXDWnwOMUlvOZ02j/Ug1h5wpFTvUCYneTRccMBpHNmnv/7O+wOYzDPBWlKNxEtGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779732391; c=relaxed/simple;
	bh=1pp+Hr16Pf3N7l0d/q2W+xea9I/gy+MmginnCOpfNrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWYumdVVUFrZYG+5XrnGDTpNn/VYaTYZhnPmEq6/SEWsYOgwCeQBiLSL2cjrztfAvJBQHYAqIlmsoc68GvD/SdHswaQlKKmpHHkfV9NGF7qbCMGmQrdAnybn8npyTOPr/cCeNqbscsggjK9AE2XZOGjNO3iFjnUtHXJiXT9jXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=LDGGlSvn; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="LDGGlSvn"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64PHe7gQ2624342
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 14:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5dou
	ZQvAFCZqdwJptJlzHlLbYqFrEBFAQblRV8bjPPI=; b=LDGGlSvnVwPgOU4r5HIX
	Vm5NLt1fPlF7jAwQrDVvRFtcUNaPLFY0z4vFHzF8KvXEAANZI70k+v0RcNbZ0hB0
	6g4puXZgHGEPugavputida2cXCM/mE4ZHs2PDRKSB62pgVTfHyArD0xbxdNakbXS
	KE/vTIjo9ruSIpd0EQJg/cY3nDA/83pNowZVYvqOrrSEwU5duvcgQ3009GAqfAfN
	dkEvk9SYCVk8mUvDfbJBStXJyg4S1/qMbbPEZudpe9MYTh+YK5MJleWd2E/NlDwV
	NgB4/9N3hqj83Dv+gYm9ZpQhehAs2aspWH660TK8R8F/Q7S72bwrWAZWjmePpXZ5
	qg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ecu1b8448-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 14:06:23 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8bc5ab12bb5so56466106d6.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 11:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779732382; x=1780337182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5douZQvAFCZqdwJptJlzHlLbYqFrEBFAQblRV8bjPPI=;
        b=EXCyznk3h0x43TmhFbKlvKimBuASvWPfDXaOjZ3lcSHLtn5fTuTT2/Z/KSn9CWAxqg
         5u+KARBGvPled8KzlBLLawHUANI7Ivapu5Pd0/gXYXwRtC9wBRzxjrS0DYc0sLKX+Pom
         EuEDUoDWS2SbpUxGYmmroF/UI8zfmVcFNNyALsgn05ux+gEMM9bxtl91RivuWzZj4hlc
         Y/igXWnlDNho16xFnaCHIGv6hwJ1jtcf/QmD+nn2xs60ygwF3MoeshOgo55eA3lfrU4L
         rOGXIWKFXBIkcFU5Ly9w5LouTPctDZH5GpzoYbWLi/NoOGRnr8BeyQiPwQyr9/fiCPHj
         MjPg==
X-Forwarded-Encrypted: i=1; AFNElJ9fsxZl0MV4Po9JtqR4nsXPvwSkS3vdWaHXxzdz58uGONt0hhxyOUS5+lqNNcEEChb6cGOtwVpIf4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNmDTJAAkWHHRNOvaYKBtSzd/2V5/KduLtO/5I9Gn6h8vW+8/y
	D1foxoTNFP2S/ItUbt/9paN8TNH2WQj5MsaiXGv0T3FeYOInNYLoWOqBhNHpHyS9OL0k7YcoIVO
	Wzn1CMbn/lNzKwpsrDFp4i7rQLzkIyXmW3BEbOzFt/KlmX/uUtk/bXtdNaQ==
X-Gm-Gg: Acq92OGsL3hiUIrlp4OBDI8btD0j+2qsyQUP8u+bL9rDzFmdShNbI3fBF7TxsZCM+GJ
	Dz39UfGOF4wzC7tVXtqPcmjQwiB5xBG32fuXDOdymI+HyuSJ2MeZfsCkohio85wxVA3yUAmArx7
	nA1VRefJSfcP7ArDiJ9l23fVrQXsMRngto7VjEoNjhAmgVVRvT4OAtvi4aA8ZHeDlGorLkjpL4f
	H1P2NVxEF0Sqi5UMvk4n+/28HWxJBVBljMbQAbWo3pdp+91fcpRuvAEqZ1PcOCfka/L5iqqOOEc
	QUCcOSibSrK3JYqwJzgP+jDTcSv4PmXRJAZdwt7bIAVFse7FoQXZPOgv3jT0Ce03qRMS/cZ4CaS
	J0CetDvX8/T8lI+F4iKVrmGdQ3afbOgWHUURhKQOOyjWGNOP1skPKXykXkm/5eADYP2SlzJg=
X-Received: by 2002:a05:6214:5a03:b0:8b1:f8fe:507b with SMTP id 6a1803df08f44-8cc7b540e74mr240941646d6.19.1779732382468;
        Mon, 25 May 2026 11:06:22 -0700 (PDT)
X-Received: by 2002:a05:6214:5a03:b0:8b1:f8fe:507b with SMTP id 6a1803df08f44-8cc7b540e74mr240941006d6.19.1779732381967;
        Mon, 25 May 2026 11:06:21 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc812e657csm127335106d6.24.2026.05.25.11.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 11:06:21 -0700 (PDT)
Message-ID: <dcba754e-1c29-402a-980c-f9fe3e57a0a1@columbia.edu>
Date: Mon, 25 May 2026 14:06:19 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
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
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
 <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
 <ahPejprWrEjsh7aC@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahPejprWrEjsh7aC@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: QsqEnqCSjE6DehQIQIEagvreIUkzqU7i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE4MSBTYWx0ZWRfX5Tipkn1sKvmx
 N9GkTOWOmLEEwcD1Gb86zUZl1mWlcQaCk8RuPfLDH7KF3AuZYCqbkNikLfo5VJNStdhZDzZQlpW
 lO4mwENT7d6llDSppx8x+NrNCLndkr44RxSNr4QJrdWYTovCiIrz3cR72TqbW1RE6gWTAGM0Mqv
 zvm1bZu+OlZF4kt4yqEtWw+9wr5sXr3ptEhW2pTN222ccbE0NiMqNuURvaWy8+E2pSNWdLqPhcN
 f+aIaMyWS18+jKBy+iki07k6DLvGXoOuRU6JuGBcgEu56QTeRUdewF7GOBIJfkdQw8cfRBfvS6G
 q7nPsKtau5NhFpe3Xol1F1+KCvSh3g+uCE1Z8oBU4FWnoy3L3Fppot9yieh7sjNGXAN+NF1MJ6t
 xCvyfwOkTGmHom2mqcStOA6WLv55Xz5hyN92YCq1PCoLpOrDKxFE3ozVZ7f2aXkC3LblCg1dh2c
 u4CQzSuTKCjK4if1dsg==
X-Authority-Analysis: v=2.4 cv=GfcnWwXL c=1 sm=1 tr=0 ts=6a148f9f cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=V2gEwdiY8GOwGPefXFgA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: QsqEnqCSjE6DehQIQIEagvreIUkzqU7i
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11797
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=10 suspectscore=0 bulkscore=10 spamscore=0 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605250181

On 5/25/26 1:30 AM, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 07:17:15PM -0400, Tal Zussman wrote:
>> A: So this actually seems legit... doesn't look like anything actually calls 
>> blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
>> block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
>> block devices seem to use iomap for writes unconditionally.
> 
> Yes.  Maybe send a separate patch to remove these now unused methods?
> Or I could do that since I forgot to remove them when I should have.
> 

I'll send a patch. I'll also drop the block_write_begin_iocb() change from this
series, as it becomes unused.
