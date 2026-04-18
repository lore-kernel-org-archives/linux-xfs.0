Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214ED2874FB;
	Sat, 18 Apr 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776540993; cv=none; b=FIUQcsxFtX9F8m5FXrtlNQb/CMBbMJivNWmHlVt/S04ZI/izIdpvJ0Hh3yGkzuwuRKOaS34A6ak9LpZEjdHyqP4YqwWF2BAPslOByjx/HBayKRBMXLa3cPLHR/e3zxKUyu+vC2prpkcf4Y7KlOqxIt3RgiZfj9DiaVj9TQu2HKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776540993; c=relaxed/simple;
	bh=hSJgR8DlSEviwcDzFsIYgVWd/49n5mW5/Xo4tGBMHzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJhMf9cvjVFA5h0K2ufPZKvcocKOAe3a0/PUu75H1xbBf6lI6eyez7AzmDgvu9sd9IsPKtNUenWCXknR0g3gDlCXqdq7R6v7zmnL7lnUcqLOd0M+oVXrQ9NyTSv0pRrZZQQtwTqbWbu4g/cBFvI/mTkm5qFeAPPNXmkqbDnG6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BfwvAIQh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BfwvAIQh"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63ICeRuF3627028;
	Sat, 18 Apr 2026 19:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=t0aLuA
	laU4YKQdT6CTaa3Fxn7cIH/fXjdOil5X950VQ=; b=BfwvAIQhm5wN02e6mL/i+l
	wVIfsWf6BPu3Hy4tmpVp6fqZDJEPG5bW3QWHz5kCI1+RLf2X9AjMkFQQFsgSzH5c
	tjcgob9UdjR9MBQqzHfyV0VTtobeRwavlv8dSQcKmlfHHXaQ7sxSijE5+zRzfUKm
	KqGIQgp30DNnTQiN5m3dQwIe1pmSrlWv3PTB3CJBt0cvu5a6WWAJR/Ro5SFUmrmQ
	zJ2RILx3iOOUuLyORUKqZy1gJ9Lfj/v8kEO8pDTBSNogYtI5NSLBmfKWHyBi0FQa
	dnzLsCkxT2nlDNoJ7hIlbuwHEnXdbvGVqnXzSfpJztw52KTLscinGTIolNxsYh+g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k4t0cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 19:36:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63IJKJr6017011;
	Sat, 18 Apr 2026 19:36:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dm21ba33x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 19:36:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63IJa98M26280302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Apr 2026 19:36:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2489720043;
	Sat, 18 Apr 2026 19:36:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04B1D20040;
	Sat, 18 Apr 2026 19:36:07 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.41])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 18 Apr 2026 19:36:06 +0000 (GMT)
Date: Sun, 19 Apr 2026 01:06:02 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: changfengnan <changfengnan@bytedance.com>
Cc: Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org,
        djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        lidiangang@bytedance.com
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <aePdIlo-orHkSpxi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
 <ad_h0JMX2Jo-QODG@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.bd12b07f.c444.4fe0.8460.b6fed4af7332@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.bd12b07f.c444.4fe0.8460.b6fed4af7332@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ozo_zwYHDZxW5KF61cojKv_6KyxS-2p2
X-Proofpoint-ORIG-GUID: cmmLN-8pwsgvlnhzu1TEYQjh8_EHgbc-
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e3dd2c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=sh47DxDhtZjSA7QNqbkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE4MDE5NCBTYWx0ZWRfX2SDnWEfUu8Qy
 Sq8JUFqSlqVI7PJ4EJKJszPHae+ao//FYTsmxflSoJEVQAkJ+ITQR0cBQF01NEgx8vIs1Qg0kIx
 nPG5Vf9HPSeX09sJ/N4oYDjRN/OIy2GNKw0Fa1kNnMtcmSca51D2uSa3ezx6cWGBpxU9KjNvRpy
 wijYhX5cQ8KITWh4z2zQiT4ii1shy4dzZMrsKGR4rbx70obisZAcoJ9eyJ22Gtt7QX6gfl30KBp
 W/2ROErIqIu6mzR7Pki0zk7hJlmk9bLQfxWkRQ60WEG0HIc/aaDRNkknvzp1RSO1wlmTK7uQAyQ
 ox9FoafWIPFVQIbj7/kYw3tOvwu9MbW7psOASLGu5Rwyr1wPfmhc2cKBnZkunTydtfWXYs+QlHI
 MBFSgV4dprE9C0fb0PDC7LxaArD9RKMDErOj9klLDYSehhWEyubFHNY66dd1EGoOjbWwEWcGy2R
 Jn83kWl16aSsludtALw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-18_05,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604180194

On Thu, Apr 16, 2026 at 11:22:08AM +0800, changfengnan wrote:
> 
> > From: "Ojaswin Mujoo"<ojaswin@linux.ibm.com>
> > Date:  Thu, Apr 16, 2026, 03:07
> > Subject:  Re: [RFC PATCH] iomap: add fast read path for small direct I/O
> > To: "Fengnan Chang"<fengnanchang@gmail.com>
> > Cc: <brauner@kernel.org>, <djwong@kernel.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <lidiangang@bytedance.com>, "Fengnan Chang"<changfengnan@bytedance.com>
> > On Tue, Apr 14, 2026 at 08:26:47PM +0800, Fengnan Chang wrote:
> > > When running 4K random read workloads on high-performance Gen5 NVMe
> > > SSDs, the software overhead in the iomap direct I/O path
> > > (__iomap_dio_rw) becomes a significant bottleneck.
> > > 
> > > Using io_uring with poll mode for a 4K randread test on a raw block
> > > device:
> > > taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> > > -n1 -P1 /dev/nvme10n1
> > > Result: ~3.2M IOPS
> > > 
> > > Running the exact same workload on ext4 and XFS:
> > > taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> > > -n1 -P1 /mnt/testfile
> > > Result: ~1.9M IOPS
> > 
> > Hi Fengnan, interesting optimization! 
> > Which test suite are you using here for the io_uring tests? 
> This is test 4k randread with QD 512 in io_uring poll mode. 
> If you use fio, almost like this, but ./t/io_uring  can get higher IOPS.
> fio \
>   --name=io_uring_test \
>   --ioengine=io_uring \
>   --filename=/mnt/testfile \
>   --direct=1 \
>   --rw=randread \
>   --bs=4096 \
>   --iodepth=512 \
>   --iodepth_batch_submit=32 \
>   --iodepth_batch_complete_min=32 \
>   --hipri=1 \
>   --fixedbufs=1 \
>   --registerfiles=1 \
>   --nonvectored=1 \
>   --sqthread_poll=1
> 
> > > 
> > > Profiling the ext4 workload reveals that a significant portion of CPU
> > > time is spent on memory allocation and the iomap state machine
> > > iteration:
> > >   5.33%  [kernel]  [k] __iomap_dio_rw
> > >   3.26%  [kernel]  [k] iomap_iter
> > >   2.37%  [kernel]  [k] iomap_dio_bio_iter
> > >   2.35%  [kernel]  [k] kfree
> > >   1.33%  [kernel]  [k] iomap_dio_complete
> > 
> > Hmm read is usually under a shared lock for inode as well as extent
> > lookup so we should ideally not be blocking too much there. Can you
> > share a bit more detailed perf report. I'd be interested to see where
> > in iomap_iter() are you seeing the regression?
> Are there enough images of the flame diagram? I’ve attached them.
> ext4_poll_7.svg is without this patch, iomap_fast.svg is with this patch.

Hey thanks for sharing the flame graphs. I can see that in the older
kernel iomap_dio_rw is spending more time doing other stuff like bio
allocation and iomap_iter looping logic, than submitting IOs. 

Btw just curious, what is you perf command, did you stop recording after
a fixed time or did you record till the operation completes?

Thanks!
Ojaswin

> 
> > > 
> > > I attempted several incremental optimizations in the __iomap_dio_rw()
> > > path to close the gap:
> > > 1. Allocating the `bio` and `struct iomap_dio` together to avoid a
> > >    separate kmalloc. However, because `struct iomap_dio` is relatively
> > >    large and the main path is complex, this yielded almost no
> > >    performance improvement.
> > > 2. Reducing unnecessary state resets in the iomap state machine (e.g.,
> > >    skipping `iomap_iter_reset_iomap` where safe). This provided a ~5%
> > >    IOPS boost, which is helpful but still falls far short of closing
> > >    the gap with the raw block device.
> > > 
> > 
> > <...>
> > 
> > >  
> > > +static bool iomap_dio_fast_read_enabled = true;
> > > +
> > > +struct iomap_dio_fast_read {
> > > +        struct kiocb        *iocb;
> > > +        size_t                size;
> > > +        bool                should_dirty;
> > > +        struct work_struct        work;
> > > +        struct bio        bio ____cacheline_aligned_in_smp;
> > 
> > As Christoph pointed out, were you seeing any performance loss due to
> > not aligning to cacheline? Architectures like powerpc have a 128byte
> > cacheline and we could end up wasting significant space here.
> Get your point. I'll check.
> 
> > 
> > > +};
> > > +
> > > +static struct bio_set iomap_dio_fast_read_pool;
> > > +
> > > +static void iomap_dio_fast_read_complete_work(struct work_struct *work)
> > > +{
> > 
> > <...>
> > 
> > > +
> > > +static inline bool iomap_dio_fast_read_supported(struct kiocb *iocb,
> > > +                                          struct iov_iter *iter,
> > > +                                          unsigned int dio_flags,
> > > +                                          size_t done_before)
> > > +{
> > > +        struct inode *inode = file_inode(iocb->ki_filp);
> > > +        size_t count = iov_iter_count(iter);
> > > +        unsigned int alignment;
> > > +
> > > +        if (!iomap_dio_fast_read_enabled)
> > > +                return false;
> > > +        if (iov_iter_rw(iter) != READ)
> > > +                return false;
> > > +
> > > +        /*
> > > +         * Fast read is an optimization for small IO. Filter out large IO early
> > > +         * as it's the most common case to fail for typical direct IO workloads.
> > > +         */
> > > +        if (count > inode->i_sb->s_blocksize)
> > > +                return false;
> > > +
> > > +        if (is_sync_kiocb(iocb) || done_before)
> > 
> > Did you try this for sync reads as well? I think we should be seeing
> > similar benefits with sync reads too. Further, if the fast path helps us
> > reduce the critical section under inode lock, it could be a good win for
> > mixed read write workloads.
> Get. sync read will support in next version.
> > 
> > > +                return false;
> > > +        if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_BOUNCE))
> > > +                return false;
> > > +        if (iocb->ki_pos + count > i_size_read(inode))
> > > +                return false;
> > > +        if (IS_ENCRYPTED(inode) || fsverity_active(inode))
> > > +                return false;
> > > +
> > > +        if (count < bdev_logical_block_size(inode->i_sb->s_bdev))
> > > +                return false;
> > > +
> > > +        if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> > > +                alignment = i_blocksize(inode);
> > > +        else
> > > +                alignment = bdev_logical_block_size(inode->i_sb->s_bdev);
> > > +
> > > +        if ((iocb->ki_pos | count) & (alignment - 1))
> > > +                return false;
> > > +
> > > +        return true;
> > > +}
> > > +
> > > +static ssize_t iomap_dio_fast_read_async(struct kiocb *iocb,
> > 
> > <...>
> > 
> > > +static ssize_t fast_read_enable_store(struct kobject *kobj,
> > > +                                      struct kobj_attribute *attr,
> > > +                                      const char *buf, size_t count)
> > > +{
> > > +        bool enable;
> > > +        int ret;
> > > +
> > > +        ret = kstrtobool(buf, &enable);
> > > +        if (ret)
> > > +                return ret;
> > > +
> > > +        iomap_dio_fast_read_enabled = enable;
> > > +        return count;
> > > +}
> > > +
> > > +static struct kobj_attribute fast_read_enable_attr =
> > > +        __ATTR(fast_read_enable, 0644, fast_read_enable_show, fast_read_enable_store);
> > > +
> > > +static struct kobject *iomap_kobj;
> > > +
> > > +static int __init iomap_dio_sysfs_init(void)
> > 
> > Since we do more than sysfs work here, maybe we can have a more generic
> > name like iomap_dio_init(void) or iomap_dio_fast/simple_read_init().
> Sounds good.
> 
> > 
> > 
> > > +{
> > > +        int ret;
> > > +
> > > +        ret = bioset_init(&iomap_dio_fast_read_pool, 4,
> > > +                          offsetof(struct iomap_dio_fast_read, bio),
> > > +                          BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
> > > +        if (ret)
> > > +                return ret;
> > > +
> > > +        iomap_kobj = kobject_create_and_add("iomap", fs_kobj);
> > > +        if (!iomap_kobj) {
> > > +                bioset_exit(&iomap_dio_fast_read_pool);
> > > +                return -ENOMEM;
> > > +        }
> > > +
> > > +        if (sysfs_create_file(iomap_kobj, &fast_read_enable_attr.attr)) {
> > > +                kobject_put(iomap_kobj);
> > > +                bioset_exit(&iomap_dio_fast_read_pool);
> > > +                return -ENOMEM;
> > > +        }
> > > +
> > > +        return 0;
> > > +}
> > > +fs_initcall(iomap_dio_sysfs_init);
> > > -- 
> > 
> > Regards,
> > ojaswin
> > 
> > > 2.39.5 (Apple Git-154)
> > >
> > 



