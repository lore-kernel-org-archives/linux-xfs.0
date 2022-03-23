Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706EEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 23:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbiCWXaP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiCWXaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 19:30:14 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCACC27176
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 16:28:43 -0700 (PDT)
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22NNSXIb028547;
        Thu, 24 Mar 2022 08:28:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Thu, 24 Mar 2022 08:28:33 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22NNSXoF028544
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 24 Mar 2022 08:28:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <29f2af94-3f79-5044-aae1-9e10a30d4864@I-love.SAKURA.ne.jp>
Date:   Thu, 24 Mar 2022 08:28:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: xfs: Temporary extra disk space consumption?
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
 <20220323191647.GT1544202@dread.disaster.area>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20220323191647.GT1544202@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/24 4:16, Dave Chinner wrote:
> On Wed, Mar 23, 2022 at 08:21:52PM +0900, Tetsuo Handa wrote:
>> Hello.
>>
>> I found that running a sample program shown below on xfs filesystem
>> results in consuming extra disk space until close() is called.
>> Is this expected result?
> 
> Yes. It's an anti-fragmentation mechanism that is intended to
> prevent ecessive fragmentation when many files are being written at
> once.

OK, this is an xfs specific behavior.

> Looks like specualtive preallocation for sequential writes is
> behaving exactly as designed....

Here is the result of "filefrag -v my_testfile" before close().

Filesystem type is: 58465342
File size of my_testfile is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   65519:   33363497..  33429016:  65520:
   1:    65520..  229915:   62724762..  62889157: 164396:   33429017:
   2:   229916..  262143:   63132138..  63164365:  32228:   62889158: eof
   3:   262144..  294895:   63164366..  63197117:  32752:             unwritten,eof
my_testfile: 3 extents found

Filesystem type is: 58465342
File size of my_testfile is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..  131055:   62724762..  62855817: 131056:
   1:   131056..  240361:   63813369..  63922674: 109306:   62855818:
   2:   240362..  262143:   32448944..  32470725:  21782:   63922675: eof
   3:   262144..  349194:   32470726..  32557776:  87051:             unwritten,eof
   4:   349195..  524271:          0..    175076: 175077:   32557777: unknown,delalloc,eof
my_testfile: 4 extents found



An interesting behavior I noticed is that, since "filefrag -v" opens this file
for reading and then closes this file descriptor opened for reading, injecting
close(open(filename, O_RDONLY)) like below causes consumption by speculative
preallocation gone; close() of a file descriptor opened for writing is not
required.

----------
diff -u my_write_unlink.c my_write_unlink2.c
--- my_write_unlink.c
+++ my_write_unlink2.c
@@ -23,6 +23,8 @@
                return 1;
        printf("Before close().\n");
        system("/bin/df -m .");
+       close(open(filename, O_RDONLY));
+       system("/bin/df -m .");
        if (close(fd))
                return 1;
        printf("Before unlink().\n");
----------

----------
Before write().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 130396    125479  51% /
Before close().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 132447    123428  52% /
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 131420    124455  52% /
Before unlink().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 131420    124455  52% /
After unlink().
Filesystem     1M-blocks   Used Available Use% Mounted on
/dev/sda1         255875 130396    125479  51% /
----------

