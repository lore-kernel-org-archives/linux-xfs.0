Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6E142589D;
	Fri, 16 Oct 2026 07:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135535; cv=none; b=HxY3+sozrD77K8IdGei9LpGg+B3KJklTrF1sGLAO/8lhIW816/IX4fM8S3J2FNKAswhwXTwwru5KxzfNElu/4ikXzECnBtohRGPTsUofQhgTbyoqhcumneGhgYPJjaNh9wahN/s6ltTy0UmN0C6wwxTc8/r1IQ7g6VkhbbxkJhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135535; c=relaxed/simple;
	bh=kd3cNXp0oCLBIzYgGvW4Qahj8AzfKmIg7XSgTUAp3NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcnIuKqDpBpz/bItfYoV4ERIHKH0ncoZKS0BeXNxLLUeHM84lSOalF8KyqUScimbF63CO/tOHglF6kohyEU8+xJoRN0eFDFOOZ73eg87+6vEztTbXILL3hrK24KqkB5jDf120n6FgSvMdf4s8VrOIxvqZOqozO08WgoczuJAZVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fLD9xg59; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fLD9xg59"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FJjHJu575454;
	Fri, 16 Oct 2026 07:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=JUjQYie+YkxgaUkmMfVVcmtbvoTR+C
	oU4zK0j8eDj6o=; b=fLD9xg59ScuN1SuYDbNWU02qhgplPNAsZrchSo6AMFgJ23
	G0BO2N3XKrx6UEo5aOIXy7BN0nwwUZR/IqT0Ov82UEJcryNLdjivODsqepgMwmo3
	OgIYK9ywvCMt+1Gswi4UTYKv4SCrqxT8ycPjiNvgG6lJVTzbSVLu3nTw3w6WZ2Rb
	6m1NgmgY3fqPAl6T18Aq4UiqtPy59/u0U73/1eVe5z2mq6vZ/WzcPc1czp6tiAzl
	6aI7uWmfIkYqne5rYcOhnWzJ4RzdHcDMys9NyjQFW99MvpD17dobAgzS3K+mxeO7
	I9wJTZT0wT5wNPyV6g9dvjtAE1qnKpznfwiRXVNQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7e1wna7m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:24:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69G5sWmW2057780;
	Fri, 16 Oct 2026 07:24:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hawqwutgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:24:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69G7Orgk38994428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 07:24:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 965182004E;
	Fri, 16 Oct 2026 07:24:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A51A20040;
	Fri, 16 Oct 2026 07:24:48 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.31.170])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 07:24:47 +0000 (GMT)
Date: Fri, 16 Oct 2026 12:55:32 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH v4 12/12] iomap: Handle deadlock due to repeating
 folios in RWF_WRITETHROUGH
Message-ID: <atHRbMgzArepXTsd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <5159efdec832e8179e9f689a9292f9bf47d9a0fa.1790596383.git.ojaswin@linux.ibm.com>
 <as3t7j3P3mQhsr7p@quentin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as3t7j3P3mQhsr7p@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX8Ez8pm9LkYhN
 PJeJD7TtDpE1DeAUcnCwktcg9qVjLn1PFO6E2wBrEFYDKUN+eEC78KzwlpY4cf5HzLNtIIiEuoS
 TSN2wNgSt+8JbLZ3C20J2pityIkNaEY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX8xgohQ+J1SL8
 bHMhqrjoRcrywkI9x2RpnHyc0cfcRJlGaHcqoQ7x40AemkQU+CKYvS9xlnNHCR7Oc3UrZ4xLVk7
 QVu8PHA2ztJtyjuNcwVV36wLT5mTnmlABfUru23IodDgoqrqKjw91zjGUT7vaN9tSm7XfhYhXsK
 EjVBdMWzlea/oc72KeauQH684KRzmEVzA+n5yacjkmjW116MAwwDZPhz3ynVz/8HZ7CrEZ7cXfy
 j5q5I/OzeLZg9XjlNN9umH4RIVFCW53MljIBZvuvUpo5n4e28Wr2VtWqmweYJLvY63+8pLEtne2
 oT7WQfkKi4/ncsY21PnNzKnzCED9S5uwAdDc5fLpLHIWjh5zuQW9ozv6sMSpmJhZPA/GphZdXPq
 KWDeBfU2uUKFRB9ASXNgN7Qy8qPbKbKRHwQqJmE3gWgLZbPSorJ6ushdLwbdvzMziVBqm2tE0u3
 jxfHN9Wx8xnOGtuRcTA==
X-Authority-Analysis: v=2.4 cv=E6pYNqdl c=1 sm=1 tr=0 ts=6ad1d148 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=UyTkRMcuAzhAlBp-MlIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: PTvjpi1rn2w4e-zcFJbRgr9JRBvAlwgp
X-Proofpoint-GUID: znIlKs1_pN1Dw6ZUpe9laAJQCsODY-SP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160028

On Tue, Oct 13, 2026 at 10:40:32AM +0200, Pankaj Raghav (Samsung) wrote:
> On Mon, Sep 28, 2026 at 05:33:13PM +0530, Ojaswin Mujoo wrote:
> > In iomap_writethrough_iter() we might encounter repeating folios across
> > multiple iterations. Repeating folios can occur if, example,
> > copy_folio_from_iter_atomic() does a short copy due to userspace pages
> > not faulted in. This is an issue because a previous loop might have
> > started writeback on them but not yet issued the IO. In the next
> > iteration trying to get the same folio with FGP_STABLE will result in a
> > deadlock. Since repeating folios will always be encountered back to
> > back, we can just use a simple cur != prev check to detect them.
> > 
> > Use this to avoid waiting for writeback or starting writeback on folios
> > we have already processed. Note that in ->endio() we might end up
> > calling folio_end_writethrough() twice on the same folio which can cause
> > issues with folio_xor_flags_has_waiters(). For simplicity, just change
> > the folio_xor_flags_has_waiters() call to an idempotent variant.
> 
> Is this an outdated comment?

Yes, thanks. I'll change this. We just use the folio_end_writethrough()
now.
> 
> > 
> > Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
> 
> Thanks for fixing it. I think I was able to trigger this in a VM with
> limited memory where the chances of short copy is probably higher. The
> fixes makes sense to me.
> 
> I will run some tests this week and report back if there is an issue.
> 
> --
> Pankaj
