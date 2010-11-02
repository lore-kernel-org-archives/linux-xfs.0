Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA26YR2P008542 for <xfs@oss.sgi.com>; Tue, 2 Nov 2010 01:34:27 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FCF6137EDC2
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 23:51:57 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id pFoUYTjtHHpCiUQM
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 23:51:57 -0700 (PDT)
Received: by vws19 with SMTP id 19so5550044vws.26
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 23:35:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101025134345.GB3758@infradead.org>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
	<20101021125219.GA21472@infradead.org>
	<AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
	<AANLkTikYuWMdHRtAKLauZpyWiarioB2ezxW2qVb4s9Sv@mail.gmail.com>
	<20101025134345.GB3758@infradead.org>
Date: Tue, 2 Nov 2010 12:05:47 +0530
Message-ID: <AANLkTik2nZH0tEAT1vQbZf9Y2SM0p=EJrZxgRA=sAaR0@mail.gmail.com>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6349279694355696883=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6349279694355696883==
Content-Type: multipart/alternative; boundary=0015175caade9d420d04940c2205

--0015175caade9d420d04940c2205
Content-Type: text/plain; charset=ISO-8859-1

Ok, I will implement flush_kernel_vmap_range/invalidate_kernel_vmap_range
APIs but do I need to modify XFS code also ?
Where do I make call to flush_kernel_vmap_range()/
invalidate_kernel_vmap_range() in XFS code ?

Also I wish to understand why this problem is not occuring on ARM cortex-A8,
I check the code it does not implement above API's.

--0015175caade9d420d04940c2205
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Ok, I will implement flush_kernel_vmap_range/invalidate_kernel_vmap_ra=
nge APIs=A0but do I need to modify XFS code also ?</div>
<div>Where do I make call to flush_kernel_vmap_range()/ invalidate_kernel_v=
map_range() in XFS code ?</div>
<div>=A0</div>
<div>Also I wish to understand why this problem is not occuring on ARM cort=
ex-A8, I check the code it does not implement above API&#39;s.=A0=A0=A0=A0=
=A0=A0</div>

--0015175caade9d420d04940c2205--


--===============6349279694355696883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6349279694355696883==--
