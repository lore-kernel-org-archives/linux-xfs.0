Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B96D1494D9
	for <linux-xfs@vger.kernel.org>; Sun,  4 May 2025 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746343392; cv=none; b=eFnD+H3DZqfFtaz/1Rezyn9TD9h4lz17g+Sld4stc5lfFLLi39YS7eE0RpCJx9BEmNerFu0/h0dbzI1JRT55nKV1l40bQupSHiUPjtUte7jzxug/Reu+x3MwYnbISErJ1GbaW477vjHgWl9MzSlXTQ5PwjYu5W1a2hKoOifDml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746343392; c=relaxed/simple;
	bh=xYxz0azzfXWxFCzUkqfz/f6PJEmbFO81UXC9eq5hpwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FYitCfrWg6b0qc36OgvMmiPi+nqneytTiTi+P5zE34stZUORUteX3W6YdlwCPu+i04RchN7Pk1leUeE2xXlX3XbVey582DbbCrz3RCr5HgwlessUzQfY0ZjjknqAtPl3ACXM6SVrtlBMQeSYWGeLQftqdh2UUDsougbtskzTW6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5Om8Tjx; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5Om8Tjx"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6fece18b3c8so31953217b3.3
        for <linux-xfs@vger.kernel.org>; Sun, 04 May 2025 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746343389; x=1746948189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1NwuG/e4xVsHdGCaYu3EUBwEEpbWOPwWienDO7qyI8=;
        b=N5Om8Tjxhofsu0bRHe93MwH3ZiCyiOKEUPg3NgTpfUt1h/1xKbfXGb0j4no7Dk8UJM
         gsCfBRUK8aW0Zbw2jixEwfbF8UE2jypdtMI9NAbxei8d9Hx3JriW7VnObWbBSYqN64LK
         AMJ5NxyOpe4QvRv03NLD5PEOTvbfg98BC209h/ZBGSD31gBgYtS8G5+S1Cd5gIDSVkQC
         lKF3wlr4JrDDzGqP+3bVN5dbWD4WootXQ/kMlT6fVeetydrtKyQb7FJEnk3ayKOlPp6T
         XCX9rNpgh6PXR3b2FaoOQ6a3Fl5723NcnMKw6YnnXUn9KuO17KTsug0XOx/WQXhQz7/5
         uLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746343389; x=1746948189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1NwuG/e4xVsHdGCaYu3EUBwEEpbWOPwWienDO7qyI8=;
        b=j28NPhlSW3ip86ktQlax1HkzGMl1G3FjghK5EyQe2w4Zt+a3JeSV2PGl8oq8ffP+vv
         IQW0T9B9gHdQHXpW0wloyPONSPas921KMdSIbYg8DUir4ubA/YdMgKV+Fcq06cbegOm+
         t+m/1/EZqQ/T9eOjWpxEwGFSF6pZbjIomB/dbEoP7twns/tbAGGXxflBGxI0rqFdns7d
         6KltVSDTEcC+wn/4CIaKIHorchlKUnNotLc0Tino4qukelmfKlIYGTbXIWlSma6ISf33
         o9X3D6ajuJqfLP5hj8OURCX0KBrg5ok2gCZUjI0KAGpJhEFUhj5NmSfhpPmNrObCqoRL
         w+fg==
X-Forwarded-Encrypted: i=1; AJvYcCVe6In03M/DsYYHnZKlnBinhCeobBIM+9jijCgFbMewJ8gxFOnMQnqRhZoG1BisoY/QdLzptQVyDrw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1zvdjBFX0Lq1ea97nP2oO/otb4JnwWO7WoQtrIAAMd6h84qNO
	CofqR8KsafkqP99g8/eHF+Kv7H5qghosuJH78A/a6DQHCFvDF32gyraA2wcfHOr5VL+gPY73rCx
	4rC2UWuIurB/ADHSLHbv9veGMAOY30hRS
X-Gm-Gg: ASbGncsJWPRnFAHkz7SYMf/wsAEschPsenklOS4NJAFn1uzxD7w0CnCMbZVXYSLj6bZ
	olx6pl7xmdr69kibNAHfbIO6aPQPs9dm3Xwnin70w8caUB3rBf00WOq4FgzZSHx+h9mKnsT9nSU
	TuUwiUbo0+ngwuOIN2SOGZEtQ=
X-Google-Smtp-Source: AGHT+IEAwS2M8BjFUUCYCsFeM+hsNE3mh+qrGuGCxsuJvXJpwQsJ1i0nwL10/qyygP5cPmYT3g7jz+LvmQvXIC3EEGs=
X-Received: by 2002:a05:690c:6e0d:b0:708:3dee:d76e with SMTP id
 00721157ae682-708eaf01991mr37566527b3.22.1746343389158; Sun, 04 May 2025
 00:23:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area>
In-Reply-To: <aBaVsli2AKbIa4We@dread.disaster.area>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sun, 4 May 2025 10:22:58 +0300
X-Gm-Features: ATxdqUHb2MJMovNmfI4rEyQJRRdEB_WPt7NXFPP2gOUuPbI6O4-CFxmT27fJsGM
Message-ID: <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> What's the comparitive performance of an identical read profile
> directly on the raw MD raid0 device?

Rocky 9.5 (5.14.0-503.40.1.el9_5.x86_64)

[root@localhost ~]# df -mh /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/md127       35T  1.3T   34T   4% /mnt

[root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D81.4GiB/s][r=3D334k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D43189: Sun May  4 08:22:12 2=
025
  read: IOPS=3D363k, BW=3D88.5GiB/s (95.1GB/s)(2656GiB/30001msec)
    slat (nsec): min=3D971, max=3D312380, avg=3D1817.92, stdev=3D1367.75
    clat (usec): min=3D78, max=3D1351, avg=3D174.46, stdev=3D28.86
     lat (usec): min=3D80, max=3D1352, avg=3D176.27, stdev=3D28.81

Fedora 42 (6.14.5-300.fc42.x86_64)

[root@localhost anton]# df -mh /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/md127       35T  1.3T   34T   4% /mnt

[root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D41.0GiB/s][r=3D168k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5685: Sun May  4 10:14:00 20=
25
  read: IOPS=3D168k, BW=3D41.0GiB/s (44.1GB/s)(1231GiB/30001msec)
    slat (usec): min=3D3, max=3D273, avg=3D 5.63, stdev=3D 1.48
    clat (usec): min=3D67, max=3D2800, avg=3D374.99, stdev=3D29.90
     lat (usec): min=3D72, max=3D2914, avg=3D380.62, stdev=3D30.22


Anton

=D0=B2=D1=81, 4 =D0=BC=D0=B0=D1=8F 2025=E2=80=AF=D0=B3. =D0=B2 01:16, Dave =
Chinner <david@fromorbit.com>:
>
> On Sun, May 04, 2025 at 12:04:16AM +0300, Anton Gavriliuk wrote:
> > There are 12 Kioxia CM-7 NVMe SSDs configured in mdadm/raid0 and
> > mounted to /mnt.
> >
> > Exactly the same fio command running under Fedora 42
> > (6.14.5-300.fc42.x86_64) and then under Rocky 9.5
> > (5.14.0-503.40.1.el9_5.x86_64) shows twice the performance difference.
> >
> > /mnt/testfile size 1TB
> > server's total dram 192GB
> >
> > Fedora 42
> >
> > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > --filename=3D/mnt/testfile --direct=3D1 --numjobs=3D1 --iodepth=3D64 --=
exitall
> > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T=
)
> > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > fio-3.39-44-g19d9
> > Starting 1 process
> > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D49.6GiB/s][r=3D203k IOPS][eta 00m:0=
0s]
> > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2465: Sat May  3 17:51:2=
4 2025
> >   read: IOPS=3D203k, BW=3D49.6GiB/s (53.2GB/s)(1487GiB/30001msec)
> >     slat (usec): min=3D3, max=3D1053, avg=3D 4.60, stdev=3D 1.76
> >     clat (usec): min=3D104, max=3D4776, avg=3D310.53, stdev=3D29.49
> >      lat (usec): min=3D110, max=3D4850, avg=3D315.13, stdev=3D29.82
>
> > Rocky 9.5
> >
> > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > --filename=3D/mnt/testfile --direct=3D1 --numjobs=3D1 --iodepth=3D64 --=
exitall
> > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
> > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T=
)
> > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > fio-3.39-44-g19d9
> > Starting 1 process
> > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D96.0GiB/s][r=3D393k IOPS][eta 00m:0=
0s]
> > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D15467: Sun May  4 00:00:=
39 2025
> >   read: IOPS=3D390k, BW=3D95.3GiB/s (102GB/s)(2860GiB/30001msec)
> >     slat (nsec): min=3D1111, max=3D183816, avg=3D2117.94, stdev=3D1412.=
34
> >     clat (usec): min=3D81, max=3D1086, avg=3D161.60, stdev=3D19.67
> >      lat (usec): min=3D82, max=3D1240, avg=3D163.72, stdev=3D19.73
> >
>
> Completely latency has doubled on the fc42 kernel. For a read, there
> isn't much in terms of filesystem work to be done on direct IO
> completion, so I'm not sure this is a filesystem issue...
>
> What's the comparitive performance of an identical read profile
> directly on the raw MD raid0 device?
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
