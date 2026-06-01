Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3B3314B7;
	Mon,  1 Jun 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332623; cv=none; b=G5A/wVgp+BU4sRaQUX7HG2CrtXzg8jvMhXgCu5OFZcvoQP+7LS7jNgcDYEgGuXYQhblqsHF4KfkjPSsUekugODDQbxNT2k0sTNlt4PVhQ6DXElvX+xr9Z7VpM4MgxrSeAG1LwbQNP6/Kfwk0X8wn54GkbjlTZFWjbf4aKI9dKN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332623; c=relaxed/simple;
	bh=JaO/JP9VrJR5t7Rrp5D7WvGDBk0UMWfKf7obgnTo9FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYoCFA17rNH2h82m4nBfdX8c3mwvo8Qv9Qq8vYAF9nxRhl7rh+D9gfsqiJVBZZo3foG47gAqm3cCjaGXGrFSfeLRf9fowbymHgrPB/h9nrAL6cqnrt7G9na1bUvqsyBIiPQAhqel0OarRChP3C3zB6xTTVDIV+Geb6pCvcvBTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PbKFHBTo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PbKFHBTo"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651F1kG7392882;
	Mon, 1 Jun 2026 16:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7594kL+OGhTh+MPEHirvt0TgqH2sgq
	oox1kNEtcalJk=; b=PbKFHBTo3ke3/6Xa7sRuxItcAhLn8btB1dORdDZEiDdR25
	U1bR+LklCZLbQmEmSgaFXTNy3CPB0Wb2+2uIk4b4dJayZatwEhGYC3n35sB3Ub4f
	k64KrWQQf83sQ0lYhDx5/BoHXefTgHKSQY+7RzDk/D7qTzX9+oguSa5stjaR52X9
	6WcsVakwzdIPyzneIsxLhEc8tXpU68Ny8v5TZp4re0v0y2TqAmu0amxZP3cqpcSs
	gJ6aD0HLQgoV8sGToSJiMF2SlXlkRnlxLSKRAfQkkXYt/D55zvebrL5nxmXL7NTx
	wGrbPwmM2ADocm72xQixzSUB6xjjF2iF3RvyH9Sw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqm4svpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 16:49:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 651Gd8Tg018851;
	Mon, 1 Jun 2026 16:49:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egakvq8f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 16:49:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 651GnRNo54264302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jun 2026 16:49:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39DA32004F;
	Mon,  1 Jun 2026 16:49:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F03522004B;
	Mon,  1 Jun 2026 16:49:20 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.223.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jun 2026 16:49:20 +0000 (GMT)
Date: Mon, 1 Jun 2026 22:19:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Ok8QFW2BuRj6goZD5frLwUDQe05DWurF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE2NSBTYWx0ZWRfX0xEKHeDAU35P
 c3sfgGbVw+ONfqOn0CzrqdBqm/8FdE3N4eTXJ7EJwaX2RtkK6FwKKrdSv14G9byp0o97Bl1DxDe
 0SHMehppQyKyJlN3QWwpwr2Bl52VpLQqvw++w9/rr++sLAjlSEI2ouNNZHuhELp0jivEDpbwaGm
 KXhf8nd7ZncNuHhvOTO/6Qflcpfc7G1+gjcX0mH5SMahd9N9c81LoORzLLA9CEBx043c9OXHdFD
 5tl8pesjDXzv4p+acROMof4WvZpqWnVGDlPjkd6OTSlw4kvsdZQefBlrl1jCqLBVm6IV/pmaTwf
 xr5ZZp0/D/VdAZ26XXUO8KKIdu9x9c5Q+nSKlphJTIpdvKgWKeyeF9hG6kPlS8V+BrvSRCwTOz3
 L1VXjilKMasIUuGsmos4EUB3uUtorsbQHEzG6/ajal0Dyu2z2gYnh5UmnAsXvnDrYj00tIclhr9
 1jDD+yo2ohrmUUwrSjQ==
X-Proofpoint-ORIG-GUID: cKnmLeVqMk8j6myG8yTRXGcatVyb6Hci
X-Authority-Analysis: v=2.4 cv=Vf3H+lp9 c=1 sm=1 tr=0 ts=6a1db81b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=lcIDxHtVAAAA:8 a=6-Iau3dbAAAA:20 a=ERiHZSWjYGKwgxmZlbMA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=CjuIK1q_8ugA:10 a=SmPfr9tXhjlp3KZZvEYH:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010165

On Wed, May 13, 2026 at 11:14:21AM +0530, Ojaswin Mujoo wrote:
> On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
> > On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> > > Hi all,
> > > 
> > > This is the v2 RFC to add buffered writethrough support to iomap and
> > > xfs. The changes made are mostly to get the writethrough implementation
> > > more inline with how dio handles writes. 
> > > 
> > > 
> > 
> > I gave these series a run with kdevops and fstests using the following
> > profiles: xfs-crc-logdev, xfs-crc, xfs-reflink-logdev, xfs-reflink.
> > 
> > Note that I applied all patches on top of v7.1-rc1 and xfstest-dev
> > patches from Ojaswin have been rebased on latest master [1].
> > 
> > Link:
> > https://github.com/dagomez137/xfstests-dev/tree/iomap-buf-writethrough2 [1].
> > 
> > In general, some of the results here seem flaky. But let me know what
> > you think. I'll try to confirm the possible regressions with another
> > full run.
> > 
> > 
> > Summary per profile:
> > 
> > * xfs-crc-logdev: no regressions or fixes found
> > * xfs-crc:
> >   * generic/753 fixed. This test failed on 7.1.0-rc1 run but succeeded
> > on 7.1.0-rc1-00005-gc6a39600d3c3.
> > * xfs-reflink-logdev:
> >   * generic/415 failed on 7.1.0-rc1-00005-gc6a39600d3c3. I tried to
> > replicate the issue by just running generic/415 (not the entire test
> > suite), and I couldn't replicate it.
> > * xfs-reflink:
> >   * generic/457 failed on 7.1.0-rc1-00005-gc6a39600d3c3.
> >   * generic/561 failed on 7.1.0-rc1 but not on
> > 7.1.0-rc1-00005-gc6a39600d3c3.
> 
> Hey Daniel, 
> 
> thanks so much for testing the patches. I'm back this week
> from travel so still catching up to my emails. I'll go trhough thi and
> get back to you soon.
> 
> Regards,
> Ojaswin

Hi Daniel,

So this week I spent some time looking into the failure of g/457. 
I was able to replicate it in my setup and after analysing it, this is
actually an issue in my xfstests patch. The issue is that to verify
RWF_WRITETHROUGH support I do a 4kb write on the fd during the test prep
phase. However "out-of-band" write makes the actual contents of the file
different from what fsx expected (It reads it in before the problematic
write), causing the test failure. 

The below snippet fixes it:

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 720bca83..1c76634b 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2077,16 +2077,34 @@ test_dontcache_io(void)
        return 1;
 }

+/*
+ * Use a temporary file to test RWF_WRITETHROUGH so as to not modify the
+ * original. This is so that fsx expected contents and the actual contents
+ * of the original file don't go out of sync
+ */
 int
 test_writethrough_io(void)
 {
        char buf[4096];
+       char tmpname[PATH_MAX];
+       int tmp_fd;
        struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
        int ret, e;

+       snprintf(tmpname, sizeof(tmpname), "%s.fsx.XXXXXX", fname);
+
+       tmp_fd = mkstemp(tmpname);
+       if (fd < 0) {
+               perror("test_writethrough_io: mkstemp() failed\n");
+               exit(132);
+       }
+
        memset(buf, '\0', sizeof(buf));
-       ret = pwritev2(fd, &iov, 1, 0, RWF_WRITETHROUGH);
+       ret = pwritev2(tmp_fd, &iov, 1, 0, RWF_WRITETHROUGH);
        e = ret < 0 ? errno : 0;
+
+       close(tmp_fd);
+
        if (e == EOPNOTSUPP) {
                if (!quiet)
                        fprintf(stderr,


Im unable to replicate the 415 failure, but this one is strange because it
doesn't involve any writethrough IO. In you previous runs have you seen
this be flaky?

Admittedly, I've not yet started thorough testing since this is in early
RFC and the design is still getting finalized but I appriciate the help
in testing this.

Thanks again,
ojaswin

> 
> > 
> > 
> > Here the full report list for each A/B profile test run:
> > 
> > 
> > http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc-logdev.html
> > 
> > 
> > http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc.html
> > 
> > 
> > http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink-logdev.html
> > 
> > 
> > http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink.html
> > 
