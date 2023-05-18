Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF49FC7EE23
	for <linux-xfs@archiver.kernel.org>; Thu, 18 May 2023 14:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjEROys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 May 2023 10:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjEROys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2023 10:54:48 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13888118;
        Thu, 18 May 2023 07:54:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D15B737C;
        Thu, 18 May 2023 14:54:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D15B737C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1684421685; bh=VDTuAmUuE6L2/YiJ7ID4I3ujS1SJrkIYiPJdbnl/tAg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Dbz/T60rOjUKM7ttbVo6MhcggRTkii6bcwFeCBwPmjWw4XwYBQvDtyd26pcQUQoMS
         l7y5YeR639Iu9uvoECK8MU1DniyaQz3GQT03BF2yAGNZOba8HVlqL7or6pY8mylE9G
         WIdITReyx6y0lUB5Xhek01fB1yYkciSzy13tNsi0V1nNlYYSPW2K4ItmlSRYCt32zO
         jPbnpfsXQQwc+BvwEEWOWYBwDSDaz2yQ5dIx+RC9fnKiu7IpGaXiDRs4WN9XCFIftJ
         ABzbvXnA5SU7FwaDltu/p2BeLLCWwJECcYtrbtOlWFiONezsKAxFM8Vqt/SbreDb5h
         q7443k/ybcI5A==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Christoph Hellwig <hch@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, jake@lwn.net,
        djwong@kernel.org, dchinner@redhat.com, ritesh.list@gmail.com,
        rgoldwyn@suse.com, jack@suse.cz, linux-doc@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, p.raghav@samsung.com,
        da.gomez@samsung.com, rohan.puri@samsung.com
Subject: Re: [PATCH] Documentation: add initial iomap kdoc
In-Reply-To: <ZGY7aumgDgU0jIK0@infradead.org>
References: <20230518144037.3149361-1-mcgrof@kernel.org>
 <ZGY61jQfExQc2j71@infradead.org> <ZGY7G8gIvWCi0ONT@bombadil.infradead.org>
 <ZGY7aumgDgU0jIK0@infradead.org>
Date:   Thu, 18 May 2023 08:54:44 -0600
Message-ID: <87h6s9666j.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, May 18, 2023 at 07:50:03AM -0700, Luis Chamberlain wrote:
>> On Thu, May 18, 2023 at 07:48:54AM -0700, Christoph Hellwig wrote:
>> > > +**iomap** allows filesystems to query storage media for data using *byte ranges*. Since block
>> > > +mapping are provided for a *byte ranges* for cache data in memory, in the page cache, naturally
>> > 
>> > Without fixing your line length I can't even read this mess..
>> 
>> I thought we are at 100?
>
> Ony for individual lines and when it improves readability (whatever
> that means).  But multiple to long lines, especially full of text
> are completely unreadable in a terminal.

Long text lines are definitely unfriendly to readers in general, so I
think we should absolutely avoid them in text - where they are
unnecessary to begin with.  Something to fix for the next iteration.

I'm glad to see this document, though; it's definitely a big gap in our
current coverage.

Thanks,

jon
