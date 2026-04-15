Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761BF32FA30;
	Wed, 15 Apr 2026 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776280037; cv=none; b=noDY68YHFy3VrOWroNNVylVMMQSgG/6iMWKv+qWmSiu8hQVp7S/Tq0hGTE7HL6eIXCo21ZTt5AjHJVAXx0F3S7um0jidTqrEAI0AC3Gy4J6yxfDIUa9+Mq8fF/b0zGgMdfJcMUU/5k642kE/wIxobzLd3KaSH+5FNav/Ie/CFxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776280037; c=relaxed/simple;
	bh=2drBqYrF35CpWaxOSZSKY1O/3qDFuiV8G7DRGAsP0bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aA76PHUXbOzt0cKZKN+fdAgYFdC+3qmN89HY0+ncAHXPOipcKN4IAS0+I1NP5olAJ3nMBv65A0moBuk/haBHTQ24fDya1g0ZhKplhfqAO4cbTCeQf0IbTkTW/AHxS4YDA6cYUNLF0LX5u9qvTgceHo9awcQr9Hq7U9/QxgtNDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=isyOdkcM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="isyOdkcM"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FHYjIu1804718;
	Wed, 15 Apr 2026 19:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KmXnolMrf461wgQ0WQx/3QyawZRBSD
	40hzSE7LLThEQ=; b=isyOdkcM2EBxTsj3VcLyIVaXzVRk/WsQn4ib+MR9j7Re0R
	dc2N090cZWYdOPvYx4yVNvyWkWROlyITdUEjJopUwr0xeEuGphQxEZgMh/CNrupo
	HlTSGZdKCl76+ujf53Eb4ewhQajpitto/CzFmzilbBvTbBqeOWyLFiJT4kBkNJSS
	5s84QISpAdE+UdvjiV3l01qEBLuFBbfdN9U/yy7V+lBgq0oiX3/vflP/rEQ+LM6D
	ZwCOMWPW6Xgc/ANUJxOtzyhVtCHkQc3Wv5cSXmLJ+4e+e7KoaX0UCCSzpE39ZSSl
	JgyIWoVINTXLbJL5acK3g2FYLb2ZstHB3BfkzTfw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k9844-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 19:07:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FHf6h1003253;
	Wed, 15 Apr 2026 19:07:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh918f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 19:07:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FJ71AC31850958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:07:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6501720043;
	Wed, 15 Apr 2026 19:07:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2655620040;
	Wed, 15 Apr 2026 19:06:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.25.126])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 15 Apr 2026 19:06:58 +0000 (GMT)
Date: Thu, 16 Apr 2026 00:36:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Fengnan Chang <fengnanchang@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        lidiangang@bytedance.com, Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <ad_h0JMX2Jo-QODG@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414122647.15686-1-changfengnan@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -Mb5QKdULcvu1jiTyxPQJfrulZhJmqdT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE3NSBTYWx0ZWRfX0HUc6XcLtg+b
 1qyPgN+Yv32rZtv6uE2JlkxkH6UBitRf8vAzwEoE1gPCkm1rDKqNunyT/sK187RGmo4PrOgkMsX
 3lAQVqtgnhyC5ZWmJ0JCfseCACgU8CWF8NKr3vyw35DIU6JQegmbiSjYlxpKBQa5AX5RuF63+cz
 LeL8YwhfXmZ1hPsSUPzlIQxYMgU1rbul7I7LM+/ng/SCHsGxkx+J41PRTdbkxV53nzvJtIfrn+T
 tgWCu8E+wXUu3LlAr/97N/aN6SURZXuy1c1+4FRSimwqmyNocT7JWoVPTc40yS5pzWC7ZrUH6M1
 paioxkjzmxIqaBbcSQMH78z+kc1de7brehc9hjztu7KKj+OYNMn36mbOKcT+HFXzGSuOiDFL3x2
 fTBpEy/sLXRgUE89Ps8qvd7aBb1pmyydpHX0JA97neng/B/JJnOxy7ySW2yDioNholmqcC8reXd
 WlqE+9cncn7Gs3nqALQ==
X-Proofpoint-ORIG-GUID: eYR6jZ15r0JOPE8ZgLM82s5KLMjN819K
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69dfe1d8 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=yw5_ploFJTDS1x3vb8oA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150175

On Tue, Apr 14, 2026 at 08:26:47PM +0800, Fengnan Chang wrote:
> When running 4K random read workloads on high-performance Gen5 NVMe
> SSDs, the software overhead in the iomap direct I/O path
> (__iomap_dio_rw) becomes a significant bottleneck.
> 
> Using io_uring with poll mode for a 4K randread test on a raw block
> device:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /dev/nvme10n1
> Result: ~3.2M IOPS
> 
> Running the exact same workload on ext4 and XFS:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /mnt/testfile
> Result: ~1.9M IOPS

Hi Fengnan, interesting optimization! 
Which test suite are you using here for the io_uring tests? 
> 
> Profiling the ext4 workload reveals that a significant portion of CPU
> time is spent on memory allocation and the iomap state machine
> iteration:
>   5.33%  [kernel]  [k] __iomap_dio_rw
>   3.26%  [kernel]  [k] iomap_iter
>   2.37%  [kernel]  [k] iomap_dio_bio_iter
>   2.35%  [kernel]  [k] kfree
>   1.33%  [kernel]  [k] iomap_dio_complete

Hmm read is usually under a shared lock for inode as well as extent
lookup so we should ideally not be blocking too much there. Can you
share a bit more detailed perf report. I'd be interested to see where
in iomap_iter() are you seeing the regression?
> 
> I attempted several incremental optimizations in the __iomap_dio_rw()
> path to close the gap:
> 1. Allocating the `bio` and `struct iomap_dio` together to avoid a
>    separate kmalloc. However, because `struct iomap_dio` is relatively
>    large and the main path is complex, this yielded almost no
>    performance improvement.
> 2. Reducing unnecessary state resets in the iomap state machine (e.g.,
>    skipping `iomap_iter_reset_iomap` where safe). This provided a ~5%
>    IOPS boost, which is helpful but still falls far short of closing
>    the gap with the raw block device.
> 

<...>

>  
> +static bool iomap_dio_fast_read_enabled = true;
> +
> +struct iomap_dio_fast_read {
> +	struct kiocb	*iocb;
> +	size_t		size;
> +	bool		should_dirty;
> +	struct work_struct	work;
> +	struct bio	bio ____cacheline_aligned_in_smp;

As Christoph pointed out, were you seeing any performance loss due to
not aligning to cacheline? Architectures like powerpc have a 128byte
cacheline and we could end up wasting significant space here.

> +};
> +
> +static struct bio_set iomap_dio_fast_read_pool;
> +
> +static void iomap_dio_fast_read_complete_work(struct work_struct *work)
> +{

<...>

> +
> +static inline bool iomap_dio_fast_read_supported(struct kiocb *iocb,
> +					  struct iov_iter *iter,
> +					  unsigned int dio_flags,
> +					  size_t done_before)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	size_t count = iov_iter_count(iter);
> +	unsigned int alignment;
> +
> +	if (!iomap_dio_fast_read_enabled)
> +		return false;
> +	if (iov_iter_rw(iter) != READ)
> +		return false;
> +
> +	/*
> +	 * Fast read is an optimization for small IO. Filter out large IO early
> +	 * as it's the most common case to fail for typical direct IO workloads.
> +	 */
> +	if (count > inode->i_sb->s_blocksize)
> +		return false;
> +
> +	if (is_sync_kiocb(iocb) || done_before)

Did you try this for sync reads as well? I think we should be seeing
similar benefits with sync reads too. Further, if the fast path helps us
reduce the critical section under inode lock, it could be a good win for
mixed read write workloads.

> +		return false;
> +	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_BOUNCE))
> +		return false;
> +	if (iocb->ki_pos + count > i_size_read(inode))
> +		return false;
> +	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
> +		return false;
> +
> +	if (count < bdev_logical_block_size(inode->i_sb->s_bdev))
> +		return false;
> +
> +	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> +		alignment = i_blocksize(inode);
> +	else
> +		alignment = bdev_logical_block_size(inode->i_sb->s_bdev);
> +
> +	if ((iocb->ki_pos | count) & (alignment - 1))
> +		return false;
> +
> +	return true;
> +}
> +
> +static ssize_t iomap_dio_fast_read_async(struct kiocb *iocb,

<...>

> +static ssize_t fast_read_enable_store(struct kobject *kobj,
> +				      struct kobj_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	bool enable;
> +	int ret;
> +
> +	ret = kstrtobool(buf, &enable);
> +	if (ret)
> +		return ret;
> +
> +	iomap_dio_fast_read_enabled = enable;
> +	return count;
> +}
> +
> +static struct kobj_attribute fast_read_enable_attr =
> +	__ATTR(fast_read_enable, 0644, fast_read_enable_show, fast_read_enable_store);
> +
> +static struct kobject *iomap_kobj;
> +
> +static int __init iomap_dio_sysfs_init(void)

Since we do more than sysfs work here, maybe we can have a more generic
name like iomap_dio_init(void) or iomap_dio_fast/simple_read_init().


> +{
> +	int ret;
> +
> +	ret = bioset_init(&iomap_dio_fast_read_pool, 4,
> +			  offsetof(struct iomap_dio_fast_read, bio),
> +			  BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
> +	if (ret)
> +		return ret;
> +
> +	iomap_kobj = kobject_create_and_add("iomap", fs_kobj);
> +	if (!iomap_kobj) {
> +		bioset_exit(&iomap_dio_fast_read_pool);
> +		return -ENOMEM;
> +	}
> +
> +	if (sysfs_create_file(iomap_kobj, &fast_read_enable_attr.attr)) {
> +		kobject_put(iomap_kobj);
> +		bioset_exit(&iomap_dio_fast_read_pool);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +fs_initcall(iomap_dio_sysfs_init);
> -- 

Regards,
ojaswin

> 2.39.5 (Apple Git-154)
> 
