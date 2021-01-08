Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE6FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 02:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F080236F9
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 02:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAHCzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 21:55:11 -0500
Received: from sandeen.net ([63.231.237.45]:53662 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbhAHCzL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jan 2021 21:55:11 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DC18111664;
        Thu,  7 Jan 2021 20:53:02 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <862a665f-3f1b-64e0-70eb-00cc35eaa2df@redhat.com>
 <20210108012952.GO6918@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2] xfs: do not allow reflinking inodes with the dax flag
 set
Message-ID: <ec51e55e-648e-ad8b-a8dc-76b5c234637e@sandeen.net>
Date:   Thu, 7 Jan 2021 20:54:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108012952.GO6918@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/7/21 7:29 PM, Darrick J. Wong wrote:
> On Thu, Jan 07, 2021 at 03:36:34PM -0600, Eric Sandeen wrote:
>> Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
>> direct access state, i.e. IS_DAX() is true.  However, it is possible to
>> have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
>> dax, due to the flag being set after the inode was loaded.
>>
>> To avoid confusion and make the lack of dax+reflink crystal clear for the
>> user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes
>> unless DAX mode is impossible due to mounting with -o dax=never.
> 
> I thought we were allowing arbitrary combinations of DAX & REFLINK inode
> flags now, since we're now officially ok with "you set the inode flag
> but you don't get cpu direct access because $reasons"?

*shrug* I think "haha depending on the order and the state we may or may
not let you reflink files with the dax flag set on disk so good luck" is
pretty confusing, and I figured this made things more obvious.

I thought that should be an absolute, hch thought it should be ignored
for dax=never, and now ... ?

I think the the current behavior is a bad user experience violating=
principle of least surprise, but I guess we don't have agreement on that.

-Eric

> --D
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>> V2: Allow reflinking dax-flagged inodes in "mount -o dax=never" mode
>>
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index 6fa05fb78189..e238a5b7b722 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -1308,6 +1308,15 @@ xfs_reflink_remap_prep(
>>  	if (IS_DAX(inode_in) || IS_DAX(inode_out))
>>  		goto out_unlock;
>>  
>> +	/*
>> +	 * Until we have dax+reflink, don't allow reflinking dax-flagged
>> +	 * inodes unless we are in dax=never mode.
>> +	 */
>> +	if (!(mp->m_flags & XFS_MOUNT_DAX_NEVER) &&
>> +	     (src->i_d.di_flags2 & XFS_DIFLAG2_DAX ||
>> +	      dest->i_d.di_flags2 & XFS_DIFLAG2_DAX))
>> +		goto out_unlock;
>> +
>>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
>>  			len, remap_flags);
>>  	if (ret || *len == 0)
>>
> 
