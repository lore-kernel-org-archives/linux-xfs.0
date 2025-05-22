Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F5221DB3;
	Thu, 22 May 2025 10:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747910036; cv=none; b=fEs4rfteEjjGjgHCGyKZrYDJ869EwKg2Md28cbP4Y0R/U8qzUxml+EU6uxwylqDDjyF6JzxSKP4MNIfpOZf/G3oUmXzsfU5NSJioq2HqSlo//SKMYnUyovafWb5eeB+iyC6VhhrMYIAoqT4c0TKWbETmevHTj5nhd/yR961RCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747910036; c=relaxed/simple;
	bh=19AzBbhUqXav6eFik5f+PwhcpejdRnRpwVS2qUjifz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KckHvEWCUsi48IfQQpw7WQspNwUnfyGOyD6Mv2iuvZ/NUyZy/u6z1Y6kdHNbqo5PP9FxOM6sTXt6VpdYmdRAZGDJb3oXT4o4bEu0H12vfx4zHV+yx0D9eHcMlByVJR7mzPmWWaha6JpED8otXElx/gXKgAnOr4CEr0Y7XKXulBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Li6icrEt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Li6icrEt"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M7GOEr003406;
	Thu, 22 May 2025 10:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ims7lkQh/jaAQtzQRLsOy7MUrS0nVs
	LqyNcwnlrovWM=; b=Li6icrEt4kY8ihbvsJmUaN5AH5/1CpeUuyRzA6xLTItg81
	c425U6PyKBaf/C3+uwulOEFv0X+3uaII8h2wQVv1vf3pAnhBI7gzMCo6ulfPDT0m
	+yElqWzeMtopFHMworvP65PY4xnR7cOOL0UJ8nADhSk43WeTkVfb6aoNAW0d310U
	S6SKvD8iG9IIblDtMUDYRjj/taMkMsNHe2u6Eb1MS/TZ4Sa1PvF+19bHNmwDxuE0
	tFEIJNRcVg/dO4SvYNW8M7yjkwZYfFg1x1a1FutAvD4tuEUyOTx6P2nCobVWdpoV
	BbNRFqttyt9CRG8JejbCMWRaiMhn13yovCOunmNg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh73hsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:33:49 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MAR7au019751;
	Thu, 22 May 2025 10:33:48 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh73hst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:33:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9U2mL015454;
	Thu, 22 May 2025 10:33:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnh0u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:33:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MAXkv426608096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:33:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EE5120043;
	Thu, 22 May 2025 10:33:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFBB02004B;
	Thu, 22 May 2025 10:33:44 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:33:44 +0000 (GMT)
Date: Thu, 22 May 2025 16:03:42 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        john.g.garry@oracle.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with
 scsi_debug
Message-ID: <aC79ht_dmRWfBllU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-7-catherine.hoang@oracle.com>
 <8734czwkqd.fsf@gmail.com>
 <20250521023052.GC9705@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521023052.GC9705@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfXypUIRdUskbrK vl3MDLhhEKCA2Y/76F2jsVYaAqcblMl82raylPV6Bf1jVb3d9XabvuYZZajzFGAmWhCb7lhgShS cI5svaBwp3kchxXi51hy5wQa9sBQ2QQ8qGVvB0TNGPFfUEpxzRHs5pIPoEL61gbTbW/aYEDfpaT
 kLAB669jNj5KVOdskCvzoA19GfKvoNg7OpwMRvBn1eMph/oPi1YFk5sRKcMJaWkHI3psINtmqnN VArReL6MYFGuzsnRxMkTugil/Ux1lg5+a62XMBCT2JKKOyEpKMqqApYdl6ylgLObbanxAYBCH5Z xIHFQ26jhL3nh2z0mzT7KoJvJo6zSBK5QP3BChmrUrtOky/MAhq5oJltb+kx5Tsto07gTcNxYzf
 T7CwHhg4ugQv3Z2Ql0Eqc4C+u7vkhatITrsnPKzbUQ0PalZTQFZekqHQ/E8ZIcawkRVjYFDR
X-Proofpoint-GUID: RfI9TQz-Hr8BPKolkwHijdEbbExsXavV
X-Proofpoint-ORIG-GUID: IFMmXIdVhbas2kHdtrUJ7LSiV1e9cBnS
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682efd8d cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=ppM32psNZxn-ApLd5rwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220101

On Tue, May 20, 2025 at 07:30:52PM -0700, Darrick J. Wong wrote:
> On Tue, May 20, 2025 at 05:35:30PM +0530, Ritesh Harjani wrote:
> > Catherine Hoang <catherine.hoang@oracle.com> writes:
> > 
> > > From: "Darrick J. Wong" <djwong@kernel.org>

<snip> 
> > > +	cd /
> > > +	rm -r -f $tmp.*
> > > +}
> > > +
> > > +_require_scsi_debug
> > > +_require_scratch_nocheck
> > > +# Format something so that ./check doesn't freak out
> > > +_scratch_mkfs >> $seqres.full
> > > +
> > > +# 512b logical/physical sectors, 512M size, atomic writes enabled
> > > +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> > > +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> > > +
> > > +export SCRATCH_DEV=$dev
> > > +unset USE_EXTERNAL
> > > +
> > > +_require_scratch_write_atomic
> > > +_require_atomic_write_test_commands
> > 
> > Is it possible to allow pwrite -A to be tested on $SCRATCH_MNT rather
> > than on TEST_MNT? For e.g. 
> > 
> > What happens when TEST_DEV is not atomic write capable? Then this test
> > won't run even though we are passing scsi_debug which supports atomic writes.
> 
> Hrmmmm.  Maybe we need an open-coded version of the "make sure the
> xfs_io commands are present" checks without actually doing live testing
> of the $TEST_DIR since we're creating a scsi-debug with atomic write
> capability anyway.

I think it might be better to finally have a _require_scratch_xfs_io_command()
and hence a _require_scratch_atomic_write_commands. This can avoid the
open coding as well as future proof it for similar features.

> 
> > > +
> > > +echo "scsi_debug atomic write properties" >> $seqres.full
> > > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > > +
> > > +testfile=$SCRATCH_MNT/testfile
> > > +touch $testfile
> > > +
> > > +echo "filesystem atomic write properties" >> $seqres.full
> > > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
