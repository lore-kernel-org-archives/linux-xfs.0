Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085203D9665;
	Wed,  5 Aug 2026 06:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911801; cv=none; b=Zhop2AJvLWpsxHtZ/Oo9iSnrUf2YgVKKOJALVFgFSx8JpdrJb6hYsi+J0sFc7UERDNLscloSpgVMw/qzsp1JXLERNsLvHyC6tR3/HT/3aSxH+jxYoFJ6tS0t11TiwF4fdu+Kd3tYWYiWeXWzuw7ewkn9fbzlUrhpf27qy9gucxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911801; c=relaxed/simple;
	bh=YBveNqSjBa4XhmmE6HkMEs9O9bq9R95ZcqaBlV8+egQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MkA5yoXsQ3JSzu4l0XRuuPXgvphD6PJIA5LG256E7U0k/NUamw3eP6H6QRN0VjGPWyi0633E1X2G4IiSQoEZ2Uol1TPwfmXki6YvEnmuRc4N3s/kFLkO5wM0pJ12P93thEm7neNwEEu99A5428+ggNrRUpzln+3WUgu6n+XQavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ER1RfIgT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ER1RfIgT"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mHMZ3005943;
	Wed, 5 Aug 2026 06:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=YBveNqSjBa4XhmmE6HkMEs9O9bq9R9
	5ZcqaBlV8+egQ=; b=ER1RfIgT9xlB73t9/xQqXyIrY+HqeVaYwCw83gutei0Ehr
	5efYEu+9KhkIY0xCg+E92XaZfWl8iHbH3lsIf2ahgYHDGBI0Az89Pq8mzQ4ryXue
	jzh721p3M21DeSifvxPW7CwMStfacsSplgvs0erSp2h15fCkoE9jFN25g5zV9ckh
	ubGOr74mJpKPylIwjW9ogaiTJc0cPGAvvO5glyFuay8lJdCn7OA6x1oX5AQniof7
	HhWgZ6Z2lcEv7EUcrCFRAt6hqnoGcvwc3H/yae+jOz3bjF0DY39eMVNwu0WDX/kJ
	Lci4BGxsbnzm5xvwSOYWoBysp8BzMnmY8Dl+uB8Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51p4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:36:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QHWI032076;
	Wed, 5 Aug 2026 06:36:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4k5btw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:36:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756a9f935783012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:36:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B10C2004F;
	Wed,  5 Aug 2026 06:36:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB04B20040;
	Wed,  5 Aug 2026 06:36:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Aug 2026 06:36:00 +0000 (GMT)
Date: Wed, 5 Aug 2026 12:05:57 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH v3 00/11] Add buffered write-through support to iomap
 & xfs
Message-ID: <anLZzeS8mx0GaPQj@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX6J9sib43SCRS
 dqCrM/w2/y3hz6rJVe6u77B9G8EWVLotZhArYX52k/tnHIdGJrsdWA3BCuxo2Tp18Rsne9ODDYa
 GBmpGuV3R79M9xxEC77vxAosPfgyOA0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXz5val6wkxSI0
 3xwQ1UfV8fBFN54ok/JGOFfkrSVopsw2bLntHw7N5x3+51NHTZlgflVeFgaPpvFUoYLsZSEF1D2
 Rh/o267uAezPAZtcRHfwVa5/PQTokXJe7J756NcrUMCmdc1uvGC67TU5Asxgg6oMv+IyVEQFgBm
 i/6IYYuRD9x1xZ6B+QybIRU3LyVtXW7NebwGR8G0myonLU2dycSgysswyV9XrCfUPmQP0DTKqoU
 1VowHuvfUXzt0vhw7OyNxxlTNguU1SX6h6Ol/nr1BSZMT5YMm9GPwvBZMvu6PTgAz278B5I6G5i
 Kl+tRvlopP18TK3h8yWzDC0WFWEiPOzVu9Z3LN5PZhXxppjOrDGdASl6ws8ZAJc5rXmZcXtN+z2
 V2eKtgQcLj1u6Ik6Xf9vQfCGL8oDtPq1KlKJ8LHBTp9fGOyld7KwwIP8TnOfr2FscppLHzWONDp
 olhrjxj6MNRGQ2vRp9g==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d9dd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=3wHVdK5kWpxBeTODUnoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ohqZjt751CnaL8m0SdDvxbjvJM6oBMhg
X-Proofpoint-GUID: ZPbgVia0mdsgFQm7hXSCBEj6YCAPX372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

On Wed, Aug 05, 2026 at 11:58:06AM +0530, Ojaswin Mujoo wrote:
> This is the next revision of writethrough series. I'll quote part of the

(+cc Andres)
