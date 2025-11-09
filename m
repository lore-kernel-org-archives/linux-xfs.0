Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B212E7658
	for <linux-xfs@vger.kernel.org>; Sun,  9 Nov 2025 12:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762689825; cv=none; b=Vv87wQi7oVLZSlA9OWUR/kKtsi8dks043VG1HYcfYVhCbcZTZ5uIGjRn8ewGLAInzdtDI39RVplsJigNxo235f+nYtxhu0SGjWBQg8N96qJiBbT3+SIHL4lA1FWo/Zx5cQlHpPHFc0wXwR6Tcb6D6WX+RISjUfsmU7L/vD6dHXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762689825; c=relaxed/simple;
	bh=uNx2My6mig7khZckfsGlqpiWWHvKRg6kw59Failg45Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOn8jKReuRdzbmcp0UwWmWxScO+Gtj7UMzWI+xWYwfQfPzs/kQXSXUuYHbBgCO15e7dBbgj+JAFDntg298JPl1SURS43m+1eUgRH2drhEYidLJeXKy+LadGVHLMMOQ0ByPKpe24mpZhoPS3FWkxEz7X0eY9HpLbDcAkRa+YmYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GBbZ1BBw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GBbZ1BBw"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A99rGp9017040;
	Sun, 9 Nov 2025 12:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4sGGRm
	RyjSGb4L8R4xFK5fFl23BVfVzUND9hZtlwJck=; b=GBbZ1BBwsuK0TOhactenRu
	FAvGGOLKvDjgjXsm3KLfmH//vPfo4frLO3vogXllYpk8IpVG9wvb8xDsGxhJJzFA
	Kax+6xfY/aX1pwKrRLZo85TPoTMb0RhwCbs/hZ8DL5ahpNxPGLgqVzOYwp2draF5
	K6ogj1AdbcH617IW/EvifokHSH22ECET7khl6QvoDSOTJ9aL+hQrS05kNrePzRyo
	Dpp6PRB62C/FYG+vqXPVJQpexrePcU5Fh352LuVHyrqvxYqdJeocwY0O8EvJkFe+
	dvtM1M2RYzvam6Rc7b5ZV2Pg8gWUFCJa6fyTXjIuYnpGvOIxyhU2a3vgURwMKuew
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5chu33s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 12:03:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A99P2jS009573;
	Sun, 9 Nov 2025 12:03:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdj179s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 12:03:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A9C3bmN53150020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 9 Nov 2025 12:03:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5787620043;
	Sun,  9 Nov 2025 12:03:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E44D820040;
	Sun,  9 Nov 2025 12:03:35 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.19.25])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun,  9 Nov 2025 12:03:35 +0000 (GMT)
Date: Sun, 9 Nov 2025 17:32:46 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: John Garry <john.g.garry@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang
Message-ID: <aRCC5lFFkWuL0Lph@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=6910831b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=8nJEP1OIZ-IA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bpxAbgkD4Ppku_71j-oA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfXy6Y1JEk/xkcD
 LOQR3AUWQnwNOcWUOKkYyM3QhZLSPsWOD90LIw1AmWr8rU4tsoQcLrJbl8EwdHn16/YpALL4oyr
 JsFsM2WWjl6JR+nqESB0DOAOZor+Fl/03qUO5kwsxmBLUsPgRzFEUW5sZhXYVRZBiI3bxgakuCa
 yAXlTJhyr0hxg0tiW4XSMPSHjgUgmSiJznoX8dNO6x0/AxcujuUmdUL9cZV3/d4ScB7n21lRz/I
 zwLwRg9yYA+v+Atv2kUTMBBWc3Nj0t3K5XtU4q6soHuAy5Zux73xVn161isUNbhR+3CuKcNdU0y
 gK9JyuL3nLPcMoviDSacebaGHqjzpVS5kLzNPJHou6ftKuKS47BOqqX52ruMV+oG5uh9JO/TKcc
 aNQ43glso8kbIikvXCE4EhXfFf2ktg==
X-Proofpoint-GUID: vn1ICQZ5O50e_NhwFm9KNQxIhZZgzBL5
X-Proofpoint-ORIG-GUID: vn1ICQZ5O50e_NhwFm9KNQxIhZZgzBL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-09_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Thu, Nov 06, 2025 at 08:19:12AM +0000, Shinichiro Kawasaki wrote:
> On Nov 05, 2025 / 21:37, Shin'ichiro Kawasaki wrote:
> > On Nov 05, 2025 / 10:39, John Garry wrote:
> > > On 05/11/2025 08:52, John Garry wrote:
> > > > > I don't think the disk supports atomic writes. It is just a regular
> > > > > TCMU device,
> > > > > and its atomic write related sysfs attributes have value 0:
> > > > > 
> > > > >    $ grep -rne . /sys/block/sdh/queue/ | grep atomic
> > > > >    /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
> > > > >    /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
> > > > >    /sys/block/sdh/queue/atomic_write_max_bytes:1:0
> > > > >    /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
> > > > > 
> > > > > FYI, I attach the all sysfs queue attribute values of the device [2].
> > > > 
> > > > Yes, this would only be using software-based atomic writes.
> > > > 
> > > > Shinichiro, do the other atomic writes tests run ok, like 775, 767? You
> > > > can check group "atomicwrites" to know which tests they are.
> > > > 
> > > > 774 is the fio test.
> 
> I tried the other "atomicwrites" test. I found g778 took very long time.
> I think it implies that g778 may have similar problem as g774.
> 
>   g765: [not run] write atomic not supported by this block device
>   g767: 11s
>   g768: 13s
>   g769: 13s
>   g770: 35s
>   g773: [not run] write atomic not supported by this block device
>   g774: did not completed after 3 hours run (and kernel reported the INFO messages)
>   g775: 48s
>   g776: [not run] write atomic not supported by this block device
>   g778: did not completed after 50 minutes run

Hi Shinichiro

Hmm that's strange, g/778 should tune itself to the speed of the device
ideally. Will you be able to share the results/generic/778.full file.
That might give some hints.

>   x838: [not run] External volumes not in use, skipped this test
>   x839: [not run] XFS error injection requires CONFIG_XFS_DEBUG
>   x840: [not run] write atomic not supported by this block device
> 
