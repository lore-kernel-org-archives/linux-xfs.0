Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A525537AA95;
	Tue, 21 Apr 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776794858; cv=none; b=TrPct/Ecs5FHWSNzRKlXwoE63351MXJLSrqEd3ZR9wOzPDp5diJou9Nn5ub9RkpoIBTXARrcfIdNVL0qWE8etlvtPLnsCbfsIO1mF9OHMZb36Kky1vWjUfjzZnrMHAPywocgUm/edALe8dRbh8iC4oIkj2ZpuuLqvW2o5F7i5JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776794858; c=relaxed/simple;
	bh=tobeidmxPe482hp0XyDuqNYCXzpR4/XtAOqftWUNEmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDSLbpwzDljukw0CoXOx40rq/zRGXpNBmvWZrmmPwoAXje0Pvgbpq4EYfwFcuYZYvYC6VMbLZzTzA96e85qvpM4WPbMnwPIzyto26JGBb44AXxD1deGimc6JtdcoiH2PuPacysQ0W0DFXGBnQ0yMYmFw+w3n+n6+9sn4mEkhi24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RBZ5lDDk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RBZ5lDDk"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LHoghJ555400;
	Tue, 21 Apr 2026 18:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0Pt5l+YeIZm/5ZIBblpz6/ApkaoGzk
	NTvoXkafxhSeE=; b=RBZ5lDDkBpFu03Ta/Ehbrp5IJOGzRIMDq8/tYQi0xa9SQB
	HdAkxziqwa+lj2iZ2G7tQWnVRuhbzHJOyyStjNLtbJhg6C7IpBs2pTxi9YjJYno8
	LjiJjY6mhFuZYhveHpJJU9HSXfFGTmFjog6NrKiSXDYV13RVfHDsA+uqKx98fd2h
	U29ZgvUZAAidC/VP1borbg3yFExpwVMF0eOZvtLmgFsomNAiCvEYfReqd5qiWmTh
	7IvullZ5ks1Debxub3OxVzbZ/Mf8lqAKO1TOXgiDsc5zZ7wpt4DrcZ67KNpJQoDI
	QDb9i2RYlxl1nasjJ7u45jz9dXJZ7dB+4/gWIXDw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2h9mvj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:07:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LHZVjZ009930;
	Tue, 21 Apr 2026 18:07:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9k1sxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:07:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LI777I43319592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 18:07:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7B222004B;
	Tue, 21 Apr 2026 18:07:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3898A20040;
	Tue, 21 Apr 2026 18:07:04 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.146])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Apr 2026 18:07:03 +0000 (GMT)
Date: Tue, 21 Apr 2026 23:37:01 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: dHOxqXuPqUDabJGUbCrDd0E8Lkxm8cBb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE3NyBTYWx0ZWRfX00Qi2ArFdy8g
 X86YPDh3hHrYDtOGYrAYeUIiu69c4eGoJjnRZ8hQMcE8ycxWxpFFgrA2RdKyA+dkts0lcguDoYA
 TKSaQAG/UDOl91qcMDhq11SyMh7fkX/q1ehkV5fOX1pui0ZCO+WEYuuFqdrElecmRHIaD4zItqF
 YAuL0IBuoHNFqenr6VnIpzCD9VS6IfFyb+X65vRlF53JjtvWr1iNrkQkNsjSDBVgWdM7UY75MNk
 +X/O59LUhRiFpwqFXWzWRwUHo1nE1bxLKicnsYdt58lEqIDqEm3kf+voGoEZ15t79BjgPmzuL/G
 Jd7ne98rUWIAriYhW3Qws7rTM2bed2/sFfk777XITx+eDzgbr0qbuPGBu8rvgyJPk4KMKt0gmMW
 ECOhEI9/g25rsV0YMAYOnQB1sLnfMi3Ry70R9rF3wZe4z1GCaX6NUwY8mpmQQod4iWQ7AyJjSES
 M8j7IBASUfyBaxC41TA==
X-Authority-Analysis: v=2.4 cv=XLYAjwhE c=1 sm=1 tr=0 ts=69e7bccf cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=iox4zFpeAAAA:8
 a=DU7pH1NQbppyTea5T5YA:9 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: nfmV67tfxh-RUfv9CeMajdvGriLKC88r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210177

On Mon, Apr 20, 2026 at 01:28:18PM +0200, Jan Kara wrote:
> On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> > On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > > +
> > > > +{

<...>

> > your comment but) after this email, I started diggin a bit more into why
> > it is needed.  As per my understanding, it tackles 2 things:
> > 
> > Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> > allows us to allocate new blocks which previously might not be allocated
> > if bs < ps.
> > 
> > Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> > old EOF to end of that folio so that readers dont read junk data after
> > isize extension.
> 
> Correct.
> 
> > Another thing I noticed is that most users of
> > iomap_file_buffered_write() do their own eof zeroing in the FS layer
> > (eg, xfs_file_write_zero_eof(), ext4's new changes,
> > ntfs_extend_initialized_size() etc). 
> > I think this FS level zerooing should take care of mkcleaning the eof
> > folio (problem 1), as they call iomap_zero_range() which would flush the
> > eof range anyways. So am I right in assuming that for FSes that do their
> > own zeroing, 1. is already taken care of?
> 
> Well, I don't see anything that would writeprotect the old tail page in
> iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
> address 2. Not only due to mmap but also possibly to clear whatever junk
> there can be in the blocks after EOF.

Well I was thinking more like if the EOF page was mmap'd it would be
dirty and blocks beyond EOF would be unmapped, so iomap_zero_range() will
write it back which shall mkclean() the folio.

But I think the same race we discussed for problem 2 can also occur
here.

Thread 1 (extending write)             Thread 2 (mmap writer)

iomap_zero_range()
filemap_write_and_wait_range()
                                       // mmaps & writes EOF range
iomap_write_iter()
isize = new_size
// pagecache_isize_extended() is
   needed to mkclean() old EOF page.

>
> > As for 2, I think after the EOF zeroing of the FS, there might be a
> > window before iomap_write_iter() where an mmap writer can still dirty
> > EOF blocks, hence the pagecache_isize_extended() would be needed here.
> > But doesn't that then make the eof zeroing in the FS layer redundant? Am
> > I missing something here?
> 
> Hmm, I agree the zeroing looks duplicit (for some users of
> pagecache_isize_extended()). And yes, doing the zeroing from
> xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
> write non-zeros before we update i_size) but I'd have hard time to argue it
> really practically matters - you are racing mmap writes with buffered
> writes so any kind of write atomicity guarantees are not there. 

Yeah, seems like it is not enough to take care of either 1 or 2 and
pagecache_isize_extended() should maybe be enough. I was just wondering
if we could optimize it away even for normal extend path (no racing mmap),
we can avoid the expensive folio_zero_range() calls.

Regardless, Ive not looked at this more closely and its a separate issue
so we can revisit it later. For now I wanted some clarity around
pagecache_isize_extended() so thanks for that.

> 
> > Regardless, for our case I think we will also need to do the
> > pagecache_isize_extended(), mainly to take care of problem 2, but where
> > exactly should we do it now?  We currently change the isize in endio()
> > but for aio, it can run outside inode or folio lock. I think this
> > function needs to be called under inode lock(). Hmm.. its a bit late here so
> > I'll revisit this tomorrow with a fresh mind :)
> 
> I think mainly to take care of problem 1... You are correct about
> inode_lock but since we are updating i_size, we should be better holding
> it, shouldn't we?

Yes you are correct. In the aio writethrough codepath, the inode update
is happening without the inode lock which is wrong. I overlooked the
fact that even aio dio uses IOMAP_DIO_FORCE_WAIT to force isize update
under inode lock, and we should do something similar as well.

So in v3, I make the change that for extending writes we shall always
finish them in "sync" fashion so ->endio() runs under inode lock. Then,
after ->endio() in iomap_dio_complete(), I will call
pagecache_isize_extended() to take care of this. Just like isize update
right now, the isize_extension only runs when the IO was successful
otherwise we return an error to the user. This gives us semantics like
dio while handling extension properly.

Does that sound okay?

Regards,
ojaswin

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
