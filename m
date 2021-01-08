Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099E9C433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D101023A9D
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbhAHV2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:28:15 -0500
Received: from sandeen.net ([63.231.237.45]:46100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbhAHV2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Jan 2021 16:28:02 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3A8A64872F4;
        Fri,  8 Jan 2021 15:25:53 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
Date:   Fri, 8 Jan 2021 15:27:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108212132.GS38809@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/8/21 3:21 PM, Darrick J. Wong wrote:
> On Sat, Jan 09, 2021 at 03:09:17AM +0800, Gao Xiang wrote:
>> Such usage isn't encouraged by the kernel coding style.
>>
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
>>  fs/xfs/xfs_fsops.c     | 12 ++++++------
>>  fs/xfs/xfs_fsops.h     |  4 ++--
>>  fs/xfs/xfs_ioctl.c     |  4 ++--
>>  4 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2a2e3cfd94f0..a17313efc1fe 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -308,12 +308,12 @@ struct xfs_ag_geometry {
>>  typedef struct xfs_growfs_data {
>>  	__u64		newblocks;	/* new data subvol size, fsblocks */
>>  	__u32		imaxpct;	/* new inode space percentage limit */
>> -} xfs_growfs_data_t;
>> +};
> 
> So long as Eric is ok with fixing this up in xfs_fs_compat.h in
> userspace,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Sure, why not :) (tho is growfs really a public interface?  I guess so,
technically, though not documented as such.)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

