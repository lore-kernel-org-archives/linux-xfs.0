Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDCC3C38
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 04:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723004854; cv=none; b=Q975yr5utuW+vHVLKDvOuRb3IDSdLCafQcLyWHfFdYas1ceGRJGD+d49FQtD1CgBqMfq8sAn861ZbJxnbAG2cgmg3nyA2Xm1by6Zk3MHQQBE7ezdhrEV9GWlZ76bMuPjZYVokkiZR0EOazc9LXUCQHfqej1/GyOhwhp+Lp3Q7L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723004854; c=relaxed/simple;
	bh=+JBuMuDCXU+IpNKxGLw0SQfAVn75uOpcppI2tfDc1x8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K4wN601+puH6ZjbMofDZlQozzQ+dOFk6W+P60xHCUNc/JkQs/iqFU6L4rFwAZu9x91LLBPcgfxqLO1nrWN9u/WIcKKacRpjiAsknDTRDx0WFfmcHCbCNLlZpWhBrCLMhDsJ4ZberD/vv/2ygTUV0gxzfDg4/4E8paE6s26JANjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJpAXjzH; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJpAXjzH"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a611adso1857648a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 21:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723004851; x=1723609651; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aXZyx4rY70BZYCjcXSWQWZ+097hBc50y2t0aPqh481g=;
        b=BJpAXjzHjLIt2YcQPYrO/+b6L14cCEJYqE1ydNLrg9Fzy+QcAOkDMjIGp0L9nnRxLC
         7ISwXascRQJE1W2ZKYCh6kmHQtRF9he31Rvxtbh1M3TVOmC73M6jAxLWsgmgaR5Hh6v4
         ++IXicmE5NkqHie0lufYc2EF/FK0z0h3DxbX4NSMyUN9IQx6sdyV+tWJD5zo7629m4cO
         5ygEBtXw0N82AisHv1El3sA/WmdGrawFX37u2+rmOhH6sjAo+OT2+XDzzV518BQRx6vw
         oqWB9XQrqbbJk3xuuhRhNhQdzGefQRtReOo8PooRiUjDFnfY0kMIeDKaEayljHWveEau
         t+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723004851; x=1723609651;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aXZyx4rY70BZYCjcXSWQWZ+097hBc50y2t0aPqh481g=;
        b=UWjOrRqSeu2Wo4MQHtpoGWxgMIKb9KbRXlFck97Up+w23/oxTG0YTpQoZY+o7HiUqR
         ZJlWV3fCBkRp1AYCuDkQCEI/jwphxlRPE3ptv8M5gzOb0t1X4tM3PVZ6yRTH2BNz9bDh
         VvtKaD4HIqBGpoXUBJMt1RSNrJxXS3p9vwqJCZfkoSvUniVybDlkcFTtYn8GDRsWFjUb
         2DyLPBHQE9RdSIgqDzcCxS2fC6qU0R6bQJUmirIGMJcudBlHGXbBTTX5R3Q8OciRhp+z
         6Rq5H5uQ6xxbodQ2DF7tEXrn2zGn+ChpwDaAodTQgyTkWbEISm2i1ghF8BV/1uSuFsr1
         5wnA==
X-Gm-Message-State: AOJu0YzlfwoP8NnLV09LJt8xa8Bt2c/rn78hIjcf/+lCL+wOf0Bx4zJN
	2SB0dwpOTYX6Q3M6p+rs1bzp82yuCO4O5VqUmcrJettH5mMN0qZzx3OGZQ==
X-Google-Smtp-Source: AGHT+IGSK7JCLTb10YKwFh6LBtl6JSco4Ry8cWew+pRT2qBr3w7gkvb+eOOavESn4JC6mA5Zx6PL3Q==
X-Received: by 2002:aa7:c713:0:b0:5a1:3c47:70f4 with SMTP id 4fb4d7f45d1cf-5b7f419dfe6mr11667795a12.17.1723004851222;
        Tue, 06 Aug 2024 21:27:31 -0700 (PDT)
Received: from f (cst-prg-72-52.cust.vodafone.cz. [46.135.72.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83960f101sm6637938a12.20.2024.08.06.21.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 21:27:30 -0700 (PDT)
Date: Wed, 7 Aug 2024 06:27:21 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org
Subject: xfs_release lock contention
Message-ID: <ejy4ska7orznl75364ehskucg7ibo3j3biwkui6q6mv42im6o5@pzl7pwwxjrg3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

I'm looking at false-sharing problems concerning multicore open + read +
close cycle on one inode and during my survey I found xfs is heavily
serializing on a spinlock in xfs_release, making it perform the worst
out of the btrfs/ext4/xfs trio.

A trivial test case plopped into will-it-scale is at the end.

bpftrace -e 'kprobe:__pv_queued_spin_lock_slowpath { @[kstack()] = count(); }' tells me:
[snip]
@[
    __pv_queued_spin_lock_slowpath+5
    _raw_spin_lock_irqsave+49
    rwsem_wake.isra.0+57
    up_write+69
    xfs_iunlock+244
    xfs_release+175
    __fput+238
    __x64_sys_close+60
    do_syscall_64+82
    entry_SYSCALL_64_after_hwframe+118
]: 41132
@[
    __pv_queued_spin_lock_slowpath+5
    _raw_spin_lock_irq+42
    rwsem_down_read_slowpath+164
    down_read+72
    xfs_ilock+125
    xfs_file_buffered_read+71
    xfs_file_read_iter+115
    vfs_read+604
    ksys_read+103
    do_syscall_64+82
    entry_SYSCALL_64_after_hwframe+118
]: 137639
@[
    __pv_queued_spin_lock_slowpath+5
    _raw_spin_lock+41
    xfs_release+196
    __fput+238
    __x64_sys_close+60
    do_syscall_64+82
    entry_SYSCALL_64_after_hwframe+118
]: 1432766

The xfs_release -> _raw_spin_lock thing is the XFS_ITRUNCATED flag test.

Also note how eofblock code inducing write trylock gets in the way of
doing the read (first 2 stacks).

General note is that for most files real files there are no "blocks past
eof" or otherwise truncation going on and there is presumably a way to
locklessly handle that, which should also reduce single-threaded
overhead.

For testing purposes I wrote a total hack which merely branches on
i_flags and i_delayed_blks == 0, but I have no idea if that's any good
-- *something* definitely is doable here, I leave that to people who
know the fs.

When running a kernel with a change whacking one lockref cycle on open:
https://lore.kernel.org/linux-fsdevel/20240806163256.882140-1-mjguzik@gmail.com/T/#u

... and toggling the short-circuit outlined above I'm seeing +50% ops/s
and going above btrfs. Then top of the profile is the false sharing I'm
looking at with other filesystems.

So that would be my report. Whatever you guys do with it is your
business, I'm bailing to the false-sharing problem.

Should you address this in a committable manner, there is no need to
credit or cc me.

Cheers.

the not patch:
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7dc6f326936c..1cc62c21e709 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1079,6 +1079,8 @@ xfs_itruncate_extents_flags(
        return error;
 }

+extern unsigned long magic_tunable;
+
 int
 xfs_release(
        xfs_inode_t     *ip)
@@ -1089,6 +1091,13 @@ xfs_release(
        if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
                return 0;

+       if (magic_tunable) {
+               if (!(ip->i_flags & XFS_ITRUNCATED))
+                       return 0;
+               if (ip->i_delayed_blks == 0)
+                       return 0;
+       }
+
        /* If this is a read-only mount, don't do this (would generate I/O) */
        if (xfs_is_readonly(mp))
                return 0;


test case (plop into will-it-scale, say tests/openreadclose3.c and run
./openreadclose3_processes -t 24):

#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <assert.h>

#define BUFSIZE 1024

static char tmpfile[] = "/tmp/willitscale.XXXXXX";

char *testcase_description = "Same file open/read/close";

void testcase_prepare(unsigned long nr_tasks)
{
        char buf[BUFSIZE];
        int fd = mkstemp(tmpfile);

        assert(fd >= 0);
        memset(buf, 'A', sizeof(buf));
        assert(write(fd, buf, sizeof(buf)) == sizeof(buf));
        close(fd);
}

void testcase(unsigned long long *iterations, unsigned long nr)
{
        char buf[BUFSIZE];

        while (1) {
                int fd = open(tmpfile, O_RDONLY);
                assert(fd >= 0);
                assert(read(fd, buf, sizeof(buf)) == sizeof(buf));
                close(fd);

                (*iterations)++;
        }
}

void testcase_cleanup(void)
{
        unlink(tmpfile);
}


