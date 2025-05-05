Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB7250C06
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448170; cv=none; b=LKexcAZIdZVddTwpRCkCikGyDBU57VtyEse1MdLh/UYXq/MboVfE5reTc3QPtyWOAagEObuzB07jw35Yhw3mDTpq3bupP+cG/cLWRgmlnHhSwFSVnVfRcJOuYy18Cg5r7fhLuWUQtW8gjoWOnpuKC2ymWUrJv8yGWUq2caJAksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448170; c=relaxed/simple;
	bh=vD6ieySZaSMEmO/1InvJncJpiiRLBXkT9kG0v3hVgcQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sNy+hteBhyPYvrnbQE8RfJUNABRJpfk4DCZGEqT6bVXBA7UP+9CRjEgsueV+qlNSRzqtAjdrZfB3rJwvXR1mAJGy4gGkdmAMXfxnyjxRf8t3d6dexi2dwvupuUTfMzIjPIzVGssgpB/YVXfftXTQ3a+lXTCaDM6eByJDg2t4jb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cqw4BOs/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cqw4BOs/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746448167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vD6ieySZaSMEmO/1InvJncJpiiRLBXkT9kG0v3hVgcQ=;
	b=Cqw4BOs/SWlHorIPNZrYj0KdwdwaVXqne9YbMGv3az8Ms5JJBEQm0vRLEVqoWaonY+nOR1
	uPhplFlpJlebcWKeo117fSxHaOtyP6tzXGH92QWW+RbzKO+P8CfekRlvgblumcuauc3KRF
	bZDh8w3vKpy1hK9b6IfOSFHTnjC63+s=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-Wjg_YoSxPgecit7Mvo2P1w-1; Mon, 05 May 2025 08:29:26 -0400
X-MC-Unique: Wjg_YoSxPgecit7Mvo2P1w-1
X-Mimecast-MFC-AGG-ID: Wjg_YoSxPgecit7Mvo2P1w_1746448166
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-403527837b8so647464b6e.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 May 2025 05:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746448165; x=1747052965;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vD6ieySZaSMEmO/1InvJncJpiiRLBXkT9kG0v3hVgcQ=;
        b=G1aJSXYGsLe6QfDc6cqMfe1gJD7pSo8P8wGgqquBZRyVh4q5D/yGBKs/9PDdQwjSnT
         l6/CbpfDrnwhtDjdPX2kqnduBens2ew9z1DB+VojoMBjxXqmUQZs7unDi5LsPq1Zn7Is
         p6Hy+YC4Jd7curHWWgPi1L/OQGOy/K2THFZ6tYEj2VFxCMZGmPw3NVBlOJ0wvsRSbdP8
         EHvFShGqA8W0C2zR46/X7jRNU5EvhQTvayuLmQLAMREKhXaWW4h1T9UKziLPjV4SliWb
         tgm9MgMbQ4cMnFLAJBCD09QeYAmTmtBuyi+XogRtZIPD6SisFNnhXV7DW58EV0vacRAe
         JW+g==
X-Forwarded-Encrypted: i=1; AJvYcCUZHQ2SITvfb/rJQsn8tVckNq4oH5vQgdsAQtBCCrykSlkx1cr1Na37y7DZxwd96QgXIj/1SInkAlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbWYjkeKmbIP1MwIsDIxpOPq4Wo7tkwsmnz/qo3tSs2lZl3zrn
	nqMO2gnSIT61MfwaXzecV7XoMDlJu2+Lqtyj+WKHYbFqOoEb/6+mFL5neljCBkdwqyTp61Xentr
	Q4TRWAr+Hb+eR4FeuxShYplxyhOPc0I4kcoTOCmdoSsEjeZApix3VOf2e2Q==
X-Gm-Gg: ASbGnct2XmuI/SzJ1oEsYZhzu2uV1T88BWjuWWvU8u8/hm1eWVxl2MFug5ZGBc99BGZ
	6rmWBXqejO8daCOPibNiwieu2iY0xsWM9bzObBS024VKlXyDhJfOXQDhHUFbFCUiRbyvMI0kSM+
	1h3rr1kb38xN4byFkGyJCqW4kTW9RavwMexs7I5KNuz2KB56qzufscQ5968Vx/FI+kUQmdRKe9J
	YKI/cyC7RzsSoZdg8vENDQSRpHx2GjDb22tjoUqvM2ZU3U4tKNacAT9LVdI4IFPTr6mGSYi3dh4
	vGakxL/6XCYLhyUZo147/ZCATIBUPg3nOzupyscRXUub+VvuUUkjnj0r+rcH2g==
X-Received: by 2002:a05:6808:bc9:b0:403:290c:74a with SMTP id 5614622812f47-4035a58485bmr4120859b6e.20.1746448165716;
        Mon, 05 May 2025 05:29:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsD2ST4a3Uo0A6T5OxLxFk2/TlW1gU7xcpu3xPcTgRCcsS4BARvQL/mpn+SktWUmE5GCUgnQ==
X-Received: by 2002:a05:6808:bc9:b0:403:290c:74a with SMTP id 5614622812f47-4035a58485bmr4120847b6e.20.1746448165319;
        Mon, 05 May 2025 05:29:25 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4033d9c21e4sm1808879b6e.17.2025.05.05.05.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 05:29:23 -0700 (PDT)
Message-ID: <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
From: Laurence Oberman <loberman@redhat.com>
To: Dave Chinner <david@fromorbit.com>, Anton Gavriliuk
 <antosha20xx@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-block@vger.kernel.org
Date: Mon, 05 May 2025 08:29:21 -0400
In-Reply-To: <aBfhDQ6lAPmn81j0@dread.disaster.area>
References: 
	<CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
	 <aBaVsli2AKbIa4We@dread.disaster.area>
	 <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
	 <aBfhDQ6lAPmn81j0@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-05-05 at 07:50 +1000, Dave Chinner wrote:
> [cc linux-block]
>=20
> [original bug report:
> https://lore.kernel.org/linux-xfs/CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMm=
tr1oC=3DfOOgAQ@mail.gmail.com/
> =C2=A0]
>=20
> On Sun, May 04, 2025 at 10:22:58AM +0300, Anton Gavriliuk wrote:
> > > What's the comparitive performance of an identical read profile
> > > directly on the raw MD raid0 device?
> >=20
> > Rocky 9.5 (5.14.0-503.40.1.el9_5.x86_64)
> >=20
> > [root@localhost ~]# df -mh /mnt
> > Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% Mou=
nted on
> > /dev/md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 35T=C2=A0 1.3T=C2=A0=C2=
=A0 34T=C2=A0=C2=A0 4% /mnt
> >=20
> > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exi=
tall
> > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T=
)
> > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > fio-3.39-44-g19d9
> > Starting 1 process
> > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D81.4GiB/s][r=3D334k IOPS][eta
> > 00m:00s]
> > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D43189: Sun May=C2=A0 4 0=
8:22:12
> > 2025
> > =C2=A0 read: IOPS=3D363k, BW=3D88.5GiB/s (95.1GB/s)(2656GiB/30001msec)
> > =C2=A0=C2=A0=C2=A0 slat (nsec): min=3D971, max=3D312380, avg=3D1817.92,=
 stdev=3D1367.75
> > =C2=A0=C2=A0=C2=A0 clat (usec): min=3D78, max=3D1351, avg=3D174.46, std=
ev=3D28.86
> > =C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D80, max=3D1352, avg=3D176.27=
, stdev=3D28.81
> >=20
> > Fedora 42 (6.14.5-300.fc42.x86_64)
> >=20
> > [root@localhost anton]# df -mh /mnt
> > Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% Mou=
nted on
> > /dev/md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 35T=C2=A0 1.3T=C2=A0=C2=
=A0 34T=C2=A0=C2=A0 4% /mnt
> >=20
> > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exi=
tall
> > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T=
)
> > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > fio-3.39-44-g19d9
> > Starting 1 process
> > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D41.0GiB/s][r=3D168k IOPS][eta
> > 00m:00s]
> > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5685: Sun May=C2=A0 4 10=
:14:00
> > 2025
> > =C2=A0 read: IOPS=3D168k, BW=3D41.0GiB/s (44.1GB/s)(1231GiB/30001msec)
> > =C2=A0=C2=A0=C2=A0 slat (usec): min=3D3, max=3D273, avg=3D 5.63, stdev=
=3D 1.48
> > =C2=A0=C2=A0=C2=A0 clat (usec): min=3D67, max=3D2800, avg=3D374.99, std=
ev=3D29.90
> > =C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D72, max=3D2914, avg=3D380.62=
, stdev=3D30.22
>=20
> So the MD block device shows the same read performance as the
> filesystem on top of it. That means this is a regression at the MD
> device layer or in the block/driver layers below it. i.e. it is not
> an XFS of filesystem issue at all.
>=20
> -Dave.

I have a lab setup, let me see if I can also reproduce and then trace
this to see where it is spending the time

