Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CEAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 19:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E14623B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 19:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbhANTeY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 14:34:24 -0500
Received: from sandeen.net ([63.231.237.45]:55250 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhANTeY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 14:34:24 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 40D51479AFE;
        Thu, 14 Jan 2021 13:32:06 -0600 (CST)
To:     Brian Foster <bfoster@redhat.com>, Yumei Huang <yuhuang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <1599642077.64707510.1610619249861.JavaMail.zimbra@redhat.com>
 <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com>
 <20210114172928.GA1351833@bfoster> <20210114182414.GB1351833@bfoster>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS: Assertion failed
Message-ID: <fe6e1cf9-6678-1329-ef58-9fa2eac75ad0@sandeen.net>
Date:   Thu, 14 Jan 2021 13:33:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114182414.GB1351833@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/14/21 12:24 PM, Brian Foster wrote:
> On Thu, Jan 14, 2021 at 12:29:28PM -0500, Brian Foster wrote:
>> On Thu, Jan 14, 2021 at 05:20:29AM -0500, Yumei Huang wrote:
>>> Hit the issue when doing syzkaller test with kernel 5.11.0-rc3(65f0d241). The C reproducer is attached.
>>>
>>> Steps to Reproduce:
>>> 1. # gcc -pthread -o reproducer reproducer.c 
>>> 2. # ./reproducer 
>>>
>>>
>>> Test results:
>>> [  131.726790] XFS: Assertion failed: (iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 849
>>> [  131.743687] ------------[ cut here ]------------
>>
>> Some quick initial analysis from a run of the reproducer... It looks
>> like it calls into xfs_setattr_size() with ATTR_KILL_PRIV set in
>> ->ia_valid. This appears to originate in the VFS via handle_truncate()
>> -> do_truncate() -> dentry_needs_remove_privs().
>>
>> An strace of the reproducer shows the following calls:
>>
>> ...
>> [pid  1524] creat("./file0", 010)       = 3
>> ...
>> [pid  1524] fsetxattr(3, "security.capability", "\0\0\0\3b\27\0\0\10\0\0\0\2\0\0\0\377\377\377\377\0\356\0", 24, 0 <unfinished ...>
>> ...
>> [pid  1524] creat("./file0", 010 <unfinished ...>
>> ...
>>
>> So I'm guessing there's an attempt to open this file with O_TRUNC with
>> this particular xattr set (unexpectedly?). Indeed, after the reproducer
>> leaves file01 around with the xattr, a subsequent xfs_io -c "open -t
>> ..." attempt triggers the assert again, and then the xattr disappears.
>> I'd have to dig more into the associated vfs code to grok the expected
>> behavior and whether there's a problem here..
>>
> 
> The reproducer seems to boil down to this:
> 
> touch <file>
> setfattr -n security.capability -v 0sAAAAA2IXAAAIAAAAAgAAAP////8A7gAA <file>
> xfs_io -c "open -t <file>"
> 
> ... and afaict, the behavior is as expected. do_truncate() sets
> ATTR_KILL_PRIV via dentry_needs_remove_privs() and calls into
> notify_change(). That eventually gets to xfs_vn_setattr_size(), which
> calls xfs_vn_change_ok() -> setattr_prepare(). setattr_prepare() handles
> ATTR_KILL_PRIV (which remains set in ->ia_valid), and then we return,
> fall into xfs_setattr_size() and that triggers the assert failure. ISTM
> we should probably just drop ATTR_KILL_PRIV from the assert.

I dumped the ia_valid value, and it's got these bits set:

3       ATTR_SIZE
5       ATTR_MTIME
6       ATTR_CTIME
9       ATTR_FORCE
13      ATTR_FILE
14      ATTR_KILL_PRIV
15      ATTR_OPEN

so you are right about ATTR_KILL_PRIV

It's been in the assert forever, though, which is interesting?

-Eric
