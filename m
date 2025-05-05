Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03C6155C83
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746451287; cv=none; b=bpnxtIZvSPopeOk5SYzjXT2miOFkGzEKgfp1jxjN3/7v/M2PQ+nPOwsE6efzKtd1xIFswxWkgK96SmgjOfiKM02CQkhYnHG1r7YxsLUBUbQYlGAJGunhn7RNKwWfyd4ECzSqN9428A6MSQlwiiMouGonG/A5GZ2OqjR+mx2+d7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746451287; c=relaxed/simple;
	bh=10JdmTbzM7ykq2euDY1kEaDgHmZ6iXvGazWjRGf2rjI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GQLZfWI9Ts7RqOWanRsRgUXcSW452FPekCU/6YHTTFhYuBYRIyEVPg/TZiq/QqIvGZLlHEyOkkq6V4ydfZqQMUc3hz6a4dmMk8sHMy9dmu6PAeItYWXCFpMn4e4aTMmjuXotv6e4Qd/IE2m3dTS5D4pPUDhLNqpmD4NX7c/7+5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TKtcqOW+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TKtcqOW+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746451284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIG82GRDutsfX6ZuO5wxnZIciX/BmGs6c3KresObAZ8=;
	b=TKtcqOW+xPCXuYET8J5JENYqCchQ1Cow4OaOgQuO5suBHFTh3+tSy9k8/hl6fBuEgXq/dc
	t5GTxPUdrnhJIbbGg137EVfIAtrJ5bVh0fvN5Fhll1/F00Y/9ziDnldulsrP2uv0m3CYyj
	ReEto1c3Y9WIBCO3jZHjY2etUhYfuHQ=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-IWNlGWdGNIeL0ulRfPj9lQ-1; Mon, 05 May 2025 09:21:23 -0400
X-MC-Unique: IWNlGWdGNIeL0ulRfPj9lQ-1
X-Mimecast-MFC-AGG-ID: IWNlGWdGNIeL0ulRfPj9lQ_1746451283
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2c83a8ab786so3751963fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 06:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746451281; x=1747056081;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VIG82GRDutsfX6ZuO5wxnZIciX/BmGs6c3KresObAZ8=;
        b=fIYwgKwc8UDPXIST7nJsoWlemqx1wX4fuAGXCEFM1DTabGV/hEMLH/BheBjDd45hve
         5gnqrEgkPGTsHqofWuX7rcDQGg6ZAqMyftTqsFqOTOxVUk+kWFMR4E5eXM1h5anUzcNF
         +A5lgr+sVI4SHw1xfbvcqsdIo6+lHfc6MX5GqPA+nLI5AihtqBUxZxk8NreNcvA0SKWv
         bYlZc6Nm2nLLD8G2gii7/xrXHF2NBF+KGs0JbfuCicZq+vIEd2EzCr8P0ETF3TjT6CB2
         1FJ4FM5nAEsoXgDITNCvOJWyOEFcCmX6RwLfRvyLun77H5pTKZ+qfbmVj9RT9RcxFVBJ
         SIgA==
X-Forwarded-Encrypted: i=1; AJvYcCVtc2AWaP7guBvF4+sQ+hDg2H5qZX9gjx2Iq9usd7KKZUuAL+Z4MjkIFT7MxG02ZU2ThAyJRigtpG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQxw1LX7WuHwY5FVv6dMP8DsDjS8S4Plw5Pq/zP3NQavbjOjjc
	iwh3uPgLhWfI75z4zdFGClCwx4uMobQskwo4YgKMI1XdlIGEWxkykCH3XPuFxhZxn8mUT2vToPp
	OlgeuPVVWRAHpTYqApYvWiK0YoEhX3MA174aWV4jUTAhREyPDwp201zKQWTu4RkdEZA==
X-Gm-Gg: ASbGnct9VTG746UissR63QEUyeNwXlnAUOTbrkRIkoo+cckb+aAANpEtA3Wx74wPlIU
	dqiMv6MljUy9gysDIOgWx+zoNiRMB+Tamt/tD3pc13diQ+YT+gMIbwcfsO/xktPV1WYBdOorw4O
	pxuTrcC49mXXBR0bfsGHcdxrthLV4R5K1VXCNXH2lZVDbaXY6R4KGtZwZ171x6Iw0gICl41a9WA
	MKKAYlq5eYGMSlpVFHuDeS2mqe7eqm/IyXGIGMHpJ+L8OwxAIIamTO1qWGqssAtU3iFe4XF11vD
	cH7uaDhYQEEoaJNkxKMHK2EK2GePMuZ6rHSc+wgjhfI6LXtDSa99sUhpd/kglQ==
X-Received: by 2002:a05:6870:241d:b0:2b7:f58d:6dcf with SMTP id 586e51a60fabf-2dab306a348mr7088224fac.18.1746451281672;
        Mon, 05 May 2025 06:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJSFoVMOrZluBnw+MORthCitmUF2zcmvueOnmkO8JsVGz6KhUlfEjQyECXfa5BsXBb6t8dxQ==
X-Received: by 2002:a05:6870:241d:b0:2b7:f58d:6dcf with SMTP id 586e51a60fabf-2dab306a348mr7088214fac.18.1746451281316;
        Mon, 05 May 2025 06:21:21 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2daa1207873sm1985356fac.38.2025.05.05.06.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 06:21:20 -0700 (PDT)
Message-ID: <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com>
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
From: Laurence Oberman <loberman@redhat.com>
To: Dave Chinner <david@fromorbit.com>, Anton Gavriliuk
 <antosha20xx@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-block@vger.kernel.org
Date: Mon, 05 May 2025 09:21:19 -0400
In-Reply-To: <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
References: 
	<CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
	 <aBaVsli2AKbIa4We@dread.disaster.area>
	 <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
	 <aBfhDQ6lAPmn81j0@dread.disaster.area>
	 <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-05-05 at 08:29 -0400, Laurence Oberman wrote:
> On Mon, 2025-05-05 at 07:50 +1000, Dave Chinner wrote:
> > [cc linux-block]
> >=20
> > [original bug report:
> > https://lore.kernel.org/linux-xfs/CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZB=
Mmtr1oC=3DfOOgAQ@mail.gmail.com/
> > =C2=A0]
> >=20
> > On Sun, May 04, 2025 at 10:22:58AM +0300, Anton Gavriliuk wrote:
> > > > What's the comparitive performance of an identical read profile
> > > > directly on the raw MD raid0 device?
> > >=20
> > > Rocky 9.5 (5.14.0-503.40.1.el9_5.x86_64)
> > >=20
> > > [root@localhost ~]# df -mh /mnt
> > > Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% M=
ounted on
> > > /dev/md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 35T=C2=A0 1.3T=C2=A0=
=C2=A0 34T=C2=A0=C2=A0 4% /mnt
> > >=20
> > > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --
> > > exitall
> > > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB,
> > > (T)
> > > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > > fio-3.39-44-g19d9
> > > Starting 1 process
> > > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D81.4GiB/s][r=3D334k IOPS][eta
> > > 00m:00s]
> > > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D43189: Sun May=C2=A0 4=
 08:22:12
> > > 2025
> > > =C2=A0 read: IOPS=3D363k, BW=3D88.5GiB/s (95.1GB/s)(2656GiB/30001msec=
)
> > > =C2=A0=C2=A0=C2=A0 slat (nsec): min=3D971, max=3D312380, avg=3D1817.9=
2, stdev=3D1367.75
> > > =C2=A0=C2=A0=C2=A0 clat (usec): min=3D78, max=3D1351, avg=3D174.46, s=
tdev=3D28.86
> > > =C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D80, max=3D1352, avg=3D176.=
27, stdev=3D28.81
> > >=20
> > > Fedora 42 (6.14.5-300.fc42.x86_64)
> > >=20
> > > [root@localhost anton]# df -mh /mnt
> > > Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% M=
ounted on
> > > /dev/md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 35T=C2=A0 1.3T=C2=A0=
=C2=A0 34T=C2=A0=C2=A0 4% /mnt
> > >=20
> > > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --
> > > exitall
> > > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB,
> > > (T)
> > > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > > fio-3.39-44-g19d9
> > > Starting 1 process
> > > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D41.0GiB/s][r=3D168k IOPS][eta
> > > 00m:00s]
> > > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5685: Sun May=C2=A0 4 =
10:14:00
> > > 2025
> > > =C2=A0 read: IOPS=3D168k, BW=3D41.0GiB/s (44.1GB/s)(1231GiB/30001msec=
)
> > > =C2=A0=C2=A0=C2=A0 slat (usec): min=3D3, max=3D273, avg=3D 5.63, stde=
v=3D 1.48
> > > =C2=A0=C2=A0=C2=A0 clat (usec): min=3D67, max=3D2800, avg=3D374.99, s=
tdev=3D29.90
> > > =C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D72, max=3D2914, avg=3D380.=
62, stdev=3D30.22
> >=20
> > So the MD block device shows the same read performance as the
> > filesystem on top of it. That means this is a regression at the MD
> > device layer or in the block/driver layers below it. i.e. it is not
> > an XFS of filesystem issue at all.
> >=20
> > -Dave.
>=20
> I have a lab setup, let me see if I can also reproduce and then trace
> this to see where it is spending the time
>=20


Not seeing 1/2 the bandwidth but also significantly slower on Fedora42
kernel.
I will trace it

9.5 kernel - 5.14.0-503.40.1.el9_5.x86_64

Run status group 0 (all jobs):
   READ: bw=3D14.7GiB/s (15.8GB/s), 14.7GiB/s-14.7GiB/s (15.8GB/s-
15.8GB/s), io=3D441GiB (473GB), run=3D30003-30003msec

Fedora42 kernel - 6.14.5-300.fc42.x86_64

Run status group 0 (all jobs):
   READ: bw=3D10.4GiB/s (11.2GB/s), 10.4GiB/s-10.4GiB/s (11.2GB/s-
11.2GB/s), io=3D313GiB (336GB), run=3D30001-30001msec




