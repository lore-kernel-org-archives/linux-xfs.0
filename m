Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A7A2DC76A
	for <linux-xfs@vger.kernel.org>; Sun,  9 Nov 2025 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762689561; cv=none; b=scZuJC3X3cK6QyEm8T/jaPY4imwHuhWkW5eYGat8X1xzxOg0AAGak1egaaEhOdSPnujK6fGDwS480EhHaHPMxTNT8W+ASsEaQ+nwxFC12oi8HJE2IcnAQiS+qZ2NnGvwiF6WaRJokLgGqXaPjyOmN9byExJDNQb5Js1ZCsBsomM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762689561; c=relaxed/simple;
	bh=zjJ0vKol2izl4afeWjs5UQda5lHoLWekLKeSUlghpvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYWyIdABMwwcGFBILTpaYldNePd8CnXfgLfWiszI++RwRjXXxHOxLB7ELf1bgdOHPGKb5TZN64LS8djs6UQWHj6zdXogL87TtrF0j1/WfkCvBFU4Zx/dCF7UuzGUpRld1rbPDDPPRqhGskqn589WZxTC7HpxZJANtgkPeCr8opw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SkJFOwdp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SkJFOwdp"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A99qfpS013722;
	Sun, 9 Nov 2025 11:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vdcJeX
	tFb0G6RfCMuGfgiO4JGvbp4Eb0gF983Ib/zjo=; b=SkJFOwdpVHiAFUhL7xcQyA
	fjQLYLwwDecALtfkEQGIOqHQQ92qOBw29RwHvxtNe24YiJ+yomjEgVm1csSKD2J5
	SXEBvj2DN6+rOh8kJVuPGt4IJn0BMWopSTw3fcnvjlzd/uLYlifAx3mPTVjpGs0O
	gPMEbzlUdTJB0zX4oOhFzMdCbky3TxeQhJdoLEVm3t67vDlH9sFBowua2KVJiq9J
	oIA6R5RGyhovbpznEN6CKC/uZ1aQFjJCmo2iA86KTZWOlw9q1BoD07IBmTxS4kbm
	u+iOKItbgGSTUwaFuw2Ct+HRtWQVO9pSSE8kGjfW6wk0ckGHWihsyPriLA/myk2A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjjf7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 11:59:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9A2G9J008078;
	Sun, 9 Nov 2025 11:59:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw11456-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 11:59:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A9BxBuZ47644994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 9 Nov 2025 11:59:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1C5220043;
	Sun,  9 Nov 2025 11:59:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D98A20040;
	Sun,  9 Nov 2025 11:59:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.19.25])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun,  9 Nov 2025 11:59:10 +0000 (GMT)
Date: Sun, 9 Nov 2025 17:28:53 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang
Message-ID: <aRCB_TzOAtHaTPOl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lvnb2E-XLTfPoqua1VwF66Re5D3eNZIX
X-Proofpoint-ORIG-GUID: lvnb2E-XLTfPoqua1VwF66Re5D3eNZIX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX4opRBP2lCwzx
 VtmN3BGCKgGo0mNbO8fSPJ9D3WpEAAsbvS5LFSeDKFXp0z90u1ephXviiiWEn/cAVk6NJePxPEZ
 jhRwZVBNrSjy0su4K5PG8sHxsnfgMUydZeFBE2nQnerO4f4J9/p/KuorFe0Nf+83dcWlBvfuhvt
 DY69p79oonRhnX/HTN/86UrIE4u4ziNce2e3rEl0qwg9p3kI1Dnhm2fxjOC4fhTh3V4zcTAb+Bg
 MA9ox6Dy8Hh7d4px7BqjBEXXnYVBLARcApc0/l7UtEPj74lnaU/Q8pTO6X8brWnySPpxxj94C28
 isBos9TVtZQJygaNmYMgTDXhMjs0VnvRPIn5FwGqte4VPHnat8JVdgk+U+vpWAwstLXhw88QbAH
 JDSxxQLvkZTTjm/zQdLE/frz0G+ZGw==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=69108212 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=8nJEP1OIZ-IA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=xL1f0TH9H1rByyCkSd8A:9 a=3ZKOabzyN94A:10
 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-09_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099

On Wed, Nov 05, 2025 at 10:39:43AM +0000, John Garry wrote:
> On 05/11/2025 08:52, John Garry wrote:
> > > I don't think the disk supports atomic writes. It is just a regular
> > > TCMU device,
> > > and its atomic write related sysfs attributes have value 0:
> > > 
> > >    $ grep -rne . /sys/block/sdh/queue/ | grep atomic
> > >    /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
> > >    /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
> > >    /sys/block/sdh/queue/atomic_write_max_bytes:1:0
> > >    /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
> > > 
> > > FYI, I attach the all sysfs queue attribute values of the device [2].
> > 
> > Yes, this would only be using software-based atomic writes.
> > 
> > Shinichiro, do the other atomic writes tests run ok, like 775, 767? You
> > can check group "atomicwrites" to know which tests they are.
> > 
> > 774 is the fio test.
> > 
> > Some things to try:
> > - use a physical disk for the TEST_DEV
> > - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to
> > reduce $threads to a low value, say, 2
> > - trying turning on XFS_DEBUG config
> > 
> > BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.com/
> > v3/__https://lore.kernel.org/linux-
> > xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99hQ! IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OBiBjEI8Gz_At0595tIQ$
> > . I doubt that they will help this, but worth trying.
> > 
> > I will try to recreate.
> 
> I tested this and the filesize which we try to write is huge, like 3.3G in
> my case. That seems excessive.
> 
> The calc comes from the following in 774:
> 
> filesize=$((aw_bsize * threads * 100))
> 
> aw_bsize for  me is 1M, and threads is 32
> 
> aw_bsize is large as XFS supports software-based atomics, which is generally
> going to be huge compared to anything which HW can support.
> 
> When I tried to run this test, it was not completing in a sane amount of
> time - it was taking many minutes before I gave up.

Hi John, Shinichiro, Darrick.

Thanks for looking into this. Sorry, I'm on vacation so a bit slow in
responding.

Anyways, the logic behind the filesize calculation is that we want each
thread to do 100 atomic writes in their own isolated ranges in the file. 
But seems like it is being especially slow when we have high CPUs.

I think in that sense, it'll be better to limit the threads itself
rather than filesize. Since its a stress test we dont want it to be too
less. Maybe:

diff --git a/tests/generic/774 b/tests/generic/774
index 7a4d7016..c68fb4b7 100755
--- a/tests/generic/774
+++ b/tests/generic/774
@@ -28,7 +28,7 @@ awu_max_write=$(_get_atomic_write_unit_max "$SCRATCH_MNT/f1")
 aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
 fsbsize=$(_get_block_size $SCRATCH_MNT)

-threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
+threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "16")
 filesize=$((aw_bsize * threads * 100))
 depth=$threads
 aw_io_size=$((filesize / threads))

Can you check if this helps? 

Regards,
ojaswin

> 
> @shinichiro, please try this:
> 
> --- a/tests/generic/774
> +++ b/tests/generic/774
> @@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
>  fsbsize=$(_get_block_size $SCRATCH_MNT)
> 
>  threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> -filesize=$((aw_bsize * threads * 100))
> +filesize=$((aw_bsize * threads))
>  depth=$threads
>  aw_io_size=$((filesize / threads))
>  aw_io_inc=$aw_io_size
> ubuntu@jgarry-instance-20240626-1657-xfs-ubuntu:~/xfstests-dev$
> 
> 
> Note, I ran with this change and the test now completes, but I get this:
> 
> +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +verify: bad magic header 0, wanted acca at file
> /home/ubuntu/mnt/scratch/test-file offset 0, length 1048576 (requested
> block: offset=0, length=1048576)
>     +verify: bad magic header e3d6, wanted acca at file
> /home/ubuntu/mnt/scratch/test-file offset 8388608, length 1048576 (requested
> block: offset=8388608, length=1048576)
> 
> I need to check that fio complaint.
> 
> Thanks,
> John
