Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A427EC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685BF218AC
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgINT7s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 15:59:48 -0400
Received: from sandeen.net ([63.231.237.45]:51708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgINT7s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 15:59:48 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A12362AEA;
        Mon, 14 Sep 2020 14:59:05 -0500 (CDT)
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
References: <20200911164311.GU7955@magnolia>
 <20200914072909.GC29046@infradead.org>
 <e30d7d5e-ceec-f378-a6f9-e4a2bb3b89d7@sandeen.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <383d3088-6115-f952-2a9a-3733fbf970bb@sandeen.net>
Date:   Mon, 14 Sep 2020 14:59:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <e30d7d5e-ceec-f378-a6f9-e4a2bb3b89d7@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 2:48 PM, Eric Sandeen wrote:
> On 9/14/20 2:29 AM, Christoph Hellwig wrote:
>> On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> The V4 filesystem format contains known weaknesses in the on-disk format
>>> that make metadata verification diffiult.  In addition, the format will
>>> does not support dates past 2038 and will not be upgraded to do so.
>>> Therefore, we should start the process of retiring the old format to
>>> close off attack surfaces and to encourage users to migrate onto V5.
>>>
>>> Therefore, make XFS V4 support a configurable option.  For the first
>>> period it will be default Y in case some distributors want to withdraw
>>> support early; for the second period it will be default N so that anyone
>>> who wishes to continue support can do so; and after that, support will
>>> be removed from the kernel.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>> v3: be a little more helpful about old xfsprogs and warn more loudly
>>> about deprecation
>>> v2: define what is a V4 filesystem, update the administrator guide
>> Whie this patch itself looks good, I think the ifdef as is is rather
>> silly as it just prevents mounting v4 file systems without reaping any
>> benefits from that.
>>
>> So at very least we should add a little helper like this:
>>
>> static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
>> {
>> 	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
>> 		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
>> 	return false;
>> }
>>
>> and use it in all the feature test macros to let the compile eliminate
>> all the dead code.
>>
> Makes sense, I think - something like this?
> 
> xfs: short-circuit version tests if V4 is disabled at compile time
> 
> Replace open-coded checks for == XFS_SB_VERSION_[45] with helpers
> which can be compiled away if CONFIG_XFS_SUPPORT_V4 is disabled.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> NB: this is compile-tested only
> 
> Honestly I'd like to replace lots of the has_crc() checks with is_v5()
> as well, unless the test is specifically related to CRC use. *shrug*
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 31b7ece985bb..18b187e38017 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -283,6 +283,23 @@ typedef struct xfs_dsb {
>  /*
>   * The first XFS version we support is a v4 superblock with V2 directories.
>   */
> +
> +static inline bool xfs_sb_version_is_v4(struct xfs_sb *sbp)
> +{
> +	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> +		return false;
> +
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
> +}
> +
> +static inline bool xfs_sb_version_is_v5(struct xfs_sb *sbp)
> +{
> +	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> +		return true;
> +
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> +}

Oh, I suppose the tests in the mount path would then need to be open-coded,
won't they.  After we've gotten past that then we can assume that we only have
V5 if we've mounted successfully ....

-Eric
