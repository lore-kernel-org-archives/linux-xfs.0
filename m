Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16104C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 19:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiFWTwk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiFWTwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 15:52:35 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B35103E
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 12:52:34 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3176b6ed923so4553077b3.11
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=/IkXaysTmJNQF9kPEgsE0B35gANiP/zFe5svht2XAxw=;
        b=pRhFdinexvUSgiW9376rfEuNwpr1Ea8icrCdEv8NICx+LHhf1Ss8NN3YunYNh9nA2D
         64Jvrwjpf6DGvkf/RhOLVDLi1dhMlgAcqKlgWO3KO9Ezg6ZzvuyQS/feWw2T1aluVGJg
         CxuvPQ2m77h8yklezBImYV7u2TVCb10Or7CE7b5laqnI7glAI1Kbc/79qvQHga1ZE/o6
         woMnRx5ylgVaGl2LZVQYtIuodR6nYW0vfVmnJpH/9eTjRc9obxLtV3qAg++v1o4Q03Nv
         hv2XD3ORq3D9RrEVuWupyiuofDntWGj8OUr8b+gWHiKDUl36SmbQt9z4Hadv3l3qWhAN
         evKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/IkXaysTmJNQF9kPEgsE0B35gANiP/zFe5svht2XAxw=;
        b=IzeWcHcVyFQdlIluKVmPjbbBzvk+bjAL7EWcRNFr6IaizwnPJElip1+jLI+OAtjSGI
         d83g4MYQSDZMlH3AfhrhIui5hra5EbH2fFnYtSAjocNMcWtoMt0c8MJ/hJCGp+edxFr+
         /lJjhF5VD+cFMISioKV1oWhoZwWQ7f+uQSEq8nLykrla7dI73EQ4oOXG32J37DwjmrlX
         ATYx9C61kK+jB5I0fgpK9RwrN+5Vfr57GQ6a/f9vwUohBaBMyogUhRntB9xU1fbZEi1Q
         BUzC28bu64KcJZ9hAH6FUzIYa1OHdrosIEPVCi/yNKQe+vhEHO3WYv+c7EbGCET+0EAX
         zksg==
X-Gm-Message-State: AJIora+h6eMZ1T4qtsPKdza5ObbMI91eMZecDKM+0cRbA9tAu4v5bZhl
        siklZ+kwgkd6LnT674wUuCQlb2nYl+ZpCByO6oAYCWkBY5MDNQ==
X-Google-Smtp-Source: AGRyM1tAzCZ1EReuFLsk1b+woUffHTzoAcxkEf6VWrjOfYW2ldGgHha5rmuKESiorgfQjI4uGpxdxj1RkAwy/ciTWlk=
X-Received: by 2002:a81:7c04:0:b0:317:587d:b5d5 with SMTP id
 x4-20020a817c04000000b00317587db5d5mr12301676ywc.115.1656013953114; Thu, 23
 Jun 2022 12:52:33 -0700 (PDT)
MIME-Version: 1.0
From:   Clay Gerrard <clay.gerrard@gmail.com>
Date:   Thu, 23 Jun 2022 14:52:22 -0500
Message-ID: <CA+_JKzo7V5PZkWGFPB5hP0pAtWrOsi0TomxHaO5W+ViEF8ctwQ@mail.gmail.com>
Subject: ENODATA on list/stat directory
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I work on an object storage system, OpenStack Swift, that has always
used xfs on the storage nodes.  Our system has encountered many
various disk failures and occasionally apparent file system corruption
over the years, but we've been noticing something lately that might be
"new" and I'm considering how to approach the problem.  I'm interested
to solicit critique on my current thinking/process - particularly from
xfs experts.

[root@s8k-sjc3-d01-obj-9 ~]# xfs_bmap
/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
No data available
[root@s8k-sjc3-d01-obj-9 ~]# xfs_db
/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
No data available

fatal error -- couldn't initialize XFS library
[root@s8k-sjc3-d01-obj-9 ~]# ls -alhF /srv/node/d21865/quarantined/objects-1/e53
ls: cannot access
/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
No data available
total 4.0K
drwxr-xr-x  9 swift swift  318 Jun  7 00:57 ./
drwxr-xr-x 33 swift swift 4.0K Jun 23 16:10 ../
d?????????  ? ?     ?        ?            ? f0418758de4baaa402eb301c5bae3e53/
drwxr-xr-x  2 swift swift   47 May 27 00:43 f04193c31edc9593007471ee5a189e53/
drwxr-xr-x  2 swift swift   47 May 27 00:43 f0419c711a5a5d01dac6154970525e53/
drwxr-xr-x  2 swift swift   47 May 27 00:43 f041a2548b9255493d16ba21c19b6e53/
drwxr-xr-x  2 swift swift   47 Jun  7 00:57 f041aa09d40566d6915a706a22886e53/
drwxr-xr-x  2 swift swift   39 May 27 00:43 f041ac88bf13e5458a049d827e761e53/
drwxr-xr-x  2 swift swift   47 May 27 00:43 f041bfd1c234d44b591c025d459a7e53/
[root@s8k-sjc3-d01-obj-9 ~]# python
Python 2.7.5 (default, Nov 16 2020, 22:23:17)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-44)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> os.stat('/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 61] No data available:
'/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53'
>>> os.listdir('/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 61] No data available:
'/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53'
>>>

[root@s8k-sjc3-d01-obj-9 ~]# uname -a
Linux s8k-sjc3-d01-obj-9.nsv.sjc3.nvmetal.net
3.10.0-1160.62.1.el7.x86_64 #1 SMP Tue Apr 5 16:57:59 UTC 2022 x86_64
x86_64 x86_64 GNU/Linux
[root@s8k-sjc3-d01-obj-9 ~]# mount | grep /srv/node/d21865
/dev/sdd on /srv/node/d21865 type xfs
(rw,noatime,nodiratime,attr2,inode64,logbufs=8,noquota)
[root@s8k-sjc3-d01-obj-9 ~]# xfs_db -r /dev/sdd
xfs_db> version
versionnum [0xbcb5+0x18a] =
V5,NLINK,DIRV2,ATTR,ALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE
xfs_db>

We can't "do" anything with the directory once it starts giving us
ENODATA.  We don't typically like to unmount the whole filesystem
(there's a LOT of *uncorrupt* data on the device) - so I'm not 100%
sure if xfs_repair fixes these directories.  Swift itself is a
replicated/erasure-coded store - we can almost always "throw away"
corrupt data on a single node and the rest can bring the cluster state
back to full durability.

This particular failure is worrisome for two reasons:

1) we can't "just" delete the affected directory - because we can't
stat/move it - so we have to throw away the whole *parent* directory
(HUGE blast radius in some cases)
2) for 10 years running Swift i've never seen this exactly, and now it
seems to be happening more and more often - but we don't know if it's
a new software version, or new hardware revision, or new access
pattern

I'd also like to be able to "simulate" this kind of corruption on a
healthy filesystem so we can test our "quarantine/auditor" code that's
trying to move these filesystem problems out of the way for the
consistency engine.  Does anyone have any guess how I could MAKE an
xfs filesystem produce this kind of behavior on purpose?

--
Clay Gerrard
