Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5F136D9E8;
	Fri, 13 Mar 2026 07:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773387844; cv=none; b=fFYM4X9qOFzG8JS5m+iCjLUxqY9uNZfrRQs6qjtvuYi+CmLbgGB9PNDQ75Rd7iYVRu/cHVRnBSDxd0nq0eOu1zpQcNHgLG5feINOsYJV9i+aunizxf3ySnssKEhBDpq7pN/3gUCAZWyn59x0wzsGMAZnNkUwdIUT4x4Bw2SHeEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773387844; c=relaxed/simple;
	bh=cbGZGfV2CjzJ2vaDHw5p5SBqzz5UC0W/EU4NHhqaQd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJGmLNhNlq73fTHAjNARNSzb+OixUO9bWtSTuGGts69nEa9OluXpCzqUagNroXkZjTflB0GERi2z2ijQlLuTcy0hCNEH/rAwRSMULgkhoR783yAx1bEJRVAY5Z7tgnP7h5gd7Emzm5BwjPHBNcpIYCLxw04PcjkeYn29927L8tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qLgmYo4S; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qLgmYo4S"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D67jXb2301775;
	Fri, 13 Mar 2026 07:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7R4bZX+8l6ab+aMNio8lrPp79kOpfd
	mIIKS4MVABZ7w=; b=qLgmYo4SST0qlToLGHpbrgIh1hS0obUUyXEwuf01d2RfHf
	tjnOP0L7WFyy/Dtuv21rSz7a8RgrydtBNMKGMS5HVfbP+waXY2mwRMSNX9kYvyhL
	XdFDrfCJ/9NYirDLoK5Fo0dxxZ/4RtjtK6/VaVSnuRNev03KPHk/ONoADsdYHtO2
	1qLMt7FaWRyOb6icGmQpVkzy/3PNDACK9ivl7YNCMy0AGwAl1FABQ67qyhsi0SvK
	4PgJmwQx/dyJZxBfM2153mYlVVufvmfEnVXYkVqOfNut4WOJ7dlkT7XpUGiVclS1
	DOQ3yTaNyzCAXWxiZQc9S4q/IJOVhA5r1WT5zLhw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh95xdne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:43:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62D5crX6025691;
	Fri, 13 Mar 2026 07:43:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8dq5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 07:43:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62D7hTRF16187648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 07:43:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62CAF20043;
	Fri, 13 Mar 2026 07:43:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3734D20040;
	Fri, 13 Mar 2026 07:43:26 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Mar 2026 07:43:25 +0000 (GMT)
Date: Fri, 13 Mar 2026 13:13:23 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] iomap: Support buffered RWF_WRITETHROUGH via async dio
 backend
Message-ID: <abPAGwHuPK2ZoMpT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <c84ddc3f864f840d646b6aa19fd9b3e83e079c0b.1773076216.git.ojaswin@linux.ibm.com>
 <aa--rBKQG7ck5nuM@dread>
 <abFFcSTmUaAzbmOB@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <abFacQlKfQj3aQZk@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFacQlKfQj3aQZk@dread>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA1OSBTYWx0ZWRfXzX+jn8ytbnSN
 TsVUEvVSV2DN57iQE5GRGNpNjsDzaRlothcwEVOhYk7+jJGILZ5qxBI8dqLk90RvFsRaBHoEfVB
 PXHkGtSc0scicfGIRiPXe/MblkbD+k5eLq32A5AzuQbp4gwTkY7rZn4kUyIygDcAv/VAwtOdYjW
 soyshrA0nlQsml7TbTpI6eUI+Z9x6bHUbR1wU97RHR+jO8FV4fUzbUYWjDl3GroBqQsu7Y0GwSO
 rlN9mo/hZ7LcWFHg3N1wrfNAiKR2c3Xqxm2SgNhnO2sOB5YL4JNTzqGmzHToYu24wrtqIR4/NMd
 pNauKrXiGBSCO+opIKFP7bTPfzF2/R+rADQMGjnSOCVGJN6cgSwPRJw66I/Mc1kx5KF6GUSKqgR
 y55ANp/5B67ghZ8Zq96Nl90tfp6UK1kTt7CLtzyGKb47hGQBZQOxU7S6xqF0Qjf4pWuTivBWZOo
 VrP5jFGfOp6Lz4og4og==
X-Authority-Analysis: v=2.4 cv=FowIPmrq c=1 sm=1 tr=0 ts=69b3c024 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=a2yihl7u5Ul82en_wFIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 6E4dMa8e6E51OHzvmHSxTRLrMvC8Pw9Y
X-Proofpoint-ORIG-GUID: D6Zj7GUU2vQ712_5Hj05J2FfXWR88oHr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_01,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130059

On Wed, Mar 11, 2026 at 11:05:05PM +1100, Dave Chinner wrote:
> On Wed, Mar 11, 2026 at 04:05:29PM +0530, Ojaswin Mujoo wrote:
> > On Tue, Mar 10, 2026 at 05:48:12PM +1100, Dave Chinner wrote:
> > > On Mon, Mar 09, 2026 at 11:04:31PM +0530, Ojaswin Mujoo wrote:
> > > This is not what I envisiaged write-through using DIO to look like.
> > > This is a DIO per folio, rather than a DIO per write() syscall. We
> > > want the latter to be the common case, not the former, especially
> > > when it comes to RWF_ATOMIC support.
> > > 
> > > i.e. I was expecting something more like having a wt context
> > > allocated up front with an appropriately sized bvec appended to it
> > > (i.e. single allocation for the common case). Then in
> > > iomap_write_end(), we'd mark the folio as under writeback and add it
> > > to the bvec. Then we iterate through the IO range adding folio after
> > > folio to the bvec.
> > > 
> > > When the bvec is full or we reach the end of the IO, we then push
> > > that bvec down to the DIO code. Ideally we'd also push the iomap we
> > > already hold down as well, so that the DIO code does not need to
> > > look it up again (unless the mapping is stale). The DIO completion
> > > callback then runs a completion callback that iterates the folios
> > > attached ot the bvec and runs buffered writeback compeltion on them.
> > > It can then decrements the wt-ctx IO-in-flight counter.
> > > 
> > > If there is more user data to submit, we keep going around (with a
> > > new bvec if we need it) adding folios and submitting them to the dio
> > > code until there is no more data to copy in and submit.
> > > 
> > > The writethrough context then drops it's own "in-flight" reference
> > > and waits for the in-flight counter to go to zero.
> > 
> > Hi Dave,
> > 
> > Thanks for the review. IIUC you are suggesting a per iomap submission of
> > dio rather than a per folio,
> 
> Yes, this is the original architectural premise of iomap: we map the
> extent first, then iterate over folios, then submit a single bio for
> the extent...
> 
> > and for each iomap we submit we can
> > maintain a per writethrough counter which helps us perform any sort of
> > endio cleanup work. I can give this design a try in v2.
> 
> Yes, this is exactly how iomap DIO completion tracking works for
> IO that requires multiple bios to be submitted. i.e. completion
> processing only runs once all IOs -and submission- have completed.
> 
> > > > index c24d94349ca5..f4d8ff08a83a 100644
> > > > --- a/fs/iomap/direct-io.c
> > > > +++ b/fs/iomap/direct-io.c
> > > > @@ -713,7 +713,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> > > >  	dio->i_size = i_size_read(inode);

<...>

> > currently.
> 
> For a write() style syscall, yes. For AIO/io_uring, no.
> 
> io_submit() only returns an error if there is something wrong
> with the aio ctx or iocbs being submitted. It does not report
> completion status of the iocbs that are submitted. You need to call
> io_getevents() to obtain the completion status of individual iocbs
> that have been submitted via io_submit().
> 
> Think about it: if you submit 16 IO in on io_submit() call and
> one fails, how do you know find out which IO failed?
> 
> > However, with our idea of making the DSYNC buffered aio also
> > truly async, via writethrough, won't we be violating this guarantee?
> 
> No, the error will be returned to the AIO completion ring, same as
> it is now.

Thanks for the pointers Dave, I now have a decent picture of how
O_DSYNC/RWF_DSYNC IO will look like with writethrough. I'll try to
incorporate this in the next version, along with your other suggestions.

Regards,
ojaswin

> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
