Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8017E5733C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Feb 2024 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503998; cv=none; b=DtPKzu7MT4mBInX7XTSxM2MQzZ7SDngjtbKHZLq0+wCnJXcDO40PR93wr6RZx+ENX0lVjJdVG1903ClkahIrXWr39BrpwB3zA5VIygSAXcHyuaxZTR5FIWKrX8vJqt36tB7Hj+NLcWoF/uqlpxo6pJfliqYiGEWiNuwctJzaH0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503998; c=relaxed/simple;
	bh=L1EoXp84CZZjWWAK0FEc3/78wpS70xW9ja7KKjAkwKI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=pN+0GMYL3oNJnMqh74XnAap8zVWOsiFIgJ8SdcUCSzQYpbLG0cfhp8O4scstVlETMt/fK8GivrgloNa/n0z2+5NmmiCKRtDJFKCy9pKAwMiqnVOK8gtJd8Fpub7OfswH70kV/hS9imMCDr7HUD9X6OqbR0m22HBDLhcDaHchJA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu; spf=pass smtp.mailfrom=soe.ucsc.edu; dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b=pbNkbAss; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b="pbNkbAss"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4c0232861afso346889e0c.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Feb 2024 10:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soe.ucsc.edu; s=soe-google-2018; t=1707503995; x=1708108795; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q8UZbsUZBIflUDG6IMiQTufVfGQTgshmPti6CUTtVQU=;
        b=pbNkbAssF6vfrN62iNg0eDljOT2iEhLQtcw3Nc49uXSYLOLWOw8gYOkkrZ8bsFvCuX
         J4ZegEDQQOimvtUM7qvFKaVHx4sBpnclpoZKpJEmBhb+u6R0HPHg6OlKfLoABnZfpvkR
         34v4Z9rKI1MfOem/w7zWh7Jx61rVLtWuZNgNu8H2ErRkGK14c3Kt61zxZJpBUro9gf9t
         uDoplzGTv7kHmzQceC613uTaCF86fY5Xfkq1/FhIFmJfpebwRu1ym/b5qtvN3OIwzmE7
         GQQUo6cQLwWSyJ01iEiOvf1q/IXQOPfrcdWPX3YuqLs8Qsm/QZHGVBsKf4RLEP9cyC7J
         D+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707503995; x=1708108795;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q8UZbsUZBIflUDG6IMiQTufVfGQTgshmPti6CUTtVQU=;
        b=NNtMV7YWJV+XBg8eBSpijmRoh3+chkqQ0/RynaoOgmMJXU3it/NMoic+GnmITEDWL3
         /1aS6GKMD+WtAsUWZHb0wok5n7YzDGP+J4KGO6NDp2px6kIvp1NJpj2bkj6eNTp3aloE
         t3nqFqixDx7es7XkJucusGEu3K44PaSRiWA95Ya3StW2wMoowPyxRbc+8xA0KKe9QDxC
         BXtIhMrNLRWbpQhoRWvxqtCVxwPMK1ThR6ugl91+xMIy83jWGf54aYjOoWo13JeaCpSQ
         BmMZeNOfN0BUN3xZ+274FoWtwVFWr9R1IPSMNFgTEysrcuX3Uit4r5yJAv7uI/Ml3Y/a
         ezFQ==
X-Gm-Message-State: AOJu0YyNjfwVC+QJUqaPnHMI+u2DUiFo8A9pZlbrg+5ZPP3xLa/UuUjV
	+yL/DjHEWIRz5yEV+Rgv7aRFddmZaoBpG8RldGVsYDKXjiG5SCwHwrydENrYyNfrwjo3kwwdk+X
	g8uXSWUqKxshgMC/A/UwjMoFlVmtUjKrHiQc3ZoK1B7iqydxrR74=
X-Google-Smtp-Source: AGHT+IHEoo3OQDI8aWx/5qWkAbfoTExt8YrluCJjfPKgdK1Aua4Z/Oo0VvksazxzD40JzO27ss2r3rpwnyiCQG2SPXk=
X-Received: by 2002:a1f:d647:0:b0:4c0:1918:27de with SMTP id
 n68-20020a1fd647000000b004c0191827demr198967vkg.16.1707503995157; Fri, 09 Feb
 2024 10:39:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jorge Garcia <jgarcia@soe.ucsc.edu>
Date: Fri, 9 Feb 2024 10:39:44 -0800
Message-ID: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
Subject: XFS corruption after power surge/outage
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

We have a server with a very large (300+ TB) XFS filesystem that we
use to provide downloads to the world. Last week's storms in
California caused damage to our machine room, causing unexpected power
surges and power outages, even in our UPS and generator backed data
center. One of the end results was some data corruption on our server
(running Centos 8). After looking around the internet for solutions to
our issues, the general consensus seemed to be to run xfs_repair on
the filesystem to get it to recover. We tried that (xfs_repair V 5.0)
and it seemed to report lots of issues before eventually failing
during "Phase 6" with an error like:

  Metadata corruption detected at 0x46d6c4, inode 0x8700657ff8 dinode

  fatal error -- couldn't map inode 579827236856, err = 117

After another set of internet searches, we found some postings that
suggested this could be a bug that may have been fixed in later
versions, so we built xfs_repair V 6.5 and tried the repair again. The
results were the same. We even tried "xfs_repair -L", and no joy. So
now we're desperate. Is the data all lost? We can't mount the
filesystem. We tried using xfs_metadump (another suggestion from our
searches) and it reports lots of metadata corruption ending with:

Metadata corruption detected at 0x4382f0, xfs_cntbt block 0x1300023518/0x1000
Metadata corruption detected at 0x4382f0, xfs_cntbt block 0x1300296bf8/0x1000
Metadata corruption detected at 0x4382f0, xfs_bnobt block 0x137fffb258/0x1000
Metadata corruption detected at 0x4382f0, xfs_bnobt block 0x138009ebd8/0x1000
Metadata corruption detected at 0x467858, xfs_inobt block 0x138067f550/0x1000
Metadata corruption detected at 0x467858, xfs_inobt block 0x13834b39e0/0x1000
xfs_metadump: bad starting inode offset 5

Not sure what to try next. Any help would be greatly appreciated. Thanks!

Jorge
