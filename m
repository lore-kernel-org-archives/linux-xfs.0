Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:45533 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932152AbeAaQJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 11:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <20180131153025.GB15812@fieldses.org>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
 <CAOQ4uxhYrpY=POeATvh6GOJLNEwDrsQhvAKvyZzwcUQXGwLvDA@mail.gmail.com> <20180131153025.GB15812@fieldses.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Jan 2018 18:09:43 +0200
Message-ID: <CAOQ4uxjfhQ2_rdHswRFU+oshusV0YuqVvM5spO_uqOS2=xJifQ@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Allison Henderson <allison.henderson@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>

On Wed, Jan 31, 2018 at 5:30 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Wed, Jan 31, 2018 at 09:34:52AM +0200, Amir Goldstein wrote:
>> If filesystem were to provide a parents iterator interface, something like:
>> get_acceptable_parent(child, acceptable, context)
>> then xfs could iterate inode parents and call the nfsd_acceptable() callback.
>> For filesystems that support get_acceptable_parent(), there is no need to
>> encode a 'connectable' non unique file handle.
>>
>> I am not sure how much of a problem the 'subtree_check' and non-unique
>> file handle is for nfsd (CC nfsd folks for that), but I know I can make good use
>> of that in overlayfs, as well as with an optimized get_name() implementation.
>
> I hate subtree-checking and wish people would just stop trying to export
> subtrees.
>
> That said, anything that makes it less painful is probably good.
>
> And, yes, the fact that filehandles can change when a file is renamed
> across directories can be a problem for people using subtree checking.
>

Let's talk about your feeling about 'subtree_check' ...

I hate security in general and wish that users would let us develop cool
stuff and stop worrying so much about their hopeless quest for secure
systems ;-)

That said, I don't believe they will listen to us cool reckless guys.
So despite your feeling, I am guessing that 'subtree_check' is here to stay
and that nfsd should strive to a solution of unique and connectable
file handles from filesystems that can support it.

The question is: is the interface I proposed going to be adequate for
'subtree_check' requirement. Meaning, with current 'subtree_check'
implementation, the decoded dentry is guarantied to have the same
parent that was used for encoding the non-dir, although it does not
guaranty to get the exact same alias. With the interface I proposed
get_acceptable_parent() could decode an alias that is not even
under the original parent directory. Do you see that as a problem?

Cheers,
Amir.
