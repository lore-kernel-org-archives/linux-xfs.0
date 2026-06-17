Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504F3AFCFA;
	Wed, 17 Jun 2026 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781680212; cv=none; b=jJk734fS6sBwnQmWjgYOLOjDx114q4kM9Cn8fuyuDGthxsKyTF1mHjKodsg5PR3cztysI82h9VJdeGe9ZaTMZQuCq+cW27Nz0jW+6MolwhWHPX0+0/+0QjZKpCszWPZwrRN/ZZNPyReERjmsgRzv8V9uTFBHOquQJY14GL6txfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781680212; c=relaxed/simple;
	bh=1AMQmOsvxPKRYIGTtu+NydFMrlv18fduDf+oecr+L7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ph5wtfl+AfunwFF2ZFjI0kJoL/NorUhuomC45AemChOOV6MhzD3rthdkCtZltmAvB8X0HvJQW2QSeNJXMNikBS8pz/CB1Bu99v9i9M8olpXnqyxBr0l9QxQd5JuHqgt4nzxSGmJyJ8RkwJc134zfhdKbqENrvdH6hAAmFpSayTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fgn61NTz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fgn61NTz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GLn4Rr2895326;
	Wed, 17 Jun 2026 07:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XYe48FXtGS7x+UkZI1CFOAhBXOK6xA
	ri4I08muqQyk0=; b=Fgn61NTz6UUL7y3O0pToliAEkaK+Tawvq9A+fnWT7HjxiO
	rX9MyNOzpRh0Pz1j9RUyheov4WluyBTMf4yxOyckmpiX90ISUyQQYx/j+KBFdSKC
	GU8/zmtcYWiDxwjtyxJi5QVf/jXK50AqaE8nsvQG78UV01riwXukz97SR7/aGS/S
	q698Q2yHMCyk1L2mOVeHOynymPpKl98igr+DLQOqUj2WNtCEj0z0hXTD4YOAVyL4
	54fAVn5rDleGOjIkeCRTxa/NFmkzBmB2ISUKHCYkXMdzw8kReNUgUo9oebIXwsJD
	mnGzdGKsQcDVIP0L9dkIEtxiAS1FVgvH7tQHxeOQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4euequ1p3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 07:09:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65H74d7S032425;
	Wed, 17 Jun 2026 07:09:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eudvaa06y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 07:09:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65H79bFs49414440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 07:09:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1233020040;
	Wed, 17 Jun 2026 07:09:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AED1620043;
	Wed, 17 Jun 2026 07:09:31 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.216])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Jun 2026 07:09:31 +0000 (GMT)
Date: Wed, 17 Jun 2026 12:39:28 +0530
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
Message-ID: <ajJIKK-pNudXtpMS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDA2MiBTYWx0ZWRfX/7m7W/uw9PI1
 OVmW8NGg0/6VrzlRHWamFIww74OfS1DqI47YRP4npQ4VC8KWo+NNoPXx3XSWVltqbOwK5IY12hp
 12oijk52KC/4cn0497JXiAJLE7HA5R4=
X-Proofpoint-ORIG-GUID: FTv06Lx3gRkmq5lUbvea8RPEfx3p8Qen
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDA2MiBTYWx0ZWRfX49nhjzbA6mOJ
 o7wu2aMC+fQoDiGqfeEx5JBByLXcve3v8I++zv5fLxZ+MEWyTmkp1N2NL/gEKpe0+BW4bsrS1/e
 /zGdhkOcMU6K1ehuyyh3MINKjEt7o/9Jpifs9M2U8bY7w2l5ZQgcjACJGw8jvV4BEqx/gaZ7KaA
 cKAP/PPvwArZq965Wlsead16iVzqsjQUmOx/hxjjv6LiNVJH9HiqNhDgMDyZ5tsFGu9prNFKUvx
 1+8HwsAglwjQYacHQC/lZwT63x5IBpB0HoWZxDjxofVIGjO+wrJofwm59fBKUEn+Yu4btyS4my8
 ZbaMgRIHPbQJYWxpeRVRdtkPO2h6hXqMTFUWTKBSE0rRR8w5xYfnYslWJhVGMM3aRjj8Zy3Tu9T
 Qm/0p0TKRszc/AnVMxEZ+d6qiBRM2A0IY4PNaddoa8U5fTgtf8zn46qj9z9U7JBQ+DvmpK0GuD8
 NkrQfhIk577on62TPjA==
X-Proofpoint-GUID: IFVLhdqCq6mqL5VWJ-Ne6GKnwYBxvYdT
X-Authority-Analysis: v=2.4 cv=L9gtheT8 c=1 sm=1 tr=0 ts=6a324834 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=zrfNUkBl4axGHCdo8dAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_05,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170062

On Tue, Jun 16, 2026 at 03:57:21PM +0200, Daniel Gomez wrote:
> On 01/06/2026 18.49, Ojaswin Mujoo wrote:
> > On Wed, May 13, 2026 at 11:14:21AM +0530, Ojaswin Mujoo wrote:
> >> On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
> >>> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 720bca83..1c76634b 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -2077,16 +2077,34 @@ test_dontcache_io(void)
> >         return 1;
> >  }
> > 
> > +/*
> > + * Use a temporary file to test RWF_WRITETHROUGH so as to not modify the
> > + * original. This is so that fsx expected contents and the actual contents
> > + * of the original file don't go out of sync
> > + */
> >  int
> >  test_writethrough_io(void)
> >  {
> >         char buf[4096];
> > +       char tmpname[PATH_MAX];
> > +       int tmp_fd;
> >         struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
> >         int ret, e;
> > 
> > +       snprintf(tmpname, sizeof(tmpname), "%s.fsx.XXXXXX", fname);
> > +
> > +       tmp_fd = mkstemp(tmpname);
> > +       if (fd < 0) {
> > +               perror("test_writethrough_io: mkstemp() failed\n");
> > +               exit(132);
> > +       }
> > +
> >         memset(buf, '\0', sizeof(buf));
> > -       ret = pwritev2(fd, &iov, 1, 0, RWF_WRITETHROUGH);
> > +       ret = pwritev2(tmp_fd, &iov, 1, 0, RWF_WRITETHROUGH);
> >         e = ret < 0 ? errno : 0;
> > +
> > +       close(tmp_fd);
> > +
> >         if (e == EOPNOTSUPP) {
> >                 if (!quiet)
> >                         fprintf(stderr,
> > 
> 
> 
> I think this is missing:
> 
> @@ -2158,12 +2175,6 @@ test_writethrough_io(void)
>                 return 0;
>         }
> 
> -       if (ftruncate(fd, file_size) != 0) {
> -               perror("test_writethrough_io: failed to ftruncate to 0\n");
> -               exit(132);
> -       }
> -
> -
> 
> The fix works for me after a stress loop test on generic/457.

Awesome! and yes since we use a different file now, we can remove the
ftruncate() call.

> 
> > 
> > Im unable to replicate the 415 failure, but this one is strange because it
> > doesn't involve any writethrough IO. In you previous runs have you seen
> > this be flaky?
> 
> I couldn't confirm back then, so I think we can ignore it. Also, unrelated.

Okay.

> 
> > 
> > Admittedly, I've not yet started thorough testing since this is in early
> > RFC and the design is still getting finalized but I appriciate the help
> > in testing this.
> 
> 
> No problem. IMHO, testing makes a design more robust, once the path is
> agreed on. That said, do you think the path needs changing? Reading LWN
> and the patch series threads, I don't see any blocker. You can cc me for
> the next iteration and I'll follow up with more testing.

Yes definitely and really appreciate your help in testing this. As for
the design, the current design suffer when many writers are writing to
the same file, because the inode lock critical section is increased. So
I'm trying out a few optimizations that will lead to some non-trivial
design changes (like deferring the IO to outside the inode lock). 

I'm in process of preparing and benchmarking the new design and would
hopefully post it soon. I'll keep you in loop, thanks.

Regards,
ojaswin
