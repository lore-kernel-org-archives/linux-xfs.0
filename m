Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD51C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 19:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiCWTSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 15:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiCWTSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 15:18:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D3F38566A
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 12:16:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3B652533BE0;
        Thu, 24 Mar 2022 06:16:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nX6TP-0091Py-R2; Thu, 24 Mar 2022 06:16:47 +1100
Date:   Thu, 24 Mar 2022 06:16:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs: Temporary extra disk space consumption?
Message-ID: <20220323191647.GT1544202@dread.disaster.area>
References: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623b7222
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=cJiucGCTsNWh4nBULV8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 08:21:52PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I found that running a sample program shown below on xfs filesystem
> results in consuming extra disk space until close() is called.
> Is this expected result?

Yes. It's an anti-fragmentation mechanism that is intended to
prevent ecessive fragmentation when many files are being written at
once.

> I don't care if temporarily consumed extra disk space is trivial. But since
> this amount as of returning from fsync() is as much as amount of written data,
> I worry that there might be some bug.
> 
> ---------- my_write_unlink.c ----------
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[])
> {
> 	static char buffer[1048576];
> 	const char *filename = "my_testfile";
> 	const int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0600);
> 	int i;

Truncate to zero length - all writes will be sequential extending
EOF.

> 
> 	if (fd == EOF)
> 		return 1;
> 	printf("Before write().\n");
> 	system("/bin/df -m .");
> 	for (i = 0; i < 1024; i++)
> 		if (write(fd, buffer, sizeof(buffer)) != sizeof(buffer))
> 			return 1;

And then wrote 1GB of sequential data. Without looking yet at your
results, I would expect between about 1.5 and 2GB of space was
allocated.

> 	if (fsync(fd))
> 		return 1;

This will allocate it all as a single unwritten extent if possible,
then write the 1GB of data to it converting that range to written.

Check your file size here - it will be 1GB. You can't read beyond
EOF, so the extra allocation in not accesible. It's also unwritten,
so even if you could read beyond EOF, you can't read any data from
the range because reads of unwritten extents return zeros.

> 	printf("Before close().\n");
> 	system("/bin/df -m .");
> 	if (close(fd))
> 		return 1;

This will run ->release() which will remove any extra allocation
we do at write() and result in just the written data up to EOF
remaining allocated on disk.

> 	printf("Before unlink().\n");
> 	system("/bin/df -m .");
> 	if (unlink(filename))
> 		return 1;
> 	printf("After unlink().\n");
> 	system("/bin/df -m .");
> 	return 0;
> }
> ---------- my_write_unlink.c ----------
> 
> ----------
> $ uname -r
> 5.17.0
> $ ./my_write_unlink
> Before write().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 130392    125483  51% /
> Before close().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 132443    123432  52% /

Yup, 2GB of space allocated.

> Before unlink().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 131416    124459  52% /

and ->release trims extra allocation beyond EOF and now you are
back to just the 1GB the file consumes.

> After unlink().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 130392    125483  51% /

And now it's all gone.

> $ grep sda /proc/mounts
> /dev/sda1 / xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
> ----------
> 
> ----------
> $ uname -r
> 4.18.0-365.el8.x86_64

Same.

> ----------
> $ uname -r
> 3.10.0-1160.59.1.el7.x86_64

Same.

Looks like specualtive preallocation for sequential writes is
behaving exactly as designed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
