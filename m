Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0217407108
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541510; cv=none; b=brSJSmUilkAFzAAV09Nlx/p25qMdrgI36khsmqem6ouBZG9HlLqXWSa1poC9X1OToWImGgFMCZ/fEkCOcpGlH9b22j9TmxU30erFMLhQNON7k7XO2XNKVBgHQhcgMa3Xd4AxS1GRQI/emLYu32u4TIRXJtvpqwvTeH4ibDs83kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541510; c=relaxed/simple;
	bh=rGits3iVDN2uSLCH3YJL5G1XiCQgI4k1qDSMlrjbmXs=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=eNFIbvm/8K1Iwo2eXPtpy6WidReQ4mz8FLPQe0YI/A3jhEesKGaseGYOvRDNPnWNLYZchT7Ghf2AINLQn3UVcAiFhnYo3U8RaVQJUaAY5LVZwtNLKoUmJsxL1FiPNDMgP0jLcgu1E5kkVU7tBbVmlZtvGcM1uNZgqzDk6tIC91s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDdmWwLP; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDdmWwLP"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cfcb045909so156301785a.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 09:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774541508; x=1775146308; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sj+/3N+1EiFUUi09HZbLl+3SzBXwsbtuOJa11mXtcZ4=;
        b=YDdmWwLPbgUWj9aSeVDoVIDcDEJrSwXfRViTS9OMdlAYBpC21eClfjg/Uoxge4s532
         XdoJIqGalKsnYTIhVhNCVbh8iVay3gnU+1GdnhUPxFBJPp3fA6RqSRKk+CzGJc8uy74q
         KX+niWs4RO0cNMsOVpE5L4OFTX3RLxSimENsVRUBTAoEcUUfAkfOwg9XbeVzX2yXyzha
         Lbc5nsYHTmGDTiInRRGSgyM6KeI1BSfz3lXAJk4SPz+9MZBy+mwjRNI3iuf6zb7d6zqR
         dYfDqGamOd9HTrzu4ryR6HZbBvVSCvdNbHI2g8p2sWR9lEYvmrZZVguj6BG3F52tQAbu
         gUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774541508; x=1775146308;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sj+/3N+1EiFUUi09HZbLl+3SzBXwsbtuOJa11mXtcZ4=;
        b=KpXuI/gXJthmjIea2LIpn5gWn4bTColh7wzz7en7zoxfOoXLz30Oskx0xtQm3VD8dP
         WybVad1yiXmPJz235Oudyc8eVY6tt2eK0OUGE/bN/mWkwrkGtY9rHa2tR+XdLnFoHxCh
         OmEzlsacZ60wsrPrKPqc0Wud4cvUjP4wXZwuwimFY3kmIWDyX91MfGNztLbqDSPAljVV
         ASIx5JMr2Xn+vlh4c4zNMAhgARqaO4MWmr0ZaHCLiOyYlH3Cm2v9JpsleYClaHTNxpfY
         GCTHDI6HJGLx5Oqar57JWivnSU8FbNHkQhS8o4AYHZkc0+0ct3jYrkj757W9eNFrVBgH
         dFhA==
X-Gm-Message-State: AOJu0YxeJ5jbD4qF7oG96yLhsCQ3YmvbYg2WTYgv8w/PqzMwi7ybQLkm
	xwwJ0EBIYvKXcRTOEuR2wQE5gk43wgSN0eAX0OKt99vx8UCGYan09REpQysK1+82jPc=
X-Gm-Gg: ATEYQzzbT6cYXnj3zgAbutoC5xNqmjEfQWbNOZo8G8tWAs+9jscwOE8KrcQ78NTiZLP
	d+llnXUj/Kiv+khEodCSDo82bRdO/b7AJj97qUGG8hhtDlhtwS5Q1ePBohcxIPUt9BucuaT7KeO
	LSA+DCBRswbAqtSNqmCgbIo/Dsy+xQ4q6OL8ysxWsiq+A6CkVubQhd2NWm2LyyymbzjE6Xvrq9r
	fIOU8ssR7pLd/pY5kHN1ImqMCfBcAMClGQsJDFYwtyHDWavpVDA84RINsByE2m7l4xHPy9IBloL
	1kGPRdGRzpbp1g7oLdc1Ch/z32mnu7e9Xs5G6kbiDePLEyhr+cSceApkkdMZsA3V0XvTj/iH3LP
	0LSYtTbbokFQ2MIBU78CTo3T4Iutsim0P9SAN8C1iD7okpU7kGold2oU85zafitsJA437x63Xar
	GvYlxDO35mj5Aw+QrDBEzzdXNfPFRTHOUVtmZzJEC/qjZxkCBTl86pXA==
X-Received: by 2002:a05:620a:4482:b0:8cb:4dc4:61d3 with SMTP id af79cd13be357-8d001040275mr1154397685a.45.1774541507436;
        Thu, 26 Mar 2026 09:11:47 -0700 (PDT)
Received: from smtpclient.apple ([104.39.146.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e4ceb8asm271189185a.29.2026.03.26.09.11.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2026 09:11:47 -0700 (PDT)
From: Shuangpeng <shuangpeng.kernel@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: [BUG] xfs: KASAN: null-ptr-deref in mutex_lock from
 xfs_qm_dqget_cache_lookup
Message-Id: <DDC07F0C-05D2-46B4-9815-E010749FB3DC@gmail.com>
Date: Thu, 26 Mar 2026 12:11:36 -0400
Cc: cem@kernel.org
To: linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3864.400.21)

Hi Kernel Maintainers,

I hit the following KASAN report while testing current upstream kernel:

KASAN: null-ptr-deref in mutex_lock from xfs_qm_dqget_cache_lookupp

on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/accda9655dd5a34182dc9a4018769184


I=E2=80=99m happy to test debug patches or provide additional =
information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   82.411853][   T23] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   82.412678][   T23] BUG: KASAN: null-ptr-deref in mutex_lock =
(./include/linux/instrumented.h:55 =
./include/linux/atomic/atomic-instrumented.h:4457 =
kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
[   82.413383][   T23] Write of size 8 at addr 0000000000000030 by task =
kworker/1:0/23
[   82.414187][   T23]
[   82.414450][   T23] CPU: 1 UID: 0 PID: 23 Comm: kworker/1:0 Not =
tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(
[   82.414458][   T23] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
[   82.414463][   T23] Workqueue: xfs-inodegc/loop0 xfs_inodegc_worker
[   82.414478][   T23] Call Trace:
[   82.414481][   T23]  <TASK>
[   82.414484][   T23]  dump_stack_lvl (lib/dump_stack.c:122)
[   82.414494][   T23]  print_report (mm/kasan/report.c:487)
[   82.414518][   T23]  kasan_report (mm/kasan/report.c:597)
[   82.414541][   T23]  kasan_check_range (mm/kasan/generic.c:? =
mm/kasan/generic.c:200)
[   82.414549][   T23]  mutex_lock (./include/linux/instrumented.h:55 =
./include/linux/atomic/atomic-instrumented.h:4457 =
kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
[   82.414601][   T23]  xfs_qm_dqget_cache_lookup =
(fs/xfs/xfs_dquot.c:813)
[   82.414609][   T23]  xfs_qm_dqget_inode (fs/xfs/xfs_dquot.c:1017)
[   82.414678][   T23]  xfs_qm_dqattach_locked (fs/xfs/xfs_qm.c:331)
[   82.414688][   T23]  xfs_qm_dqattach (fs/xfs/xfs_qm.c:371)
[   82.414696][   T23]  xfs_inactive (fs/xfs/xfs_inode.c:1453)
[   82.414733][   T23]  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1946 =
fs/xfs/xfs_icache.c:1992)
[   82.414743][   T23]  process_scheduled_works (kernel/workqueue.c:3281 =
kernel/workqueue.c:3359)
[   82.414755][   T23]  worker_thread (kernel/workqueue.c:?)
[   82.414775][   T23]  kthread (kernel/kthread.c:437)
[   82.414787][   T23]  ret_from_fork (arch/x86/kernel/process.c:164)
[   82.414822][   T23]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   82.414834][   T23]  </TASK>


Best,
Shuangpeng

