Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F24D37B010;
	Thu, 23 Apr 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939205; cv=none; b=Rwqq/RDjLHiTkYglC2rVYnw8CEC4KdWWH6v1TU+MtVsH0enCVa0TUd8sUhgZb6ktrNAogBu1Ike095PpS1msdZw9AAyq84NnpbtFVT0qzg5jYyyoBgxZgsX9ms8iCggxobbUbaWg+569pLLnMKQxekeg2xvph/ZZ5BVN57Oz0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939205; c=relaxed/simple;
	bh=K4Lk1yd4zNxDyY4nq1bvT5b+mRYFblpcaudogec2wlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8vzUs3GMgREZ3s0FJSJ/g2g/rhF63aEUjJihn330ugPl15rXSaGuGXxu17bz75C1SkCAz6h3qAK1m28fGDtYOfr66RCsrCfVPdwwbPnAyd39snpd+DRHyRw7nITdvkqkBdGKwe4NTKt957UeP1OHZ215GgKx5OWfHjUbyiLDqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WCZmRDi0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WCZmRDi0"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N72hrQ3514991;
	Thu, 23 Apr 2026 10:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dlMyu09z/j1n9Md0vd7d/g/7lLJhke
	D2jEsYTzV9u3E=; b=WCZmRDi0ZWi0hocRIo/9zaCYREzzpmcm3qyAnfZoCp+s7G
	2FlPC+bCu3bXVVnx30SxnciE8FpnVmlfGfMZqVLC8e3YCfOSrBDUB619DaL/jWt5
	LPHFuXRm6rchtndKwNV3r9rqus+BvXBy8CL/L/V8OS6HtEwYHyekbP2w/Wle9I8b
	gm72L0aoiK30TRsH9s/MVd6AX9E1rBd4Ezr1ZfDlL8baR69cbBzHZsZLeLEj4VmF
	UCAghll2sx7o3lSk1T13V9/HWfHts+djTsLmVs+H2XLEW4wCLSz0WHMbPxD4CTSW
	3mLgtQeUuuM9TZcPebJ8ghpczdI2FPxtRXgrs3rA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu283dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:12:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NA5Gdc025791;
	Thu, 23 Apr 2026 10:12:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxx4pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:12:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NACvI151970556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:12:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1260E2006A;
	Thu, 23 Apr 2026 10:12:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C6872005A;
	Thu, 23 Apr 2026 10:12:53 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:12:53 +0000 (GMT)
Date: Thu, 23 Apr 2026 15:42:50 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Message-ID: <aenwolyKbNkEUoNA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
 <20260415061423.GA27588@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415061423.GA27588@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA5NSBTYWx0ZWRfX/CHxngqa649t
 j9M2qpy573q8FzPAryA9nKtjALTKA1XqZxu+ypVGk6buxzA02ZNfKV9gU8LIuIe6mJClgHpnkVw
 MJQkSifxA23ZzOAAasAuvhvDzfRRnQXWmmscmeI0pgwG2P53w1DWFDR1r33LDW3bAhbulxqlPbu
 2neJ/qORAgkLz0b0QujvpQL+CGcuQEo2DLTpqabmCeFotFtYG8oRWQbnVWv0p6x0RomZp2b890H
 XYIQCITKaw2I84n6a4WdqNmrw7zKFRjARTfDY73aJIIkGxJgWCf9KUhhNbEVoTBg99hsW+cX/bd
 Tjj6p/ncYdzeJ5yiPUb9c0rJGHyyEWG84BaCP1qt47aEEQb3KiUSI23fIELXmLFjVeF4flyjLwG
 9TiQfevMFEe2FfijYZ3A+bkH7xg85LVfUi0vWwzXA23p/vch4Eurb2AlZDOZRCpVAnlTlrGxdGV
 rCQgPJIuZ3ZOT6bRFLA==
X-Proofpoint-ORIG-GUID: XTTshxLL2roUixq6z9yt4ZsXIEIoXVk7
X-Proofpoint-GUID: U-rVCM7FmNZ9J077xKzi80K_3zE9V6TE
X-Authority-Analysis: v=2.4 cv=XMUAjwhE c=1 sm=1 tr=0 ts=69e9f0ac cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=PBd0Sfe-wFWcs0skatUA:9
 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230095

On Wed, Apr 15, 2026 at 08:14:23AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 12:15:42AM +0530, Ojaswin Mujoo wrote:
> > @@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
> >   *
> >   * This incoherency between the folio's dirty flag and xarray tag is
> >   * unfortunate, but it only exists while the folio is locked.
> > + *
> > + * For some cases we might not want to do mkclean, eg, if we've already taken
> > + * care of it, hence pass the should_mkclean flag to indicate if its needed.
> >   */
> 
> The kerneldoc should move down to the exported version. 

Hey Christoph, sure thanks I'll take care of it in next version.

Regards,
ojaswin
> 
> 
