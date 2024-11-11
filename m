Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AE01A0704
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731334673; cv=none; b=Fa6Qb/FW/bdtLaEE/3ZM6d4fvEHAQAsi7lTx2ax363XMA5DoXiSeq52TdynYym3dQwJy7WZyWfnQq5Rq2MDWagbWJpcq29AaZIacDgV69cucyVziTBtRiBSneHpxxgGDS58ih3M66pZ8zCdCtlk79scjTTBu5lvnSzrRqfpslFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731334673; c=relaxed/simple;
	bh=1mhtz2nH32HjuTBO3LQJmSFXzsrOenTZ63qBFtxtZlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htsi4KWNPWqoMoy5O7OxkszgBmF6zN2LnP0k92O4IfBhfMP7T4TXEVnVxsoBKgPMWTFnIerdoNPA6ouIkGuZqOLv9vrW7r5Qtm4BvLjp1sjZP2akahzVKdFMJJWy3IbSLUdPFIRJwWqeK4cHWPj6+6j4fcrO9VtljxeptDCGe1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XnBRM1pXnz1hwP1;
	Mon, 11 Nov 2024 22:15:59 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A0C01A016C;
	Mon, 11 Nov 2024 22:17:47 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 11 Nov
 2024 22:17:47 +0800
Date: Mon, 11 Nov 2024 22:16:40 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <cem@kernel.org>, <brauner@kernel.org>,
	<linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH] iomap: fix zero padding data issue in concurrent append
 writes
Message-ID: <ZzIRyA8DtxLcs_vO@localhost.localdomain>
References: <20241108122738.2617669-1-leo.lilong@huawei.com>
 <Zy4mW6r3rjMEsNir@infradead.org>
 <Zy8Lsee7EDodz5Xk@localhost.localdomain>
 <ZzGZ76Qy7mCZo8a3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZzGZ76Qy7mCZo8a3@infradead.org>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Sun, Nov 10, 2024 at 09:45:19PM -0800, Christoph Hellwig wrote:
> On Sat, Nov 09, 2024 at 03:13:53PM +0800, Long Li wrote:
> > > Oh, interesting one.  Do you have a reproducer we could wire up
> > > to xfstests?
> > > 
> > 
> > Yes, I have a simple reproducer, but it would require significant
> > work to incorporate it into xfstestis.
> 
> Can you at least shared it?  We might be able to help turning it into
> a test.
> 

At first, we used the following script to find the problem, but it was
difficult to reproduce the problem, run test.sh after system startup.

--------------------filesystem.sh---------------------
#!/bin/bash
index=$1
value=$2

while true; do
    echo "$value" >> /mnt/fs_"$index"/file1
    echo "$value" >> /mnt/fs_"$index"/file2
    cp /mnt/fs_"$index"/file1 /mnt/fs_"$index"/file3
    cat /mnt/fs_"$index"/file1 /mnt/fs_"$index"/file2
    mv /mnt/fs_"$index"/file3 /mnt/fs_"$index"/file1
done

--------------------test.sh--------------------------
#!/bin/bash
mount /dev/sda /mnt
cat -v /mnt/* | grep @
if [ $? == 0 ] ;then
        echo "find padding data"
        exit 1
fi

sh -x filesystem.sh 1 1111 &>/dev/null &
sh -x filesystem.sh 1 2222 &>/dev/null &
sh -x filesystem.sh 1 3333 &>/dev/null &
sleep $(($RANDOM%30))
echo "reboot..."
echo b > /proc/sysrq-trigger
------------------------------------------------------

I later reproduce it by adding a delay to the kernel code
and verified the fixed patch. 

1) add some sleep in xfs_end_ioend

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -130,8 +130,10 @@ xfs_end_ioend(
        else if (ioend->io_type == IOMAP_UNWRITTEN)
                error = xfs_iomap_write_unwritten(ip, offset, size, false);
 
-       if (!error && xfs_ioend_is_append(ioend))
+       if (!error && xfs_ioend_is_append(ioend)) {
+               msleep(30000);
                error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+       }
 done:
        iomap_finish_ioends(ioend, error);
        memalloc_nofs_restore(nofs_flag);


2) run rep.sh and reboot system
-----------------------rep.sh-------------------------
#!/bin/bash

mkfs.xfs -f /dev/sda
mount /dev/sda /mnt/test
touch /mnt/test/file
xfs_io -c "pwrite 0 20 -S 0x31" /mnt/test/file
sync &
sleep 5

echo 100000 > /proc/sys/vm/dirty_writeback_centisecs
echo 100000 > /proc/sys/vm/dirty_expire_centisecs
xfs_io -c "pwrite 20 20 -S 0x31" /mnt/test/file 
sleep 40

echo b > /proc/sysrq-trigger
------------------------------------------------------

3) after reboot, check file.

mount /dev/sda /mnt/test
cat -v /mnt/test/file | grep @

> > If we only use one size record, we can remove io_size and keep only
> > io_end to record the tail end of valid file data in ioend. Meanwhile,
> > we can add a wrapper function iomep_ioend_iosize() to get the extent
> > size of ioend, replacing the existing ioend->io_size. Would this work?
> 
> I'd probably still use offset + size to avoid churn because it feels
> more natural and causes less churn, but otherwise this sounds good to
> me.
> 

Ok, I got it. However, we need to change the meaning of "io_size" to
the size of the valid file data in ioend.

Thanks,
Long Li
