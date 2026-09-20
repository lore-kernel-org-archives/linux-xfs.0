Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44E1384CD5;
	Sun, 20 Sep 2026 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789900832; cv=none; b=HQnhsfveUjKvuobQXJg9Z/v7PiMQMbSI2ZDXLLzTAR/+hhXodtg07s39pdpAgUu9uDdleZPC5ZXgMe/ZcCfkrpaio2DCOcnHp4+364B4gHIl+Luqz6vFqibypgbx4np1+kertxL1hk7Gecju8fpnZQsQ19dnuNgLmI9OoY7J4m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789900832; c=relaxed/simple;
	bh=5P8FnavmC3Ng4URTEJjfFATQfgtNgeyN8CrlhK0lJYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sViNsD5MF59DqgopvqwMAls/d16Zo3suN3LkonJubNTFe68iX4bKkAFEkDHIV7nvplcbts1w4z06YbZvyjOexD2kzWd7LVxuQjg3CLu6Uf2S+/fNO8fQl8qt7v60QKQ3dy8QAITQa7D/X3Ao7shr8BtdjSKkTepzDJebg3h2toU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I5esfV1r; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I5esfV1r"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68K8a8fd374521;
	Sun, 20 Sep 2026 10:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=RK8MhFEjoR9MsQ7lvitTMuOcWt5G4p
	q46ghGLdTd364=; b=I5esfV1rc3LJTMYJppGN9nmElaeBUtDMXVAVes7n+N0wJO
	aN9AS+tKJuQ4XyMrJYa68afJ7G3FfBiCFreeKxavzL9qJoENgJR+cqbmw2jdOr+K
	6k/IXQXEiX5e/JRib/mfoefZdml2nLAPnExbS9+v9rJ/ku3Z3DdZjRcqfNsjn82e
	wLuKbbeW7MYtCVemia5jjhvEZThd+7Px362ukgcFQcjl9UvaFwQGkLVG4ByfDSd8
	SHFy4ps+JDlsjAwPOC6CBMj+cgQbm6plm67loPhSrK5+fS8wQgXMYEeZ1ivpBM6l
	4fml3VuNhuxorHWM+SyxJ5xFTEPKMiRRLDz8ad9A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1c7dt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 10:39:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68K8Wipm3691561;
	Sun, 20 Sep 2026 10:39:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt6xg9324-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 10:39:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68KAdjb542729774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 10:39:45 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 725362004B;
	Sun, 20 Sep 2026 10:39:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3243220043;
	Sun, 20 Sep 2026 10:39:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.136])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 20 Sep 2026 10:39:38 +0000 (GMT)
Date: Sun, 20 Sep 2026 16:09:35 +0530
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
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 01/11] fs: Add counter to track inflight writes
 that need stable pages
Message-ID: <aq-354yFNejvTMIl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <548c55490029490e68287aeae3d737454fa78e0e.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548c55490029490e68287aeae3d737454fa78e0e.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: iMIGYRX6mZp8ilyUkWcZ1FhI8CP3hpa8
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6aafb7f4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=qKU8kmA0DVxVJx7tx1QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDE1MyBTYWx0ZWRfX2cmciqSaQgZw
 tFhrMLyZA0X4/KtOMQWu8tlttFRNGMfr3cPy95HUe2LD/qqTvGMq5YiYlaCSV/zspqVz5D63oWZ
 JEiJUQrUH7QdbHnl6ebk+MM6NnQnLSo=
X-Proofpoint-GUID: Mk5rBBszko9gS9EKc84zqlLL37D5GbO-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDE1MyBTYWx0ZWRfXzY9M7AZCr4m2
 10NVRrYwr4GvVKlQszaoi9miZRtq1WF3ARRASDHBTSoPmFo+j8uBYsyrgLO9yH98Jo/YnxQvw4u
 /wMQYwiJSVAftUNvNaRuKflj2O+8l8nOdQRrPw99xZDCtdmBeknzMRCw9VR0qIz7DU3FWJGC5kG
 Mvwe2C/1DW8AgdYG75BonCumFO6KoGIx1LJRqdy2rGLKjvuJesSEzDdaOh4txvDqDcfzhSxmoBJ
 LbIvFPN6RdKhAk/WWziOM6vEvcbIXpu7auSCD6jnhTc8DyjUJlD/T2pOfNZtHTqCT1oTBkCIxpa
 ThX6L8GQVSocoxWW10PGqiBiOgCJWa60qS6nmQ/WlI2qkN3ZIqi5xTe3/TInEkS3gWvbQC4eTfF
 VOTTfnVz2S/9SpffHe546iowtJ6TD/w0lDWLBPH7eggpxJ4XQYuVdtAxoYxGoRTxtRB9KZW53pB
 uRTfG/TcW7XgfcHHTBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609200153

On Wed, Aug 05, 2026 at 11:58:07AM +0530, Ojaswin Mujoo wrote:
> The current flag-style stable write implementation uses idempotent set
> and clear functions. This is okay because the users for the most part
> just want to set or clear it once based on factors like underlying
> device support.
> 
> However, this scheme doesn't play well when we have parallel users
> wanting to temporarily set and unset stable writes. For example, the
> upcoming RWF_WRITETHROUGH patches need stable writes to be enabled for
> the duration of the IO. The current scheme can lead to bugs like:
> 
> RWF_WRITETHROUGH write 1             RWF_WRITETHROUGH write 2
> 
> enable stable write		     enable stable write
> submit IO
> disable stable write   <---- WRONG
> 
>                                      submit IO
>                                      disable stable write
> 
> The 2nd write loses the stable write guarantee midway which is not
> correct. Fix this by introducing a new inflight_stable_write counter
> which can be used by parallel users safely.
> 
> Unfortunately, due to the way the current users are designed, we cannot
> directly migrate them to the counter approach hence for now we will
> have to keep both methods till all the users adapt to the counters.
> 
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  include/linux/fs.h      |  1 +
>  include/linux/pagemap.h | 14 +++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8e9bc9dda0cb..5f17aa0ed4c7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -483,6 +483,7 @@ struct address_space {
>  	errseq_t		wb_err;
>  	spinlock_t		i_private_lock;
>  	struct rw_semaphore	i_mmap_rwsem;
> +	atomic_t		inflight_stable_writes_count;
>  } __attribute__((aligned(sizeof(long)))) __randomize_layout;
>  	/*
>  	 * On most architectures that alignment is already the case; but
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2c3718d592d6..eb8b7e292478 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -306,7 +306,8 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
>  
>  static inline bool mapping_stable_writes(const struct address_space *mapping)
>  {
> -	return test_bit(AS_STABLE_WRITES, &mapping->flags);
> +	return test_bit(AS_STABLE_WRITES, &mapping->flags) ||
> +	       atomic_read(&mapping->inflight_stable_writes_count) > 0;
>  }
>  
>  static inline void mapping_set_stable_writes(struct address_space *mapping)
> @@ -319,6 +320,17 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
>  	clear_bit(AS_STABLE_WRITES, &mapping->flags);
>  }
>  
> +static inline void mapping_inc_inflight_stable_writes(struct address_space *mapping)
> +{
> +	atomic_inc(&mapping->inflight_stable_writes_count);
> +}
> +
> +static inline void mapping_dec_inflight_stable_writes(struct address_space *mapping)
> +{
> +	WARN_ON_ONCE(atomic_read(&mapping->inflight_stable_writes_count) == 0);
> +	atomic_dec_if_positive(&mapping->inflight_stable_writes_count);

From Sashiko:

  If two threads concurrently call mapping_dec_inflight_stable_writes() when
  the counter is 1:

  CPU1
  atomic_read() // reads 1, bypasses warning
  CPU2
  atomic_read() // reads 1, bypasses warning
  CPU1
  atomic_dec_if_positive() // successfully decrements to 0
  CPU2
  atomic_dec_if_positive() // fails to decrement and returns -1

  Since CPU2 already bypassed the WARN_ON_ONCE via its separate read, the
  unbalanced decrement fails silently without being reported.

  Could this be made atomic by checking the return value directly, such as
  using WARN_ON_ONCE(atomic_dec_if_positive(...) < 0)?


Yes theres a race here. I'll change it to 

  WARN_ON_ONCE(atomic_dec_if_positive(...) < 0)?


Regards,
ojaswin

> +}
> +
>  static inline void mapping_set_inaccessible(struct address_space *mapping)
>  {
>  	/*
> -- 
> 2.55.0
> 
