Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56214 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbdC1WM1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 18:12:27 -0400
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <29458.1490711932@warthog.procyon.org.uk>
 <FEBBB5DF-1B64-468A-AD41-01E0D8D48C7A@dilger.ca>
 <CAOQ4uxhmax9bOLmx253nNxdzrXO3LP-_-QxqG9m=F34sgfVOQw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <60657a0d-3e24-18d7-ec35-9758fefdf28c@sandeen.net>
Date: Tue, 28 Mar 2017 17:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhmax9bOLmx253nNxdzrXO3LP-_-QxqG9m=F34sgfVOQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Andreas Dilger <adilger@dilger.ca>
Cc: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On 3/28/17 2:07 PM, Amir Goldstein wrote:
> On Tue, Mar 28, 2017 at 2:40 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On Mar 28, 2017, at 8:38 AM, David Howells <dhowells@redhat.com> wrote:
>>>
>>> Here are my current changes to Eric's statx interface patch.  I've made it
>>> analoguous to the stat command and so it only does statx-of-fd.
>>>
>>> I've made the "-m" flag able to take the words "basic" and "all" in
>>> preference to a number and able to take an octal or hex number as an
>>> alternative too.
>>>
>>> I've dropped the -A and -L flags since it no longer passes a path over.
>>>
>>> Finally, I've added a -c flag that causes an fstat() to be done as well and
>>> the buffers compared as a consistency check.
>>
>> It probably makes sense to use "-C" to avoid confusion with xfs_io's "-c"
>> option, and also the "stat -c" option to dump only specific fields (which
>> may be useful to add at some point in the future as well).
>>
> 
> I'm afraid its not better for avoiding confusion.
> -C already taken as well for new "oneshot commands"...

There's no conflict here AFAICT; the "-C" for oneshot is for
xfs_io invocation; individual commands are free to re-use such
options for their own purposes.

i.e.:

# xfs_io -C "command -C" file

is fine; the two different -C args have different contexts.  Adding a
-C to the statx command poses no problem.

And with that public service announcement let me go read this thread and
catch up... ;)

-Eric

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
