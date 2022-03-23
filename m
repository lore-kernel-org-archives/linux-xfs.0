Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A72C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 16:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245591AbiCWQxO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiCWQxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 12:53:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134F840E47
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 09:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A7D5618D8
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 16:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29F1C340E8;
        Wed, 23 Mar 2022 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648054303;
        bh=6RwGlucG4w+tycrrD9bPek9Z99K+rEnBy4ou0GsTWRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=evl/SpuBA7ThaJK6RsbfY9M6b+UJKBe8MfHJPUpmy9rqb2cgbB/NSn6iEJvdRddKh
         joZsfBeEXpqZNmYDUC9s9+FPmnSyJU+rA2wlqBCXzT3lB7zXwyMVyAdhG74ScAzfnz
         sP1VamV6WnV0k50+RvdqdwO7mZzyYIxDuDgHgWqjZRORbcJm1idSEoM1uehgsJZNk/
         hx48fi4g99rGt/BWwKwwDgpD1ZuNfTVNnqexru7wgjdCuPdzLLcz8UghkUHW8JYWZu
         oWw9kJC3OmqT7Y1bu396lF7fnip2Gg3PvRMFYA51yHuXD+Dtx+ZJdIeudppu/POlAK
         avaKRiIw/6lrQ==
Date:   Wed, 23 Mar 2022 09:51:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs: Temporary extra disk space consumption?
Message-ID: <20220323165142.GQ8224@magnolia>
References: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 08:21:52PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I found that running a sample program shown below on xfs filesystem
> results in consuming extra disk space until close() is called.
> Is this expected result?
> 
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
> 
> 	if (fd == EOF)
> 		return 1;
> 	printf("Before write().\n");
> 	system("/bin/df -m .");
> 	for (i = 0; i < 1024; i++)
> 		if (write(fd, buffer, sizeof(buffer)) != sizeof(buffer))
> 			return 1;
> 	if (fsync(fd))
> 		return 1;
> 	printf("Before close().\n");

If you run filefrag -v at this point and see blocks mapped into the file
after EOF, then the extra disk space consumption you see is most likely
speculative preallocation for extending writes.

--D

> 	system("/bin/df -m .");
> 	if (close(fd))
> 		return 1;
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
> Before unlink().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 131416    124459  52% /
> After unlink().
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/sda1         255875 130392    125483  51% /
> $ grep sda /proc/mounts
> /dev/sda1 / xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
> ----------
> 
> ----------
> $ uname -r
> 4.18.0-365.el8.x86_64
> $ ./my_write_unlink
> Before write().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  2743     17727  14% /
> Before close().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  4791     15679  24% /
> Before unlink().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  3767     16703  19% /
> After unlink().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  2743     17727  14% /
> $ grep sda /proc/mounts
> /dev/sda1 / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
> ----------
> 
> ----------
> $ uname -r
> 3.10.0-1160.59.1.el7.x86_64
> $ ./my_write_unlink
> Before write().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  2310     18160  12% /
> Before close().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  4358     16112  22% /
> Before unlink().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  3334     17136  17% /
> After unlink().
> Filesystem     1M-blocks  Used Available Use% Mounted on
> /dev/sda1          20469  2310     18160  12% /
> $ grep sda /proc/mounts
> /dev/sda1 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> ----------
