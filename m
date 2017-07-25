Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdGYQrv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 12:47:51 -0400
Received: from mail-qt0-f179.google.com (mail-qt0-f179.google.com [209.85.216.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453AE21C99
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2017 16:47:51 +0000 (UTC)
Received: by mail-qt0-f179.google.com with SMTP id r14so57366948qte.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2017 09:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170725163612.GD4369@magnolia>
References: <20170615220002.GB4530@birch.djwong.org> <20170725162054.GG18884@wotan.suse.de>
 <20170725163612.GD4369@magnolia>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Tue, 25 Jul 2017 09:47:29 -0700
Message-ID: <CAB=NE6W50at25R8=pcDAL2a3UiTsFXtZGTQvRpZUpUxzgYPw8g@mail.gmail.com>
Subject: Re: [PATCH] docs: record the metadump file format
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 25, 2017 at 9:36 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>> > +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
>> > +== Dump Obfuscation
>> > +
>> > +Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block
>> > +space and naming information to avoid leaking sensitive information into
>> > +the metadump file.  +xfs_metadump+ does not copy user data blocks.
>> > +
>> > +The obfuscation policy is as follows:
>> > +
>> > +* File and extended attribute names are both considered "names".
>> > +* Names longer than 8 characters are totally rewritten with a name that matches the hash of the old name.
>> > +* Names between 5 and 8 characters are partially rewritten to match the hash of the old name.
>>
>> Any reason for this?
>
> /me doesn't know.  Maybe it's too hard to generate a new name with the
> same hash?

I just thought of a good reason: shorter names means less information
to be able to create a unique hash and avoid clashes.

>> > +* Names shorter than 5 characters are not obscured at all.
>>
>> This does not seem like a good idea, do we have a record of why this was done
>> historically?

And likewise for smaller number of characters there could be clashes.
In fact the latest md5 clash was for 64 bytes.

But since we *really* don't want to create a reverse map at all why
not just use random characters? Sure we'd eat up entropy fast on a
system but it would seem to be a fair requirement to ask for good
entropy for this.

>> > +* Names that cross a block boundary are not obscured at all.
>>
>> Likewise.
>
> iirc we basically copy things a block at a time, which makes it harder
> to deal with multi-fsblock dirblocks (???)
>
> I don't really know, let's see if the list remembers. :)

  Luis
