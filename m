Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2A7C11F66
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB5561106
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbhGNJaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:30:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:19138 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238189AbhGNJaw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 05:30:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210358873"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="210358873"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:27:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="494390723"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.169.74]) ([10.249.169.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:27:56 -0700
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org> <20210412154808.GA1670408@magnolia>
 <20210413165313.GA1430582@infradead.org>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <f074c562-774d-fb35-b6a2-01c3873bb6ec@intel.com>
Date:   Wed, 14 Jul 2021 17:27:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210413165313.GA1430582@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/14/2021 12:53 AM, Christoph Hellwig wrote:
> On Mon, Apr 12, 2021 at 08:48:08AM -0700, Darrick J. Wong wrote:
>> A couple of revisions ago I specifically asked Gustavo to create these
>> 'silly' sizeof helpers to clean up...
>>
>>>> -					(sizeof(struct xfs_efd_log_item) +
>>>> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
>>>> -					sizeof(struct xfs_extent)),
>>>> -					0, 0, NULL);
>>>> +					 struct_size((struct xfs_efd_log_item *)0,
>>>> +					 efd_format.efd_extents,
>>>> +					 XFS_EFD_MAX_FAST_EXTENTS),
>>
>> ...these even uglier multiline statements.  I was also going to ask for
>> these kmem cache users to get cleaned up.  I'd much rather look at:
>>
>> 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
>> 				sizeof_xfs_efi(XFS_EFI_MAX_FAST_EXTENTS), 0);
>> 	if (!xfs_efi_zone)
>> 		goto the_drop_zone;
>>
>> even if it means another static inline.
> 
> Which doesn't really work with struct_size or rather leads to a mess
> like the above as struct_size really wants a variable and not just a
> type.  Making it really nasty for both allocations and creating slab
> caches.  I tried to find a workaround for that, but that makes the
> compiler unhappy based its inlining heuristics.
> 
> Anyway, a lot of the helpers are pretty silly as they duplicate stuff
> without cleaning up the underlying mess.  I tried to sort much of this
> out here, still WIP:
> 
> http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-array-size
> 

Hi xfs maintainers,

Kindly ping, is there any new progress on this patch series?

Best Regards,
Rong Chen
