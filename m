Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCC3481B1
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746306270; cv=none; b=FqMHeHANPDLbD4UagHkBBZY1JVG3ZcHn7IJadpOOLtOmunrJ5IpW37GRzTxqpq7CQKU4D74530vKo+diP8oP+i1vz/5X0z7SiNgron2HcoxqAtvHUJodMo6I/GJepe2tKOd+Us5Z1aSyO3S3MvCSnvYA8yIwAbqCJLpv/H1SIco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746306270; c=relaxed/simple;
	bh=cAGLFGqSYZuVgD6HCQbcne5TJznbg/4R1cQtKOj+xlM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=mabr0GLGhr7Lzlxm/npugvtkKFrJZ5Y5ZDNCcFgHewresxSNQ9P4r0xsvpIgn8EVld4h7FYLfdigPZCKCBT0Jyn5ZESV7FmuB/J4qpn8PoNx4/EgvZVazy40hW+42EWe9eM+UsgMP0Rnm1Lfhc4DGC5iJDBHKE+pNfDCO1XzPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4by4skG; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4by4skG"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e728cd7150dso2358911276.3
        for <linux-xfs@vger.kernel.org>; Sat, 03 May 2025 14:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746306267; x=1746911067; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=br3AFfEUnRj5fngutK9i/jnbo6o4VEmVTfhs6OGnjfY=;
        b=Z4by4skG8VV5yg3Svgc2yoh2DR4olniP0CpKylUk9hfcOhxZDns/2v1WB0TZwLN3Gt
         0/8WufA5J+CFdUzO+LbzSFo4PdgzHPs4UG8g2UEzTs+Hcp+zKiUNd+EuiMoTDBExS+ue
         uc8ibMqHZbeQEzSl/gdaUpqUQM881d0Whcy4PWnyKxNVeYQGb08JFDnCvithzP46l9do
         8sEy7xzU48icenwgkwXOfKY0FIEQ/d2Lhy5CbV90TehcPa95JALDO4hxP+uuldvnpjfk
         yuzFUFSyzFB2ggcEoRNIC99TrBqxNm+cxDE2LlmknWQQHElyvzaz2FlsUFndorPebj3Y
         OfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746306267; x=1746911067;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=br3AFfEUnRj5fngutK9i/jnbo6o4VEmVTfhs6OGnjfY=;
        b=ZVVvUQKDOxAwnH+7XAMUW2VJd3zMnUIDaWIfUuPuSsFxvpbiFNw1I+1vuNTCNetv4M
         2nrcp67WkW6kww6OYD7MVWjc8F5ZrHTHf4Vvnix6kveNrZDWVTLNwg0PkLWCn/ApEDep
         hNvn/o6mmxVMRXLcyIUa5+yNaElOk5R/sw03AyD/n4aSRtynbU+RDrLLLnPTvnhlFspq
         PwD9+/fj9Qog0yyWvMixqgZP4NYjgBw7PPZCYfInbE1JRfL8Q7dwimSNaUY3js7Sh/Fg
         MwzJQ9NzNbQIZusnWMRFkhGKMs7xTrQD1b38LZxiCpln2WrTEtQiyXoescJ+cZHhVbEl
         RcCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPxXnPx0LGV6bEic9nzENkdniX8s4HpCk8TELsDPrLGkgih/Ezx3YwVsGQWo+9kpKY1JR1/vEh1rU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVGdDTx0ZzQGhqUBOc48oRV62QRA3K0PHjiM32+dit1iznhTGp
	Hv7jFtUg//2b+niwmhkDb1wMz47skP7H53yEy5J2nAC2Ox947ui4sHbh76/viTLCEqH+RIX+LuA
	CVus7PCdcKyiz7i+D+EvASIsjimBqzELH
X-Gm-Gg: ASbGncuUn8euAZSLRRaz+571pHC67THBOOUpgEqbp+zTJ0fMVvKQuyoD1kj3xwMPAAw
	eazRUIUofaokG5yUnSwBKpg+Rmx2Rs1cfwpCYeFTEP5oX18pE7DSfP0nyPeSKijbDQbya89+CWi
	WSX52EM+4rmxF4ng9iaVXPNWU=
X-Google-Smtp-Source: AGHT+IHjWMwIpVGk5acPczMKOLon4kb4Of7gY7UH90xYcJMj3Qz1mxC67hPh9/VUlSLK8VvSInnDjskvLmOwYFf1MzM=
X-Received: by 2002:a05:690c:6885:b0:6fb:b2c0:71da with SMTP id
 00721157ae682-708eaf6ebd3mr30699717b3.36.1746306267614; Sat, 03 May 2025
 14:04:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sun, 4 May 2025 00:04:16 +0300
X-Gm-Features: ATxdqUFr-5CKZ9PwkiQVFmKolcwZrtyZDYs9OA0G7N565qFChOI4t3qYlcqjGec
Message-ID: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
Subject: Sequential read from NVMe/XFS twice slower on Fedora 42 than on Rocky 9.5
To: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

There are 12 Kioxia CM-7 NVMe SSDs configured in mdadm/raid0 and
mounted to /mnt.

Exactly the same fio command running under Fedora 42
(6.14.5-300.fc42.x86_64) and then under Rocky 9.5
(5.14.0-503.40.1.el9_5.x86_64) shows twice the performance difference.

/mnt/testfile size 1TB
server's total dram 192GB

Fedora 42

[root@localhost ~]# fio --name=test --rw=read --bs=256k
--filename=/mnt/testfile --direct=1 --numjobs=1 --iodepth=64 --exitall
--group_reporting --ioengine=libaio --runtime=30 --time_based
test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=libaio, iodepth=64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=49.6GiB/s][r=203k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=2465: Sat May  3 17:51:24 2025
  read: IOPS=203k, BW=49.6GiB/s (53.2GB/s)(1487GiB/30001msec)
    slat (usec): min=3, max=1053, avg= 4.60, stdev= 1.76
    clat (usec): min=104, max=4776, avg=310.53, stdev=29.49
     lat (usec): min=110, max=4850, avg=315.13, stdev=29.82

Rocky 9.5

[root@localhost ~]# fio --name=test --rw=read --bs=256k
--filename=/mnt/testfile --direct=1 --numjobs=1 --iodepth=64 --exitall
--group_reporting --ioengine=libaio --runtime=30 --time_based
test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=libaio, iodepth=64
fio-3.39-44-g19d9
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=96.0GiB/s][r=393k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=15467: Sun May  4 00:00:39 2025
  read: IOPS=390k, BW=95.3GiB/s (102GB/s)(2860GiB/30001msec)
    slat (nsec): min=1111, max=183816, avg=2117.94, stdev=1412.34
    clat (usec): min=81, max=1086, avg=161.60, stdev=19.67
     lat (usec): min=82, max=1240, avg=163.72, stdev=19.73

Anton
