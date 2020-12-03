Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12DDC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 22:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D1722287
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 22:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgLCWVG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:21:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgLCWVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 17:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607033979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lPaD+6rFvjW8msd3YlhQBxa4s/LIdZep33Jf+STycu0=;
        b=ToZsuPXKKEvQ7dw6GdwvvIU5jKguLgnoF/wzbsSXv39+zEb/tpBW6reEQjDYTUlySxfOOj
        aTSfuVfzgi06w28wMkL1F5TOCbaHYb+bAgqUhVjvYUuc4NaQF+KlDDPoqGLBUCITmA04NC
        1/Cow35nGDd26GRigOsIK1mrQH+kff8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-FjBZ1_HBOcKVMD-dMCk9ww-1; Thu, 03 Dec 2020 17:19:37 -0500
X-MC-Unique: FjBZ1_HBOcKVMD-dMCk9ww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 915DB1005513;
        Thu,  3 Dec 2020 22:19:36 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3955D6AC;
        Thu,  3 Dec 2020 22:19:36 +0000 (UTC)
Subject: Re: [PATCH 1/2] xfs: don't catch dax+reflink inodes as corruption in
 verifier
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
 <20201203214436.GA629293@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <4db6efd8-2cf0-180c-4315-a96120e63c31@redhat.com>
Date:   Thu, 3 Dec 2020 16:19:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203214436.GA629293@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/3/20 3:44 PM, Darrick J. Wong wrote:
> On Tue, Dec 01, 2020 at 01:16:09PM -0600, Eric Sandeen wrote:
>> We don't yet support dax on reflinked files, but that is in the works.
>>
>> Further, having the flag set does not automatically mean that the inode
>> is actually "in the CPU direct access state," which depends on several
>> other conditions in addition to the flag being set.
>>
>> As such, we should not catch this as corruption in the verifier - simply
>> not actually enabling S_DAX on reflinked files is enough for now.
>>
>> Fixes: 4f435ebe7d04 ("xfs: don't mix reflink and DAX mode for now")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index c667c63f2cb0..4d7410e49db4 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -547,10 +547,6 @@ xfs_dinode_verify(
>>  	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
>>  		return __this_address;
>>  
>> -	/* don't let reflink and dax mix */
>> -	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
>> -		return __this_address;
> 
> If we're going to let in inodes with the DAX and REFLINK iflags set,
> doesn't that mean that xfs_inode_should_enable_dax needs to return false
> if REFLINK is set?

I think it does already, no?

static bool
xfs_inode_should_enable_dax(
        struct xfs_inode *ip)
{
        if (!IS_ENABLED(CONFIG_FS_DAX))
                return false;
        if (ip->i_mount->m_flags & XFS_MOUNT_DAX_NEVER)
                return false;
        if (!xfs_inode_supports_dax(ip)) <------
                return false;


----> xfs_inode_supports_dax ---> 

static bool
xfs_inode_supports_dax(
        struct xfs_inode        *ip)
{
        struct xfs_mount        *mp = ip->i_mount;

        /* Only supported on regular files. */
        if (!S_ISREG(VFS_I(ip)->i_mode))
                return false;

        /* Only supported on non-reflinked files. */
        if (xfs_is_reflink_inode(ip))
                return false;

