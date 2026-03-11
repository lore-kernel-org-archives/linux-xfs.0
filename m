Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F97B652;
	Wed, 11 Mar 2026 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773210513; cv=none; b=FVGc6BvjzAIgVF80LnHkCPx5vzFrjvLQH9BLnNLJoV9Kh/t0hsSgmNz/3fp5JNDN6yYiyTynKdt0vOXJfQVjmDVsUoro9KC6oPnfmGYRw78I2hF7dS9vDfZ3rsTrn5vztVNfA7WfkT9V6okT40WZ75yqIuW9ogbQflBKJl8LFp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773210513; c=relaxed/simple;
	bh=idFRLDYGSaqji22TfKEkZTGjN63Xp1znHFuqWYMNDQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsAGcJLLbBQW5Gj7aXEIsigevbZg0mGHIVE5MAFYKkE2TyBPbEoC5mQ9drqKdWss0wdiIIoFnH/Ks6A0BGJ2h7t4ymtD+yCMKd9sJTbD3hU7onIHGIdOXGB3cvNjb0/aAY8kVHanBXE7ZSnCWu+gbtuol7XqujadPajV8paULWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q3F/59pT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q3F/59pT"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B0QkRX3693682;
	Wed, 11 Mar 2026 06:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=N9RQdJK1pMBTDxBVsSAO1ngJwMvAFX
	aLuNbgxJzeoE0=; b=Q3F/59pT5ADzGvQGbfOWbTvUiwEDt3/xNkLhtGLlA3qom5
	nvjqlazZaRfzmyCEd/gBT7/+wK4buFfLkV2u/Kh4dvQGBtzN1ko6+sGot8Ki2C8M
	XuTRqu2+rth6AIWfuIU29YiaUCIbmTdlfKJRfx76H0YO8VqJSxWa6lSuVrNxvJCX
	BfNJxknCZu5pU6VWH10anrpabXjzGonB0KnE1zNhq7a/FZCLikAdhMzDEia4258f
	U/m4ep75do9o2tiRrht7i7L2iU7z1I0TwjMFkv/YCxgR0gnQdLuNql0kW3GlHZMY
	mVz2VPvlzHbwXuDBRVKqDVw2n8sXVwv2kxwUDejg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crd1mp0xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 06:28:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62B6PRqJ021181;
	Wed, 11 Mar 2026 06:28:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsve3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 06:28:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62B6RwLc29753776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 06:27:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 611782004F;
	Wed, 11 Mar 2026 06:27:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 697882005A;
	Wed, 11 Mar 2026 06:27:55 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.158])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 11 Mar 2026 06:27:55 +0000 (GMT)
Date: Wed, 11 Mar 2026 11:57:52 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, john.g.garry@oracle.com,
        willy@infradead.org, hch@lst.de, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] iomap: Enable stable writes for RWF_WRITETHROUGH inodes
Message-ID: <abELaEj_zhhKLG46@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <3704b81046b11f8b8da0367c7c8ad8767f42e5df.1773076216.git.ojaswin@linux.ibm.com>
 <20260310035719.GI1105363@frogsfrogsfrogs>
 <4imouuhb.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4imouuhb.ritesh.list@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ds3Wylg4 c=1 sm=1 tr=0 ts=69b10b71 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=T_0yxg-eI3LeCsH8YuMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA0OSBTYWx0ZWRfXy88/wtbdTV8t
 bu7xLRfplC5EbHm+BVCq2yFIO7PDgFVjmkO/5xZeil09J6zPRbP6K1cqja2zUqrACbaEqZPtyIm
 wD0vfq1rGHYO9bYCvRS4fogg5E8jB5xwKjJPJ1S4pPhoRWcuJ3PSGtxyIy4oiEv2Y/K+BwjzTcd
 K1yTu/Wz01O2yWfMsBx9DtJy1ttgfDVUZIUUDlqZtFhulWv8xmDSspD+Wvt92nmZDOzc2VQCwjS
 KPfdxOx1XaujAh8W3pJcM9+HVlOm0nvdNYc2TAsLdubRIodsCz3jUAtIBZKGj2nEpwa64bXbVXu
 6L67/PUImVOT5dLcTxcFbtKCRD5Sw/VAc2jQ0j8lWkZ/TKLtSWuHgDhRLLG/aMTFTmfPpxRQ2dz
 Y3YhNtjQ7Hw3FiaEmIQiEC3JtnSvCfG/Pp7wq9FYvh0cw3thMx/N8MVV+3T94WkcuTqDuHk5PnN
 I4PI5UGfscGgqfiSUfw==
X-Proofpoint-GUID: zhXUuC23IdkSXQsIwiHbKkhHFy8COG78
X-Proofpoint-ORIG-GUID: tPR5_RX8cr4ooo60Z--9ro6uu6VY1wRZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110049

On Tue, Mar 10, 2026 at 10:55:04AM +0530, Ritesh Harjani wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Mon, Mar 09, 2026 at 11:04:32PM +0530, Ojaswin Mujoo wrote:
> >> Currently, RWF_WRITETHROUGH writes wait for writeback to complete
> >> on a folio before performing the writethrough. This serializes
> >> writethrough with each other and the writeback path. However, it is also
> >> desirable have similar guarantees between RWF_WRITETHROUGH and non
> >> writethrough writes.
> >> 
> >> Hence, ensure stable writes are enabled on an inode's mapping as
> >> long as a writethrough write is ongoing. This way, all paths will
> >> wait for RWF_WRITETHROUGH to complete on a folio before proceeding.
> >> 
> >> To track inflight writethrough writes, we use an atomic counter in the
> >> inode->i_mapping. This struct was chosen because (i) writethrough is an
> >> operation on the folio and (ii) we don't want to add bloat to struct
> >> inode.
> 
> Now I am also questioning the need of this counter.
> If mapping has AS_STABLE_WRITES bit set, then that means the
> inode->mapping is going through stable writes until that bit is
> cleared. And since in future we are going to add support of async
> buffered write-through, so the stable writes bit should get cleared in
> the completion path (like how it is done now.) 
> 
> >
> > What if we just set it whenever someone successfully initiates a
> > RWF_WRITETHROUGH write?  Then we wouldn't need all this atomic counter
> > machinery.
> >

> 
> I agree. If we set the mapping as stable before initiating
> iomap_write_begin() itself, then we don't need this atomic counter.
> 
> Maybe, we can set it in iomap_file_writethrough_write() itself
> (we have mapping available from iocb).

Hi Darrick, Ritesh,

Yes, I think we don't need the counter to know when to switch stable
writes on and off. Now that I'm thinking about it, maybe a mapping level
stable write is too restrictive? I understand that for certain hardware we
need it at mapping level but for cases like writethrough, all we need is
that particular folio to complete writeback. Why should we serialize
it with other non overlapping writes.

Maybe implementing a folio level stable writes or sprinkling around
folio_wait_writeback() makes more sense?

Also since we are on this topic, another thing that I should change is
where we call folio_mkclean(). Right now we call folio_mkclean() after
copying user data to pagecache, which means theres a window where mmap
write might change the data. I think we should proactively call it
before the memcpy?

> 
> 
> > Also: What if some filesystem (not xfs, obviously) finds a need to
> > change the stablepages bit while there might be writethrough writes in
> > progress?
> 
> Is there a usecase where this can happen (just curious)?
> 
> > It's a little awkward to have a flag /and/ a counter; why not
> > change mapping_{set,clear}_stable_pages to inc and dec the counter and
> > base the test off that?
> >
> 
> Yes, either ways, I agree that I don't see the need of an extra counter here.
> 
> -ritesh
