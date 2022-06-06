Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73A7C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 14:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiFFO3i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 10:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239882AbiFFO3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 10:29:30 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09C27CA3C7
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 07:29:29 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AF01C323BF9;
        Mon,  6 Jun 2022 09:29:05 -0500 (CDT)
Message-ID: <cadc327b-2370-1b1d-6822-ae8a1da6d58c@sandeen.net>
Date:   Mon, 6 Jun 2022 09:29:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-Language: en-US
To:     zhanchengbin <zhanchengbin1@huawei.com>, djwong@kernel.org
Cc:     liuzhiqiang26@huawei.com, linfeilong <linfeilong@huawei.com>,
        linux-xfs@vger.kernel.org
References: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
 <44ef0950-791d-e17e-1fe8-f58d3148603f@huawei.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/3] mkfs/proto.c: avoid to use NULL pointer
In-Reply-To: <44ef0950-791d-e17e-1fe8-f58d3148603f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/6/22 7:33 AM, zhanchengbin wrote:
> Change malloc to xmalloc.

The commit log and cover letter say nothing about this, but apparently
"xmalloc" is often defined locally to abort() on a memory failure, so I
guess you are trying to make (some of?) xfsprogs do that.

First, this doesn't seem to build....

Building mkfs
    [CC]     proto.o
proto.c: In function ‘setup_proto’:
proto.c:73:15: warning: implicit declaration of function ‘xmalloc’; did you mean ‘malloc’? [-Wimplicit-function-declaration]
   73 |         buf = xmalloc(size + 1);
      |               ^~~~~~~
      |               malloc
proto.c:73:13: warning: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
   73 |         buf = xmalloc(size + 1);
      |             ^
proto.c: In function ‘newregfile’:
proto.c:306:21: warning: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  306 |                 buf = xmalloc(size);
      |                     ^
    [LD]     mkfs.xfs
/usr/bin/ld: proto.o: in function `setup_proto':
/src/git/xfsprogs-dev/mkfs/proto.c:73: undefined reference to `xmalloc'
/usr/bin/ld: proto.o: in function `newregfile':
/src/git/xfsprogs-dev/mkfs/proto.c:306: undefined reference to `xmalloc'
collect2: error: ld returned 1 exit status
gmake[2]: *** [../include/buildrules:65: mkfs.xfs] Error 1
gmake[1]: *** [include/buildrules:36: mkfs] Error 2
make: *** [Makefile:92: default] Error 2

Second, we have calls to malloc all over the codebase, including around
100 outside of the internal libraries in the various userspace utilities.
Why change only mkfs/db/repair?

Third, what problem are you solving? Granted, we should be checking every
malloc call, and it seems that we don't. But have you ever seen these
failures in practice? Your commit log should at least explain why this
makes the code better (and, I guess, where xmalloc is supposed to come 
from...)

-Eric

> Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
> ---
>  mkfs/proto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 127d87dd..f3b8710c 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -70,7 +70,7 @@ setup_proto(
>          goto out_fail;
>      }
> 
> -    buf = malloc(size + 1);
> +    buf = xmalloc(size + 1);
>      if (read(fd, buf, size) < size) {
>          fprintf(stderr, _("%s: read failed on %s: %s\n"),
>              progname, fname, strerror(errno));
> @@ -303,7 +303,7 @@ newregfile(
>          exit(1);
>      }
>      if ((*len = (int)size)) {
> -        buf = malloc(size);
> +        buf = xmalloc(size);
>          if (read(fd, buf, size) < size) {
>              fprintf(stderr, _("%s: read failed on %s: %s\n"),
>                  progname, fname, strerror(errno));
