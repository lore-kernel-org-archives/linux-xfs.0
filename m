Return-Path: <SRS0=Dzjb=WE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB40C433FF
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Aug 2019 03:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031BD216C8
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Aug 2019 03:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfHHDMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Aug 2019 23:12:10 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59024 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727978AbfHHDMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 23:12:10 -0400
X-IronPort-AV: E=Sophos;i="5.64,358,1559491200"; 
   d="scan'208";a="73187039"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Aug 2019 11:12:01 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C4D614CDFCE8;
        Thu,  8 Aug 2019 11:12:01 +0800 (CST)
Received: from [10.167.215.46] (10.167.215.46) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Thu, 8 Aug 2019 11:12:00 +0800
Message-ID: <5D4B92EF.4090800@cn.fujitsu.com>
Date:   Thu, 8 Aug 2019 11:11:43 +0800
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Murphy Zhou <jencce.kernel@gmail.com>
CC:     Petr Vorel <pvorel@suse.cz>, <chrubis@suse.cz>,
        <ltp@lists.linux.it>, <linux-xfs@vger.kernel.org>
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase coverage
 and remove EXDEV test
References: <20190730110555.GB7528@rei.lan> <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com> <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com> <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com> <5D47D6B9.9090306@cn.fujitsu.com> <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com> <20190806162703.GA1333@dell5510> <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
In-Reply-To: <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.46]
X-yoursite-MailScanner-ID: C4D614CDFCE8.AF30B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190808031143.DEf57xRD9F3zcjN-8GM_Mz8jEemidOer4L_LFgM56oE@z>

on 2019/08/07 18:17, Murphy Zhou wrote:

> And I have a question about LTP itself.
>
> If we run the testcase directly like:
> 	 ./testcases/kernel/syscalls/copy_file_range/copy_file_range02
>
> to test all_filesystems, for every filesystem, we mkfs and mount it in
> .mntpoint, but we do not chdir to .mntpoint. So we are running tests in 
> the same tmpdir, fs type of which does not change while looping
> all_filesystems.  Only the .mntpoint in tmpdir has different fs type in
> each loop.
>
> Now we are using this to test cross-device copy in copy_file_range01.c,
> but in copy_file_range02.c, we are not using .mntpint at all, all the
> tests in the all_filesystems loop are running in the same tmpdir. In other
> words, we are NOT testing all filesystems.
>
> Is this expected?
 I removed the mnted test for cross-device copy_file_range in copy_file_range02.c.
And I ignore the non-used mntpoint. IMO, we can directly use the FILE_MNTED to test EFBIG on all filesystems, 

as below:
diff --git a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
index 26bfa008a..67974ffa2 100644
--- a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
+++ b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
@@ -49,6 +49,7 @@ static int fd_blkdev;
 static int fd_chrdev;
 static int fd_fifo;
 static int fd_copy;
+static int fd_mnted;

 static int chattr_i_nsup;
 static int swap_nsup;

@@ -73,7 +74,7 @@ static struct tcase {
        {&fd_chrdev,    0,   EINVAL,     0,     CONTSIZE},
        {&fd_fifo,      0,   EINVAL,     0,     CONTSIZE},
        {&fd_copy,      0,   EOVERFLOW,  MAX_OFF, ULLONG_MAX},
-       {&fd_copy,      0,   EFBIG,      MAX_OFF, MIN_OFF},
+       {&fd_mnted,      0,   EFBIG,      MAX_OFF, MIN_OFF},
 };

 static int run_command(char *command, char *option, char *file)
@@ -117,7 +118,10 @@ static void verify_copy_file_range(unsigned int n)
                        tst_res(TPASS | TTERRNO,
                                        "copy_file_range failed as expected");
                } else {
-                       tst_res(TFAIL | TTERRNO,
+                       if (tc->exp_err == EFBIG && TST_ERR == EXDEV)
+                               tst_res(TCONF, "copy_file_range doesn't support cross-device,skip it");
+                       else
+                               tst_res(TFAIL | TTERRNO,
                                "copy_file_range failed unexpectedly; expected %s, but got",
                                tst_strerrno(tc->exp_err));
                        return;

@@ -152,6 +156,8 @@ static void cleanup(void)
                SAFE_CLOSE(fd_dup);
        if (fd_copy > 0)
                SAFE_CLOSE(fd_copy);
+       if (fd_mnted > 0)
+               SAFE_CLOSE(fd_mnted);
        SAFE_UNLINK(FILE_FIFO);
 }

@@ -194,6 +200,7 @@ static void setup(void)

        fd_copy = SAFE_OPEN(FILE_COPY_PATH, O_RDWR | O_CREAT | O_TRUNC, 0664);
        chattr_i_nsup = run_command("chattr", "+i", FILE_IMMUTABLE_PATH);
+       fd_mnted  = SAFE_OPEN(FILE_MNTED_PATH, O_RDWR | O_CREAT, 0664);

        if (!tst_fs_has_free(".", sysconf(_SC_PAGESIZE) * 10, TST_BYTES)) {
                tst_res(TCONF, "Insufficient disk space to create swap file");
                swap_nsup = 3;

test12) succeed on extN, failed on both btrfs and xfs, we need to detect filesystem type to handle. Or, I think we 
can set a limit on filesize because this kind of user scene is a bit more than the first one , the EFBIG error can be 
received easily (Also, we don't need  mnt_device mntpoint all_filesystem if so).
What do you think about it?

> I commented out testcases in copy_file_range02.c other then #12, and add
> some nasty debug info:



