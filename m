Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbeB0AP2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 19:15:28 -0500
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com [209.85.223.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D32217C0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2018 00:15:27 +0000 (UTC)
Received: by mail-io0-f169.google.com with SMTP id h23so8656007iob.11
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 16:15:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
References: <20180226224224.GE19312@magnolia> <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Mon, 26 Feb 2018 16:15:06 -0800
Message-ID: <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
Subject: Re: [RFC] mkfs config file bikeshed now!
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Tso Ted <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 4:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 2/26/18 6:01 PM, Luis R. Rodriguez wrote:
>>  IIRC with e2fsprogs profile parsers we could end up with something
>> like:
>>
>> [defaults]
>> foo=0
>> bar=0
>> [stuff]
>>       some_release =  {
>>               foo=1
>>               bar=2
>>       }
>>       new_release = {
>>               foo=2
>>       }
>
> I can't tell what that means.  What's "stuff?"  Why would we need this sort of
> nesting?

I'll leave the crafty examples to Darrick as he had some complex ideas
in mind. On my part I was happy to not have to deal with the namespace
stuff -- however I realized some may want it, so I had to mention both
libraries libini_config and e2fsprogs profile parser do support it,
just in different ways.

 Luis
