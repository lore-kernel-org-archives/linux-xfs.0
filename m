Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054C32D0E3;
	Tue, 29 Sep 2026 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690519; cv=none; b=qTJjYqtesTLRfvweFtqkseaxsK7B87ndu0ek3jg6LonxEEXgEjaGgsT/6a2zJ6rQSINVZU6ti3vqnWrmUzUuSQc758u5YOruqvCqc+HBnKVRnIul7lIo4ZnbxFvOx5682W59KBuTxZzWgjGek5rrwWuZGBq5byBaHIWCQNXpeoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690519; c=relaxed/simple;
	bh=eQcDflAFJ2ZQzsHeHfNZ9WS5nAyoratdK9OT0HAI27o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9GdKm3DZWm/aj6aWpSb1LPTrQVjuGYLb75hCutNVY4OOGKFbz3seQSugYDwEK4Ixpu0k8aF6RLaru5oFAmZMAeEg6lYWwlp9/vPS/lDKynXmngyJxImCALaZPV81uAMmRddv8QIKJe24LKt3DcG15fXQhnQ2V7ePruLBPa8rbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gGMmGqu9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gGMmGqu9"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TB6Buw4018608;
	Tue, 29 Sep 2026 14:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=a/yJWK1stUje8CsMHuV/XRC7f012iO
	DF6wXZWiJffxM=; b=gGMmGqu9t+NoZKnLIYeeU5NgzcPlxFlIUYko29vVnQu2be
	Ii7eN7aGhPykSqoCO4c5L3VjKFuY6zObGjzs6mo53Gfs4jmO7bJ4L7n+6UQwupz7
	mVND5zAhsMSA7tU+cNmXYXq4p42cnane1k8UK/UU44Re/vN6Ab/s0im55PkVf1KA
	n2aLoFP7LO9qK/8hCQfj+PNVnVmuVdZzutUQeiu5p1xHm878/K6ibtW5LHcflT8l
	gQ6h6N9ppBIjW8ZcZk3GIVHFWITeVEurfhYNIeHPsx0fzSdexuzL0wsiLcS8MIdq
	RvmK/xpvX3nvlSH/ULlA/DA+pJZGGbzP9lTV352w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5pt6mru-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:00:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAlWoP1667683;
	Tue, 29 Sep 2026 14:00:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsvhhx6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:00:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68TE0rDn39715106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 14:00:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02C2E20040;
	Tue, 29 Sep 2026 14:00:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EC7C2004B;
	Tue, 29 Sep 2026 14:00:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.132])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 29 Sep 2026 14:00:47 +0000 (GMT)
Date: Tue, 29 Sep 2026 19:30:44 +0530
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>,
        Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 08/12] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <arvEjPf_I0slxhLZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <ced8ea2c2bc9109837723ff3938a0359ffae834e.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced8ea2c2bc9109837723ff3938a0359ffae834e.1790596383.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CjT8fXnZds_4bXbfNx1G2QY6itM7qHZZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfX8PuKoX8Kkd9M
 Yi0wLqYWMeospKHWJ0IIzfhd3DJsPls0XGSpNvADJZLu6ibXBMpyTC2uy5HZgzDGIDT9cvlQOBc
 Ey5MYDLFHqrn7kwdeshIdWEZiZs+D4LG/hwzVr6dV19FNHoqeR8qmGEcMb0g/E0s/d0oyhdIY3t
 EZCKB05vP/bqUuUKkCywsQaX+Z+nVLH33f9bzdNRmCfdSMr13z8IYY6nkpqp4qQiy72WttmYrD1
 cjfo9KyYtED9gLbpL3QYsF/J2G8odafDWu60ft1yKYyC2DqgCC+VQ2kM5yxw20HRF8i9S49sUXi
 15yK7TxxH7j1ruNr5JsSLcOWfKwf2/6poxwJBZHuZms3qQ3dm9BnqFf90GeaGfBoKRA1eVpU8C0
 Sh/diq4hbh5qFttVDxy+SUuBe5gbCzDWKdr/yM/tKq9+F+WCJjyYYwkZ99Z9SE5Vj5i6axMkFoK
 JjtNOTrOIvfYOg2ep7Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfXyi5HmSe1k+no
 EvtTNmJBswmiwTfkQvLOPUqlPh97ru5kPQTwFFDIxAy6z5PWoIoD44YkM5Qdv3gTScoaK9AmZ4B
 WDlObc0g8VUg8l/20DJok2RTOx3R5CQ=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6abbc498 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=BWZS6MWZrVpQMnaX124A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: BZdTZffu_5U9v11aQCG_SSS0OTogAmHy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290054

On Mon, Sep 28, 2026 at 05:33:09PM +0530, Ojaswin Mujoo wrote:
> Add DSYNC support to writethrough buffered writes. Unlike the usual
> buffered writes where we call generic_write_sync() inline during the
> syscall path, for writethrough we instead sync the data during IO
> completion path, just like dio.
> 
> This allows aio writethrough to be truly async where the syscall can
> return after IO submission and the sync can then be done asynchronously
> during IO completion time.
> 
> Further, just like dio, we utilize the FUA optimization, if available,
> to avoid syncing the data for DSYNC operations.
> 
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

I made a small mistake here while doing the final squash. This patch
also removes the EOPNOTSUPP on dsync in iomap_file_writethrough_iter();

@@ -1798,9 +1824,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		return -EINVAL;
 	if (iocb->ki_flags & (IOCB_DONTCACHE))
 		return -EINVAL;
-	if (iocb_is_dsync(iocb))
-		/* D_SYNC support not implemented yet */
-		return -EOPNOTSUPP;

 	if (iocb->ki_flags & IOCB_NOWAIT)


Regards,
ojaswin
