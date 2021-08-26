Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E5BC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 23:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5941560E97
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 23:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhHZXoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 19:44:34 -0400
Received: from sandeen.net ([63.231.237.45]:47880 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhHZXoe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 19:44:34 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A218679F9;
        Thu, 26 Aug 2021 18:43:23 -0500 (CDT)
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
References: <20210826173012.273932-1-bodonnel@redhat.com>
 <20210826180947.GL12640@magnolia>
 <f6ddf52a-0b85-665a-115e-106242b1af95@sandeen.net>
 <20210826220841.jsdlbquqq55cetnu@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <9a9d54bd-42a5-45c7-38b2-dec12c49defc@sandeen.net>
Date:   Thu, 26 Aug 2021 18:43:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826220841.jsdlbquqq55cetnu@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/26/21 5:08 PM, Bill O'Donnell wrote:
> On Thu, Aug 26, 2021 at 01:16:22PM -0500, Eric Sandeen wrote:
>>
>> On 8/26/21 1:09 PM, Darrick J. Wong wrote:
>>> On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:
>>
>>>> @@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
>>>>    	if (xfs_has_crc(mp))
>>>>    		sb->s_flags |= SB_I_VERSION;
>>>> -	if (xfs_has_dax_always(mp)) {
>>>> +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
>>>
>>> Er... can't this be done without burning another feature bit by:
>>>
>>> 	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
>>> 				       !xfs_has_dax_never(mp))) {
>>> 		...
>>> 		xfs_warn(mp, "DAX IS EXPERIMENTAL");
>>> 	}
>>
>> changing this conditional in this way will also fail dax=inode mounts on
>> reflink-capable (i.e. default) filesystems, no?
> 
> Correct. My original patch tests fine, and still handles the reflink and dax
> incompatibility. The new suggested logic is problematic.
> -Bill

I think that both your proposed patch and Darrick's suggestion have this problem.

"mount -o dax=inode" makes your new xfs_has_dax_inode(mp) true, and in that
conditional, if the filesystem has reflink enabled, mount fails:

# mkfs.xfs -f /dev/pmem0p1
meta-data=/dev/pmem0p1           isize=512    agcount=4, agsize=4194304 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=16777216, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8192, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -o dax=inode /dev/pmem0p1 /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/pmem0p1,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

# dmesg | tail -n 2
[  192.691733] XFS (pmem0p1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[  192.700300] XFS (pmem0p1): DAX and reflink cannot be used together!
