Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59772 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdAMDdP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 22:33:15 -0500
Subject: Re: [PATCH] xfs_logprint: handle the log split of inode item
 correctly
References: <1484141938-4195-1-git-send-email-houtao1@huawei.com>
 <20170112133411.GC14085@bfoster.bfoster>
 <50e8cc9c-a941-4e16-449c-2b667f282eed@sandeen.net>
 <cd390269-7e43-72e6-05f1-6d90b5022639@huawei.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f0d6e0b2-0dc2-c5a2-7efc-3e383d1faf32@sandeen.net>
Date: Thu, 12 Jan 2017 21:32:51 -0600
MIME-Version: 1.0
In-Reply-To: <cd390269-7e43-72e6-05f1-6d90b5022639@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 1/12/17 9:28 PM, Hou Tao wrote:
> The existing code mixes the usage of 4 spaces and tab, and there is no
> indentation for the statement under conditionals.

At least on my terminal, 

# grep -A1 -w if logprint/log_misc.c

shows every if statement with some form of indentation below it.
Whether it's 4 spaces or a tab, doesn't matter too much to me,
because it's mixed in the file.

Thanks,
-Eric
