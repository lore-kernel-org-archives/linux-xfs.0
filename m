Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F653C197E;
	Thu, 20 Aug 2026 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787220155; cv=none; b=RbyS8WS8zlFyZ6ekh70YZtZ31a+sEq8jt04/QYWCtYDtIwrRK4SHiks0dDi8Umg0eerOPgOjFvfIAP3zx+UNN5NCy7PfWKyKpN8/y3HegOhlR+l9HMaJJe3YkxW5Bz3jfB/bZI1H/62sSlqI443sA9J8KuNhyntCqhy1ZoNsmBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787220155; c=relaxed/simple;
	bh=bg6TiMAUaqWRs8yxlYnStaYCY/nh3tdw1e1+u4F9yh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBSGcfTGZbAu76j+AoKEsz+LHzGXapf2Bn1A1lsiDqppFGbfyXb1N8LIzM8STIFQ6p44+8Wsm/KPgSspbBHAvhy3gddFW0xlrHzXur3qT7lAxm7C3Uwesa7VEEQsiJHA+b815H2Tjz6m2MphoilfXgjjc6MKoP7Gzr6fLzAT4FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kHRXLlc7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kHRXLlc7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K99kcX471575;
	Thu, 20 Aug 2026 10:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5ZUL5Z9SYt8WjEdHcCbeeDg/xImehB
	3cb41xy7ozOFU=; b=kHRXLlc7BMKzX7CLDN6tzH2CiQdDdlljDHSt54dJKBPhkQ
	j3p8fFJP2wUd0RR1V0f6Gtb+zHHSp5ocxZbPCq8Zyh/qmHnk9tZyD+fXAyWWXfO1
	s4lIbIJe/+YQK/fw7O9pjineSdi4stHUS5bHFZZhsz4xrg3j8199C36IwXgb+kW1
	abpg8X6oFuJJ9z4Tq2HvocL3y9t42piujn/YsdXlgcyFOwxoipQTSuqb/tZx4w75
	vVJp+uNQVlpQXCUdNMckirpt04JLrilHaaNsPPLHETTKwExQJCluzDK98ECLsHVX
	ApFcCH2sqI5+f/8L9HtcQczHZzGDTg9ydVcjSlAw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu0hh5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 10:01:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67K9uJ9Z003091;
	Thu, 20 Aug 2026 10:01:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xhdtec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 10:01:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67KA1sbU51380596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 10:01:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 051F42005A;
	Thu, 20 Aug 2026 10:01:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1366020067;
	Thu, 20 Aug 2026 10:01:50 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 20 Aug 2026 10:01:49 +0000 (GMT)
Date: Thu, 20 Aug 2026 15:31:47 +0530
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
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 09/11] xfs: Implement RWF_NOSERIAL to parallelize
 RWF_WRITETHROUGH writes
Message-ID: <aobQiwQeqtzcUy-h@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>
 <aoMMIfyEuuaDFpMh@quentin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMMIfyEuuaDFpMh@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=MthiLWae c=1 sm=1 tr=0 ts=6a86d096 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=bQ7MZcWsUW_w0_kgk-kA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: g1VDju94doV9WRVTbrrDtB0eSdsWXssj
X-Proofpoint-GUID: Ct-dVH7gAufKA4s268R5rd9r-obPPj75
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA3MyBTYWx0ZWRfX9HFFzydDJ5hH
 oefgEnsN1owK02tJRzaHztoTDVNgn4AgLCO36ygvGAzvCSZ/jqXYZS6aRc5IyTNcMec/SRUhxUg
 OfeWMeu1313Ojo8AQJh0ljI/w1Ylic0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA3MyBTYWx0ZWRfX4GolvT/WcCpg
 duMbiLR+zFPUFNbA57TRsEnIye9d4i2neF4Q2TjTATl3Y5ZeFgSfXddp/Q40wMQOZ0r53afk0sL
 VDpQ/xe9hyiRC8kweFlqYjzj0vlb08vgAJpvCXjCNJcX0Kc5afyA6nHSz7UhEkCY7RM77hJik41
 EdDggafm0ee0ZDDvWlff79EdIcqSu+JmNGD/QodX7rlkc7Li+Nmik5Xji35YSYK5BZ9+1Dz1Hwf
 Dz4D4OCAdXlO4C1pPmdqyDZaPU0ZdaDdFrok+qCuqeTbKYhtRb2xEAtt+cHjx9Qt9zuPFhus+LU
 0Pi6XRlzpq920AR6dW7dt+FLVxL/I4xQam7eOkQkXZ2bavEQFuRU0ZjehQTZJRKT2HGegph94gQ
 I5kQjZQlg9uV23ybXZC6qDjZPlC6yX7lcUy0E7/Y805GTg9jc6N5j/K92tN42nSMl28x0cGFPGF
 bl5w3haSpRjwtG20G1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200073

On Mon, Aug 17, 2026 at 03:33:06PM +0200, Pankaj Raghav (Samsung) wrote:
> >  	}
> >  
> > +	/*
> > +	 * Writethrough implies non-serial writes ie writes can go
> > +	 * parallelly.
> > +	 */
> > +	if (flags & RWF_WRITETHROUGH)
> > +		kiocb_flags |= IOCB_NOSERIAL;
> > +
> 
> From a user perspective, shouldn't this be an explicit user flag instead
> of implicitly enabling for all RWF_WRITETHROUGH?
> 
> Power users who would want performance over POSIX compliance can enable
> this but it should not be the other way around IMO.
> 
> --
> Pankaj

Hi Pankaj,

Yes I think we just wanted to float the idea of such a flag but I was
unsure right now whether to have users pass it or enable it implicitly.

Thinking about it again I think I agree that we can allow users to pass
it even if we just reject it for all cases except writethrough (for
now).

Regards,
ojaswin
