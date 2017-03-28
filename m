Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33200 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbdC1THM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 15:07:12 -0400
MIME-Version: 1.0
In-Reply-To: <FEBBB5DF-1B64-468A-AD41-01E0D8D48C7A@dilger.ca>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <29458.1490711932@warthog.procyon.org.uk>
 <FEBBB5DF-1B64-468A-AD41-01E0D8D48C7A@dilger.ca>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 15:07:00 -0400
Message-ID: <CAOQ4uxhmax9bOLmx253nNxdzrXO3LP-_-QxqG9m=F34sgfVOQw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: David Howells <dhowells@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 28, 2017 at 2:40 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Mar 28, 2017, at 8:38 AM, David Howells <dhowells@redhat.com> wrote:
>>
>> Here are my current changes to Eric's statx interface patch.  I've made it
>> analoguous to the stat command and so it only does statx-of-fd.
>>
>> I've made the "-m" flag able to take the words "basic" and "all" in
>> preference to a number and able to take an octal or hex number as an
>> alternative too.
>>
>> I've dropped the -A and -L flags since it no longer passes a path over.
>>
>> Finally, I've added a -c flag that causes an fstat() to be done as well and
>> the buffers compared as a consistency check.
>
> It probably makes sense to use "-C" to avoid confusion with xfs_io's "-c"
> option, and also the "stat -c" option to dump only specific fields (which
> may be useful to add at some point in the future as well).
>

I'm afraid its not better for avoiding confusion.
-C already taken as well for new "oneshot commands"...
