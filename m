Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755349AbeEHQ1G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 12:27:06 -0400
Subject: Re: [PATCH] xfs_db: add -R option
References: <20180504140244.GA32161@deer-run.com>
 <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
 <20180508161353.GA18224@deer-run.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c542d34d-3afa-c75e-32ba-9ba2df17b8d0@sandeen.net>
Date: Tue, 8 May 2018 11:27:05 -0500
MIME-Version: 1.0
In-Reply-To: <20180508161353.GA18224@deer-run.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com
Cc: linux-xfs@vger.kernel.org

On 5/8/18 11:13 AM, hal@deer-run.com wrote:

<snip totally acceptable & legit reasons for needing this> ;)

>> Otherwise I might suggest adding a switch specific to the blockget_f
>> function, which would just skip the sb_logcheck() altogether.  That would
>> be more targeted, and wouldn't be some global switch which affects
>> every current and future caller of sb_logcheck.  A warning about how
>> the log is being ignored and results may be inconsistent could then
>> be added specifically to blockget_f.

> Which sort of brings us back to the conversation that Darrick and I
> have been having. Adding a command-line switch seems wrong-- I'm fully
> convinced of that. But I'd still like to be able to blockget to try
> to work if the file system is dirty but "-r" is used.

Right, but my concern with "-r" or anything implying "readonly" as a
modifier is that check & blockget are /always/ readonly.  A readonly
modifier to a readonly command makes little sense IMHO.

> Darrick came up with one fix, which is the first patch option below.
> After staring at Darrick's suggestion a while, I came up with a
> different fix (second patch) that requires more code changes but I
> think more accurately addresses the problem statement. See previous
> messages in this thread for more detail.

Yup, I have read them.

> Let me know which you prefer and I'll submit the patch in the proper
> format to the list.

Well, I don't really like either patch for the reasons stated above.
xfs_db /can/ write to the filesystem, and -r disables that... but -r
as a modifier to affect the behavior of a read-only command is
unintuitive.

"It is only necessary to omit this flag if a command that changes data
(write, blocktrash, crc) is to be used."

What are the objections to a blockget modifier option?  That seemed like
the most direct & obvious solution to me.

"blockget/check -L : attempt to perform the blockget and check functions
even if the log contains unreplayed metadata," or something like that?

Thanks,
-Eric

> Cheers!
> 
> --Hal
> 
> 


