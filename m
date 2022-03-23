Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20595C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 11:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbiCWLX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 07:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiCWLXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 07:23:25 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08452793AF
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 04:21:53 -0700 (PDT)
Received: from fsav116.sakura.ne.jp (fsav116.sakura.ne.jp [27.133.134.243])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22NBLqOt011483
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 20:21:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav116.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp);
 Wed, 23 Mar 2022 20:21:52 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22NBLq9h011479
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 20:21:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
Date:   Wed, 23 Mar 2022 20:21:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: xfs: Temporary extra disk space consumption?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

I found that running a sample program shown below on xfs filesystem
results in consuming extra disk space until close() is called.
Is this expected result?

I don't care if temporarily consumed extra disk space is trivial. But since
this amount as of returning from fsync() is as much as amount of written data,
I worry that there might be some bug.

---------- my_write_unlink.c ----------
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	static char buffer[1048576];
	const char *filename = "my_testfile";
	const int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0600);
	int i;

	if (fd == EOF)
		return 1;
	printf("Before write().\n");
	system("/bin/df -m .");
	for (i = 0; i < 1024; i++)
		if (write(fd, buffer, sizeof(buffer)) != sizeof(buffer))
			return 1;
	if (fsync(fd))
		return 1;
	printf("Before close().\n");
	system("/bin/df -m .");
	if (close(fd))
		return 1;
	printf("Before unlink().\n");
	system("/bin/df -m .");
	if (unlink(filename))
		return 1;
	printf("After unlink().\n");
	system("/bin/df -m .");
	return 0;
}
---------- my_write_unlink.c ----------

----------
$ uname -r
5.17.0
$ ./my_write_unlink
Before write().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 130392    125483  51% /
Before close().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 132443    123432  52% /
Before unlink().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 131416    124459  52% /
After unlink().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 130392    125483  51% /
$ grep sda /proc/mounts
/dev/sda1 / xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
----------

----------
$ uname -r
4.18.0-365.el8.x86_64
$ ./my_write_unlink
Before write().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  2743     17727  14% /
Before close().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  4791     15679  24% /
Before unlink().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  3767     16703  19% /
After unlink().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  2743     17727  14% /
$ grep sda /proc/mounts
/dev/sda1 / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
----------

----------
$ uname -r
3.10.0-1160.59.1.el7.x86_64
$ ./my_write_unlink
Before write().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  2310     18160  12% /
Before close().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  4358     16112  22% /
Before unlink().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  3334     17136  17% /
After unlink().
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/sda1          20469  2310     18160  12% /
$ grep sda /proc/mounts
/dev/sda1 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
----------
