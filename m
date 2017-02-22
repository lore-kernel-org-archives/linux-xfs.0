Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36015 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932402AbdBVLzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2017 06:55:53 -0500
Received: by mail-vk0-f53.google.com with SMTP id t8so120233vke.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2017 03:55:52 -0800 (PST)
MIME-Version: 1.0
From: Vaibhaw Pandey <vaibhaw@scalegrid.io>
Date: Wed, 22 Feb 2017 17:25:51 +0530
Message-ID: <CADWLRhrkA6pa_OeddSf281Lr+53JyEp5dxaHc+KTJPRLShWvkQ@mail.gmail.com>
Subject: Consider these for the XFS FAQ wiki
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hey,

I had recently run into the ext4 auto_da_alloc delayed allocation type
behavior with XFS i.e. replace by rename leaving an empty file behind.
It took me forever to debug it cause I couldn't find answers to some
simple questions right away.

You guys are the experts but I would like to suggest adding some
questions (& answers) to the XFS FAQ doc for the clueless folks like
me.

I would suggest the following questions:

0. Does XFS support a mount option equivalent to ext4's auto_da_alloc?
i.e. Does XFS have the workarounds to support the replace by truncate
and replace by rename?
Ans:
Answered exactly in http://oss.sgi.com/archives/xfs/2015-12/msg00553.html

1. Does XFS support a mount option equivalent to ext4's commit? i.e.
How do I control how often does XFS sync to disk? Or Does XFS never
sync to disk until a sync/fsync is called?

Ans:
Answered here: http://article.gmane.org/gmane.comp.file-systems.xfs.general/53376
Reproducing from source:
<snip>
By and large, buffered IO in a filesystem is flushed out by the vm,
due to either age or memory pressure.  The filesystem then responds
to these requests by the VM, writing data as requested.

You can read all about it in
https://www.kernel.org/doc/Documentation/sysctl/vm.txt See
dirty_expire_centisecs and dirty_writeback_centisecs - flushers wake
up every 30s and push on data more than 5s old, by default.
</snip>

2. What is the maximum size of the XFS journal?
Ans: Not sure. But this is the closest answer I could find:
https://serverfault.com/questions/367973/xfs-maximum-log-size-sw-raid-10-mdadm-sles-11-sp1
I could read through the code and find a better answer in case you
folks wouldn't have the time.


Lemme know what you think.

Thanks,
Vaibhaw
