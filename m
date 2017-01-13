Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:23422 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdAMEZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 23:25:46 -0500
Subject: Re: [PATCH] xfs_logprint: handle the log split of inode item
 correctly
References: <1484141938-4195-1-git-send-email-houtao1@huawei.com>
 <20170112133411.GC14085@bfoster.bfoster>
 <50e8cc9c-a941-4e16-449c-2b667f282eed@sandeen.net>
 <cd390269-7e43-72e6-05f1-6d90b5022639@huawei.com>
 <f0d6e0b2-0dc2-c5a2-7efc-3e383d1faf32@sandeen.net>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <89190712-0b82-cd44-8a04-9910e6e610bb@huawei.com>
Date: Fri, 13 Jan 2017 12:23:04 +0800
MIME-Version: 1.0
In-Reply-To: <f0d6e0b2-0dc2-c5a2-7efc-3e383d1faf32@sandeen.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 2017/1/13 11:32, Eric Sandeen wrote:
> On 1/12/17 9:28 PM, Hou Tao wrote:
>> The existing code mixes the usage of 4 spaces and tab, and there is no
>> indentation for the statement under conditionals.
> 
> At least on my terminal, 
> 
> # grep -A1 -w if logprint/log_misc.c
> 
> shows every if statement with some form of indentation below it.
> Whether it's 4 spaces or a tab, doesn't matter too much to me,
> because it's mixed in the file.
grep treats the tab as 8 spaces, so here comes the indentation for
most return statements under conditionals in function xlog_print_trans_inode.

Any way it is my mistake, and i will fix it.

Regards,
Tao

