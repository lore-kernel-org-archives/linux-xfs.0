Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47FEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 22:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiCIWT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 17:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiCIWT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 17:19:56 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9856119841
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 14:18:56 -0800 (PST)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 80ADA33503A;
        Wed,  9 Mar 2022 16:17:43 -0600 (CST)
Message-ID: <06ce8d7f-db56-d742-26d4-ced82185ab94@sandeen.net>
Date:   Wed, 9 Mar 2022 16:18:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area>
 <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
 <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
 <95ed03a8-e49b-d109-baba-86a190345102@sandeen.net>
 <20220309211904.GE661808@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220309211904.GE661808@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/9/22 3:19 PM, Dave Chinner wrote:
> On Wed, Mar 09, 2022 at 12:22:00PM -0600, Eric Sandeen wrote:

...

>> I'm wondering if we have some path through xfs_growfs_data_private() that calculates
>> a delta < 0 unintentionally, or if we get there with delta == 0 and generate the
>> warning message.
> 
> Nope, we're not even getting there for the delta == 0 case...

Ok, thanks - I should have checked that.

Soooo how is a no-argument xfs_growfs, with size calculated by the tool based on the
disk size, failing immediately after a mount? Makes no sense to me.

-Eric
