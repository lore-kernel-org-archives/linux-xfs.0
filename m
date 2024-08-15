Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7F17C9A7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723724764; cv=none; b=UUTUlOxYl6daqMRkQnK1ymBZYySQ75wXs+RZpmIjuAXZwek+pPu1q9HkxESxqqz0SmDN++h6cojO9Dbi/MeJA6mUCTnlOWgkKeXgDdbCpnNhF+U6HqEEtnHl3igsG/tBceFAuDZLyXjtXaX5q1LqclZblJplejbzjQUnx9wR58c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723724764; c=relaxed/simple;
	bh=0im/Qykv7c1iy0qA7z6aX1F3OLwdCBwKdNNBPWl0vBc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Z3kqIo66G2aTzNEgiwppWKVUjIo0yPC3KCitSc8mbC7jZc1eXzkw1jfSJi5lsLMP9y7YK7RJsq9/1cWuk5sg9rIAxKX4aGO24O9anvZWzLDnOzMvNFS/aLEF+CtWdNO9ACq6iAxxfknILYCCp6uKp99/stxCyqEuQFV5XQwSu+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuHtTuj5; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuHtTuj5"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52efdf02d13so1333223e87.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 05:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723724760; x=1724329560; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=koc1IsnC0GAKbAZNMmwiEPVpZsMn8AiFFHVBL5y7yDw=;
        b=DuHtTuj5gJ9hbqOymXTBqRhH+JPkXKqH7Iv91RbYkAC6Gsswv5bTMI99T90hLGhZpu
         bH4Qxxvflc4aHwonHvtYt3Mkg/HSVZrz2vMMYDhtl1LkbMmhaI2uV0nrAvQpGC9saUTc
         1G/EUsGYLvI1tr2rbU1Mt7wdrD32zxPha5Mh+oLRjKbOPq80Wdj+WNx4wVoAtX7yZQC6
         8Gci10ehXIZqHDgskJLrLv3M+deuFCllY9FpqnRGKZpVB+LQsLnYrcPwJ6YvaPYP2roS
         Dx+A2CnJPx/zIyX7abWr6T0myfGpvz62LGA3LlW/Vnbxd8acPTkd1gIS529PXWHIePQV
         9qSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723724760; x=1724329560;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=koc1IsnC0GAKbAZNMmwiEPVpZsMn8AiFFHVBL5y7yDw=;
        b=FwLsd3OX7J1nCV9VnBUp64FlmQXhIpLVMhMy84N5LBdK7NjbjTFtUprNYHSbgZy1Uh
         ldI6l/dc/eKWgOyLjok/FBc2I+uOqR07201QDvt39tO+gxMK8MT8gDxJkZSEDVzrXl7p
         BO94geCXWf1/BLIRasDtJZuH0npSRtybYMs2oTA1+qE39LW4aI07CYOe2kDzUoZHa0o0
         rjraPW5PvvrJdGqI5KAHYUkyGNBDCiEKZHUrog/3n4NqSEbMAjMyxaXWi+cpb4NC3iPo
         SAdH9jKlrOp+Y5s1lgumZlGT507o9QVgPo8XfXiMdoJ67rxoPyOd335l9zJneCj5OZK7
         Dn5A==
X-Gm-Message-State: AOJu0Yw4MDvvLsjPnvz9TARveCHdKGT9VHu+/lglJFKnbWJneGwLLXhx
	UBvdoOubBTMlECFrb0IaBo9WbKQIF4JqIzvW1Dz77CxKA5mOCUzLSOCTKVEUV6NnVHMU+DWUSOk
	07GNTi02ClTPOagilLVFmL47etN+S1jbM
X-Google-Smtp-Source: AGHT+IH120qMS4736ZFJPJtgEQ2TEdv1n3BUnoknUH7iEMYY9dPd0Uy8PAXwbjiDt1s6Oul8AhoPApLNyxvsscoILu8=
X-Received: by 2002:a05:6512:3a8f:b0:530:da96:a990 with SMTP id
 2adb3069b0e04-532eda8aa12mr4928248e87.32.1723724759884; Thu, 15 Aug 2024
 05:25:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 15 Aug 2024 14:25:48 +0200
Message-ID: <CAGudoHFJV=S61Fjb=QVf4mSTRfkYf5QR1y0TDMhnawZKtgyouA@mail.gmail.com>
Subject: perf loss on parallel compile due to conention on the buf semaphore
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I have an ext4-based system where xfs got mounted on tmpfs for testing
purposes. The directory is being used a lot by gcc when compiling.

I'm testing with 24 compilers running in parallel, each operating on
their own hello world source file, listed at the end for reference.

Both ext4 and btrfs backing the directory result in 100% cpu
utilization and about 1500 compiles/second. With xfs I see about 20%
idle(!) and about 1100 compiles/second.

According to offcputime-bpfcc -K the time is spent waiting on the buf
thing, sample traces:

   finish_task_switch.isra.0
    __schedule
    schedule
    schedule_timeout
    __down_common
    down
    xfs_buf_lock
    xfs_buf_find_lock
    xfs_buf_get_map
    xfs_buf_read_map
    xfs_trans_read_buf_map
    xfs_read_agi
    xfs_ialloc_read_agi
    xfs_dialloc
    xfs_create
    xfs_generic_create
    path_openat
    do_filp_open
    do_sys_openat2
    __x64_sys_openat
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
    -                cc (602142)
        10639

    finish_task_switch.isra.0
    __schedule
    schedule
    schedule_timeout
    __down_common
    down
    xfs_buf_lock
    xfs_buf_find_lock
    xfs_buf_get_map
    xfs_buf_read_map
    xfs_trans_read_buf_map
    xfs_read_agi
    xfs_iunlink
    xfs_dir_remove_child
    xfs_remove
    xfs_vn_unlink
    vfs_unlink
    do_unlinkat
    __x64_sys_unlink
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
    -                as (598688)
        12050

The fact that this is contended aside, I'll note the stock semaphore
code does not do adaptive spinning, which avoidably significantly
worsens the impact. You can probably convert this to a rw semaphore
and only ever writelock, which should sort out this aspect. I did not
check what can be done to contend less to begin with.

reproducing:
create a hello world .c file (say /tmp/src.c) and plop into /src:
for i in $(seq 0 23); do cp /tmp/src.c /src/src${i}.c; done

plop the following into will-it-scale/tests/cc.c && ./cc_processes -t 24

#include <sys/types.h>
#include <unistd.h>

char *testcase_description = "compile";

void testcase(unsigned long long *iterations, unsigned long nr)
{
        char cmd[1024];

        sprintf(&cmd, "cc -c -o /tmp/out.%d /src/src%d.c", nr, nr);

        while (1) {
                system(cmd);

                (*iterations)++;
        }
}

-- 
Mateusz Guzik <mjguzik gmail.com>
