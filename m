Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422427990C;
	Tue,  6 May 2025 11:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746529432; cv=none; b=YZQ4yNkf0q0ez/wjUg8Qjina6bYxr+Zp1/5up/37WyCWuNZEduBue6C0aT4j5W1uE+X9jwng6kOuhv0d9Ijb8Qc7rV0kU+OMW52OVQjih1mzr/1/F50xc/z7bKXOFZVkeWMG1+0SZ4BgSwEeCUOig3ery/AlzfO97mlOn+ynMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746529432; c=relaxed/simple;
	bh=UN2zra4dfwaKGZx8R/zfvn64KIyswWSXwarj6aJhnt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i1CUyt2vzEj6CYyRqcoLunXCb0AgR0/2Cn39kdG2e6OIHGS6iEP8IblFNIQpK0mxwX71pyqaMmLRWPXLFWCfYrrakeBwZd5v/HxzFTF74a6HocZOFfzXE2Ng2I2il9WZ+9agyL69HVTzlS6dzXpsa3lkZl8K3OJyK7qnvEo03k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjXHIT2e; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjXHIT2e"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e6582542952so4265812276.3;
        Tue, 06 May 2025 04:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746529430; x=1747134230; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5cIxifLxpzCeD2CSk8rVMToQM4uWduk0d+Z1uu1DHY=;
        b=IjXHIT2efX7kmbJLYfFL7dtjr6i9epTimeIQNMqyWhZ2DbsKH8RzDMKtAIdSq8vAOT
         cm7Chs+H3fiPFoE8FSth5Y+cwg5zRiHGWf4H2E4CxJNu7tl7CQoKsumZbD1paQtZkFls
         Nh/kIfAQnA9/QSQgn/ZMjjbwlU+NZy0ZsQByK44p+ihKAP4hIhZd8I8R8FfCjCyIaVQy
         Fma9i2AQEdlrQ03644UNKJm5KIm8qS0lWTJoS0l3Oh53erjPo+EMBZ7ywWmD2O4Y/PND
         VwuqpfcgTvLzlIfKS1KM0FDbDMJACSopFKBukRDUnxFMnJKcmmP2ydM3/XFI5Nzs2241
         18Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746529430; x=1747134230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5cIxifLxpzCeD2CSk8rVMToQM4uWduk0d+Z1uu1DHY=;
        b=Yj3beQXpbnkJeprKn3ZFMhvNMLq9HrxJ+9/642A9KakJcvFy7WCpcoiNvpFDQg2hyy
         MDc8kdRk2JRJz7coZ6tYUmwCrErz0IsyPn5kHAITkA5fDr3J5xf9buMQqnHQg1mmVejY
         FDxXFrVPg/oEEtqddwfTno6dbxqbwGCDA2Up1ZfSsd3Jt5TAP+yodpquSo7whDiPK6gy
         GJ28/LBROVX0WKgccssPZ/AsWuM50jsosSU0hx02JOLKbCFdu9YVWpVUm4zfrGjfPLCr
         nmshDchjAvkRexzj1K+dWh1LBIfXKyDnSBcVYzM2jdC1uqQ0105VWSSYt/kA79ytUR5w
         TIaw==
X-Forwarded-Encrypted: i=1; AJvYcCUbICIWfaAjqSARCkFBgeKxZoAMoIwhqbylUJUEBfBKx2xTskKNtpGLgtVGLnYYwk3Q0DRSCE+iT+eR@vger.kernel.org, AJvYcCWhPqFYYTLJc5hSIu65BaSb0YyxXOP+BiVduVDW2rV7ux64YQz43xbsaSrm2OtzU2pI8ZrQ6GPpVFnhoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBIFPdI0cPZN6JC1g8vajkYtmveNTJHCxgc3xDjHpUkQzvqWtX
	m86a6x6zQxFi7pizseOou4pFewsbq38sRQg6gZNeudbxIVkEL2oDNX2cf8xdGUU4Ie4I1zjeArp
	EU2mXDnXQ9nrK3r5rDq1zwhwY7S8=
X-Gm-Gg: ASbGncujAs6y7gjsDJDa4HOfe7bWnGw3juYwnKG90RAk4HMORQrXr9hPNqJDl5ATr74
	qLAFPkNim83SDoMG77tC1C93fnbinSgvOjT4z3WHsBkUKkYFp0v300mOU66K/39GAse8VxwfwJp
	M43EHzrLwHn8QZMkROQO2vGhs=
X-Google-Smtp-Source: AGHT+IFhiv0YQSilHmty/QdAAAo648u/1DptovoPkVdAkzNPeDxQrGICMPfCoCCTzU5HCJjUYoNmiKgRrfx3Dshb/2A=
X-Received: by 2002:a05:6902:1691:b0:e6d:f160:bbdf with SMTP id
 3f1490d57ef6-e75c09a0b84mr3520072276.36.1746529429729; Tue, 06 May 2025
 04:03:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area> <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
 <aBfhDQ6lAPmn81j0@dread.disaster.area> <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
 <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com> <aBlCDTm-grqM4WtY@dread.disaster.area>
In-Reply-To: <aBlCDTm-grqM4WtY@dread.disaster.area>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Tue, 6 May 2025 14:03:37 +0300
X-Gm-Features: ATxdqUGRPpTDRcpadhlooEN_bho35-eXg5BG8APuEFdkYs60OQyxKdR4W39zMvw
Message-ID: <CAAiJnjo87CEeFrkHbXtQM-=+K9M8uEpythLthWTwM_-i4HMA_Q@mail.gmail.com>
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
To: Dave Chinner <david@fromorbit.com>
Cc: Laurence Oberman <loberman@redhat.com>, linux-nvme@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> So is this MD chunk size related? i.e. what is the chunk size
> the MD device? Is it smaller than the IO size (256kB) or larger?
> Does the regression go away if the chunk size matches the IO size,
> or if the IO size vs chunk size relationship is reversed?

According to the output below, the chunk size is 512K,

[root@localhost anton]# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Apr 17 14:58:23 2025
        Raid Level : raid0
        Array Size : 37505814528 (34.93 TiB 38.41 TB)
      Raid Devices : 12
     Total Devices : 12
       Persistence : Superblock is persistent

       Update Time : Thu Apr 17 14:58:23 2025
             State : clean
    Active Devices : 12
   Working Devices : 12
    Failed Devices : 0
     Spare Devices : 0

            Layout : original
        Chunk Size : 512K

Consistency Policy : none

              Name : localhost.localdomain:127  (local to host
localhost.localdomain)
              UUID : 2fadc96b:f37753af:f3b528a0:067c320d
            Events : 0

    Number   Major   Minor   RaidDevice State
       0     259       15        0      active sync   /dev/nvme7n1
       1     259       27        1      active sync   /dev/nvme0n1
       2     259       10        2      active sync   /dev/nvme1n1
       3     259       28        3      active sync   /dev/nvme2n1
       4     259       13        4      active sync   /dev/nvme8n1
       5     259       22        5      active sync   /dev/nvme5n1
       6     259       26        6      active sync   /dev/nvme3n1
       7     259       16        7      active sync   /dev/nvme4n1
       8     259       24        8      active sync   /dev/nvme9n1
       9     259       14        9      active sync   /dev/nvme10n1
      10     259       25       10      active sync   /dev/nvme11n1
      11     259       12       11      active sync   /dev/nvme12n1
[root@localhost anton]# uname -r
6.14.5-300.fc42.x86_64
[root@localhost anton]# cat /proc/mdstat
Personalities : [raid0]
md127 : active raid0 nvme4n1[7] nvme1n1[2] nvme12n1[11] nvme7n1[0]
nvme9n1[8] nvme11n1[10] nvme2n1[3] nvme8n1[4] nvme0n1[1] nvme5n1[5]
nvme3n1[6] nvme10n1[9]
      37505814528 blocks super 1.2 512k chunks

unused devices: <none>
[root@localhost anton]#

When I/O size is less 512K

[root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D48.1GiB/s][r=3D197k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14340: Tue May  6 13:59:23 2=
025
  read: IOPS=3D197k, BW=3D48.0GiB/s (51.6GB/s)(1441GiB/30001msec)
    slat (usec): min=3D3, max=3D1041, avg=3D 4.74, stdev=3D 1.48
    clat (usec): min=3D76, max=3D2042, avg=3D320.30, stdev=3D26.82
     lat (usec): min=3D79, max=3D2160, avg=3D325.04, stdev=3D27.08

When I/O size is greater 512K

[root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D1024k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T=
)
1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D63.7GiB/s][r=3D65.2k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14395: Tue May  6 14:00:28 2=
025
  read: IOPS=3D64.6k, BW=3D63.0GiB/s (67.7GB/s)(1891GiB/30001msec)
    slat (usec): min=3D9, max=3D1045, avg=3D15.12, stdev=3D 3.84
    clat (usec): min=3D81, max=3D18494, avg=3D975.87, stdev=3D112.11
     lat (usec): min=3D96, max=3D18758, avg=3D990.99, stdev=3D113.49

But still much worse than with 256k on Rocky 9.5

Anton

=D0=B2=D1=82, 6 =D0=BC=D0=B0=D1=8F 2025=E2=80=AF=D0=B3. =D0=B2 01:56, Dave =
Chinner <david@fromorbit.com>:
>
> On Mon, May 05, 2025 at 09:21:19AM -0400, Laurence Oberman wrote:
> > On Mon, 2025-05-05 at 08:29 -0400, Laurence Oberman wrote:
> > > On Mon, 2025-05-05 at 07:50 +1000, Dave Chinner wrote:
> > > > So the MD block device shows the same read performance as the
> > > > filesystem on top of it. That means this is a regression at the MD
> > > > device layer or in the block/driver layers below it. i.e. it is not
> > > > an XFS of filesystem issue at all.
> > > >
> > > > -Dave.
> > >
> > > I have a lab setup, let me see if I can also reproduce and then trace
> > > this to see where it is spending the time
> > >
> >
> >
> > Not seeing 1/2 the bandwidth but also significantly slower on Fedora42
> > kernel.
> > I will trace it
> >
> > 9.5 kernel - 5.14.0-503.40.1.el9_5.x86_64
> >
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.7GiB/s (15.8GB/s), 14.7GiB/s-14.7GiB/s (15.8GB/s-
> > 15.8GB/s), io=3D441GiB (473GB), run=3D30003-30003msec
> >
> > Fedora42 kernel - 6.14.5-300.fc42.x86_64
> >
> > Run status group 0 (all jobs):
> >    READ: bw=3D10.4GiB/s (11.2GB/s), 10.4GiB/s-10.4GiB/s (11.2GB/s-
> > 11.2GB/s), io=3D313GiB (336GB), run=3D30001-30001msec
>
> So is this MD chunk size related? i.e. what is the chunk size
> the MD device? Is it smaller than the IO size (256kB) or larger?
> Does the regression go away if the chunk size matches the IO size,
> or if the IO size vs chunk size relationship is reversed?
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
