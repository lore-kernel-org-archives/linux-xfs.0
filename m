Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51318A6DB;
	Fri, 28 Aug 2026 06:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787898483; cv=none; b=ClR0wBQPz46fCvsqsHZAMvisvycKNM1bK5EYEUzEVI7hPqBn5SHQVTbxKIq++yE3FmZmEBkyHMOLQlYEbG6Rp+3AitorSHO1Gq9i7q8AWvuMftZaItY1vkX2nGLlqL8KWxW1Hpm3i0RGmbiQ+jSiKai6UaaVKD/snIdb4O+Gckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787898483; c=relaxed/simple;
	bh=DZcpBV4FEkS/nNW9EqJemK453f6ddXLud94PFPLXUU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/iVrYLHrtDGEwkGHr6YWyZztr47fLZf+0YRNSAmjRO7IOml4anD/xj6ZPiscvBUa9BxE5gID0+e26b/zvJJlJ2D6ysZ/SueYNNdvy2QrnhMRGLn+qLhVhnjObBYza7yUJQMnJxMQij5JBMU7zxnRgbU8QlE1yN+rzG1gt5ncvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E6R1TV3Z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E6R1TV3Z"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S22EtN2941254;
	Fri, 28 Aug 2026 06:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=08QJ7WX+Qx2EfeECqXNbEubqtic/1i
	OmC+2hSxugyAU=; b=E6R1TV3Zh8DilQBFnv5jOdww7B7Ge8HPjU3Fuajpb5vM0F
	FNd7MwSCILkk4PJXbE12AtqfNo4pDQlvekLmv0jnYZHc8KDAjxlJ8PLwSeEbOn9P
	1Of7lARvcZukwgahmBKggQrRZkgnUZgWbP/VQGf/Ntu+vu2+fQO3L2U6SUqnd9/1
	JAKVy3oIoe4FyBH8Xxat37hGEpl06E3TIkgA761tjVm/Szzkynx8eu3TlSj6lWkG
	vspxaObPOqcD0k+4JbDAq5pdyHVp8GZhT0ckxIcdu8N56DLbn31YXbZOX047t75d
	BjX0s1+VG/N9xHdRZXKjbea5/ch3sFMFmXFbRgAg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73eradh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:27:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67S6QWnu011615;
	Fri, 28 Aug 2026 06:27:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qmxmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:27:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67S6RB6I44957980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 06:27:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D080620043;
	Fri, 28 Aug 2026 06:27:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CCB220040;
	Fri, 28 Aug 2026 06:27:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.22.178])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Aug 2026 06:27:05 +0000 (GMT)
Date: Fri, 28 Aug 2026 11:57:22 +0530
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
        linux-mm@kvack.org, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v3 07/11] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <apEoLNmw9iNYYVqf@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
 <aoMLboIzOmJzn7C0@quentin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMLboIzOmJzn7C0@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 4lPX-uCG8bHkTopq-KdpTceOIvG01eO4
X-Proofpoint-ORIG-GUID: 3XAbkb7WmxBnZS8QQwjJ2iRJXK3zB4xx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1MCBTYWx0ZWRfX7s3KbLjkSGKs
 LlZUMi2mYTLjZBHargYG8vOtxILSPzVMu2xhS2M6UwzDkpcnKT7UJKU3dP4jY+wHrmarpofmaoR
 yfboQKpiHgVX6xB76+mkaMPJokn4QzRrHWmw8unj10hixq3d2hLWlzywoTYF0nttAX3heZB0pH7
 MQk0XleUqSvnhx7FFAmuQ8Lb7tgNKZVxMe1e05fXGS9/tevoN8J61cZrt0JmEdxQ2Ef8kFMPdvR
 VWpCPaX+sEjgvNMbF4kR9eHP19/NXyUHCWUHosCnwg5DpwK6g4gNeDQgW1SqY4EdhGkGjeiG9zj
 mwU+zHKgjsMoc4PGZFXQs9txGuyue3iqrdlxcTyu1phPS9nM6+lLd27+U69o9c6zh2XT45rvOso
 gBv5f+hngo/DG6ynmMmMi5vDKF15D6CUEapt6YyS5IIti0Z7deTLTFoCPGsIQE1UTDG90RJBrej
 9N+2RPd4n8csJ7Wmatg==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a912a43 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=o2WM25ACUX-w9Fkcq3gA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1MCBTYWx0ZWRfX4YdHHO1JmDlc
 CYPgWudyF60oGYizpV6sSZ28PuGnIma9ckWfu6yheOVZYusq8dmVbVBh+jSJbSL8q1Mj4//FRoE
 fiFNpboHbGpy1Aa3DIL9sxatz7c+gys=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_01,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280050

On Mon, Aug 17, 2026 at 03:26:18PM +0200, Pankaj Raghav (Samsung) wrote:
> >  		return -EINVAL;
> >  
> > +	/*
> > +	 * If we realise that cache flush is necessary (eg FUA is not present
> > +	 * or we need metadata updates) then we turn off the optimization.
> > +	 */
> > +	if (wt_ctx->use_fua) {
> > +		if (iter->iomap.type != IOMAP_MAPPED ||
> > +		    (iter->iomap.flags &
> > +		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||
> 
> > +		    (bdev_write_cache(iter->iomap.bdev) &&
> > +		     !bdev_fua(iter->iomap.bdev)))
> Shouldn't this be similar to DIO code: !bdev_write_cache() || bdev_fua()
> ?
> 
> As long as bdev_fua() is supported, it does not matter if the
> bdev_write_cache is there or not right?

Hey Pankaj, sorry i somehow thought i replied to this already :/

So yeah we do keep the logic same as dio. In dio we enable FUA if:

    (!bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev)))

and here we __disable__ if 

    (bdev_write_cache(iter->iomap.bdev) && !bdev_fua(iter->iomap.bdev)))

So its the exact inverse of the dio check.

Regards,
ojaswin

> 
> > +			wt_ctx->use_fua = false;
> > +	}
> > +
> 
> --
> Pankaj
