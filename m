Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997FEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 05:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiCaFX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 01:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiCaFX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 01:23:27 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72D352C65D
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 22:21:40 -0700 (PDT)
Received: from [192.168.200.47] (dhcp-72-235-93-236.hawaiiantel.net [72.235.93.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AD32578F7;
        Thu, 31 Mar 2022 00:19:54 -0500 (CDT)
Message-ID: <2023e153-06bc-81fb-e190-edd7a3f5f88e@sandeen.net>
Date:   Wed, 30 Mar 2022 19:21:36 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Eric Sandeen <esandeen@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738661360.3191861.16773208450465120679.stgit@magnolia>
 <822cdfdc-358f-669e-d2db-31745643d614@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/5] mkfs: don't let internal logs consume more than 95%
 of an AG
In-Reply-To: <822cdfdc-358f-669e-d2db-31745643d614@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/16/22 8:50 AM, Eric Sandeen wrote:
> On 3/15/22 6:23 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Currently, we don't let an internal log consume every last block in an
>> AG.  According to the comment, we're doing this to avoid tripping AGF
>> verifiers if freeblks==0, but on a modern filesystem this isn't
>> sufficient to avoid problems.  First, the per-AG reservations for
>> reflink and rmap claim up to about 1.7% of each AG for btree expansion,
> 
> Hm, will that be a factor if the log consumes every last block in that
> AG? Or is the problem that if we consume "most" blocks, that leaves the
> possibility of reflink/rmap btree expansion subsequently failing because
> we do have a little room for new allocations in that AG?
> 
> Or is it a problem right out of the gate because the per-ag reservations
> collide with a maximal log before the filesystem is even in use?

Darrick, any comment on this? What did you actually run into that prompted
this change?

Still bugs me a little that a manually-sized log escapes this limit, and if
it's needed for proper functioning, we should probably enforce it everywhere.

I do understand that the existing code only validates auto-sized logs. But
I don't want to sweep this under the rug, even if we choose to not fix it all
right now.

Mostly looking for clarification on the what fails and how, with the current
code.

Thanks,
-Eric
