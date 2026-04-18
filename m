Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1BF632;
	Sat, 18 Apr 2026 07:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776497303; cv=none; b=Vg1v7FSufMVqkRDlRzV3SjPkx5QMeOtvD3hjhGPGm3A4iFiH18IZXAuXUUsqXkXj0ABPbUtMSjnkDBBvIqd9AiU9JUOswmBydyZJp87AfBy5guKA3GkUu3lhq8xnGikcvhZ+v316KUIY3yuBu/2tgaT9dF/G3AUfeCkew2cDa08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776497303; c=relaxed/simple;
	bh=Eiild+U9zE7LtO05DtxU656n3BksbdMQ/JXzTkuVDiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzS6QhlHC0Buun21fUulLPh6y+iwjlWKQJxTF00Sn2xV4BVfN6d0GUHFI2MRTetU9HspEiknuAsjqoayvQpWErwRvwdDO/Dv10adSREvfSUrJk+NGsOwA4Au9zobj3W1mjiEbjEYOa7heFXqYLXGqnTh7zrWSTz1980Cb5pyl1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hxUqAgvC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hxUqAgvC"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63I7Qbb13074796;
	Sat, 18 Apr 2026 07:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3UcfRf5hLw4IB/6slz/PWLrVHi+t9K
	b7u9t3nrC9M8A=; b=hxUqAgvCJlZUp978BMJxZuGZHwxUqmbj1NF/QhYhhpv6hn
	Bx0bZp7MJe4vHF53PLnjja0LMj6RyDvj/Pypnp+qoOoe6Q59zfU3S9x+52QwZ59Y
	qbhDcGsCLp3QdokFZCw5fA9p5hoAghZmXYpf+IAOLdGcCUldWeNrDB50HjKqyADh
	4tSjOsXjrmAYEIzau1AN25DwGT6XwmYwA6kTxoOISNBD+6JZsX+3KjRbVsxw+pth
	tOjZt6yAMwB5Kaq7RtOlT/yccx67InBV+0JHCk2GcvT1K2jlw92wwOAwOf0aV8g2
	YwKp9MNxCsMLbr5iKyKeeSgJ2ZS4PTThnq1CF3MA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j68eju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:27:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63I7KNBp008694;
	Sat, 18 Apr 2026 07:27:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dm21b8h0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:27:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63I7RXlR46268682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Apr 2026 07:27:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C670520043;
	Sat, 18 Apr 2026 07:27:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C744320040;
	Sat, 18 Apr 2026 07:27:29 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.145])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 18 Apr 2026 07:27:29 +0000 (GMT)
Date: Sat, 18 Apr 2026 12:56:54 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <aeMyFgfHYy6FToBS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE4MDA2NiBTYWx0ZWRfXwFPJEJS7wVp6
 CESWDNOiOf9/f3ODyOoRfe8qmhogcakqYitJmNelpO+jPZVI7bbHZJ2ZY05E++w43Nz3avsU22X
 Nqggc0oYXlbZ1FlHIZrH/tJ2JYYibHGCtUKMwuEwWX+EPmMWgG1ff7mfL5SAxFo/3/t6arQqmRA
 EBxkKoH4SLdA/foT/jISbLIpHCnN/zaouoB6eaOTE9Ze5RdP2AK8AIULq8MZLIYIrhgC25Z5QiO
 T1b0kkn16BNCW/8Q/OoMDgl0DhpsAE6Ck1CkXbzbmFCWjum1qiGwlVolm8XM6DY4BBKUrazPqnV
 r/eOcNv58qZrnwGdbSjFRlXbvdYTG0f/zT0nkjTXszAKwENibVdP06IaGg9BxeB1Hnhxh9ItsUu
 3RbzZGji7v/qVCrjFjy2Htx+ASOIL/ykW8zdxJc+kCj2fIkBOcCowfmHmKGPoAc+6yqFdPNjyRT
 MJmNezbe1p/E1OLBt+g==
X-Proofpoint-GUID: FNkw54uiIHo6KhVeRBeSwe8XbvE3EDvW
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e33269 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=NEAV23lmAAAA:8
 a=Mcrhb_LkTwXRYZEqJH8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4wNoO9SGHnkx-6V8sya06khVAmjV_C6t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-18_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604180066

On Fri, Apr 17, 2026 at 05:54:46AM +0200, Pankaj Raghav (Samsung) wrote:
> Thanks for the patches.
> 
> > The implementation of write-through combines the buffered IO frontend
> > with dio backend, which leads to some interesting interactions.
> > I've added most of the design notes in respective patches. Please note
> > that this is an initial RFC to iron out any early design issues. This is
> > largely based on suggestions from Dave an Jan in [1] so thanks for the
> > pointers!
> > 
> > 
> > * Testing Notes (UPDATED) *
> > 
> > - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
> >   xfstests and these patches survive fsx with integrity verification as
> >   well as fsstress parallel stressing.
> 
> Could you point me to your xfstests repo where you have added this
> support? :)
> I have been traveling the whole week. I can give the patches a spin in
> my setup in the coming days.

Hi Pankaj, you can find the xfstests support here:

https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2

For fsstress, I was using generic/013 modified to run more operations.
For fsx, any of the run_fsx stressing tests would do, or you could use
the following command (writethrough should auto enable if kernel
supports it):

/home/ojas/workspace/xfstests-dev/ltp/fsx \
 -N 100000 \
 -o 65536 \
 -l 500000 \
 -r 4096 \
 -t 512 \
 -w 512 \
 --record-ops=rwf_rt.fsxops \
 $MNT/junk

Regards,
Ojaswin

> 
> > - -g quick with blocks size == page size and blocksize < pagesize shows
> >   no new regressions.
> > 
> > 
> > * Design TODOs (UPDATED) *
> > 
> > - Evaluate if we need to tag page cache dirty bit in xarray, since 
> >   PG_Writeback is already set on the folio.
> > - Look into a better way to refactor writethrough path by reusing common
> >   parts of dio code.
> > 
