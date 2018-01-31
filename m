Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:43280 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeAaTwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 14:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180131185843.GB4841@magnolia>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
 <CAOQ4uxhYrpY=POeATvh6GOJLNEwDrsQhvAKvyZzwcUQXGwLvDA@mail.gmail.com> <20180131185843.GB4841@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Jan 2018 21:52:13 +0200
Message-ID: <CAOQ4uxg1VkrCAeG1ssZU6N8sPGNjX-AvJmPSrf0gOUEq-TRL6Q@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

On Wed, Jan 31, 2018 at 8:58 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Jan 31, 2018 at 09:34:52AM +0200, Amir Goldstein wrote:
>> On Wed, Jan 31, 2018 at 5:56 AM, Allison Henderson
>> <allison.henderson@oracle.com> wrote:
>> > Hi everyone!
>> >
>>
>> Hi Allison!
>>
>> > Recently I have been working towards adding a new parent pointer patch set
>> > to xfs.  Briefly summarized, goal of the feature is to enable an application
>> > to quickly derive an inodes path from the mount point by storing information
>> > about the inodes parent(s) in an extended attribute.  Currently, I am aware
>> > of the intent to use the feature as part of an online scrub and repair
>> > feature.  Looking forward however, I would like to know about any other
>> > future coding intents that might make use of this feature.  For example,
>> > optimizing file system shrink or exportfs operations?  Are there certain
>> > interfaces or test cases that would be helpful to have?
>>
>> Parent pointers are going to be useful for exportfs reconnect operations.
>>
>> The interesting test cases are decoding of directory file handles with
>> cold inode cache, where the decoded file handle is of a directory that
>> is nested inside a deep and wide directory tree.
>>
>> Similarly, decoding a 'connectable' non-dir file handle for nfs export
>> of type 'subtree_check' also requires reconnecting the parent dir.
>>
>> As far as I can tell, there are two relevant interfaces that could be improved
>> by parent pointers.
>>
>> 1. get_parent()+get_name()
>> These methods are used to get subdir's name in parent dir.
>> get_name() is not currently implemented in xfs.
>> get_name() has a default implementation of linear search on parent
>> directory entries.
>> parent pointers could improve this implementation from O(# parent entries)
>> to O(# parent xattrs), without the need to change the interface.
>> I advocated storing directory parent pointer also with a constant key (without
>> parent inode and offset), so that get_name() could be improved to O(1).
>
> I'm not sure what you mean by 'constant key' -- how can you have a
> parent pointer without storing the parent inode?  Files can have
> multiple directory parents, so I don't see how that would work in the
> general case.
>
> ATM the current proposal for xfs is to store this xattr in the system
> namespace:
>
> (parent_ino, parent_gen, parent_offset) -> dirent name
>
> We need the long key to identify each parent pointer uniquely, and also
> so that we can reconstruct directories.  Most files only have one
> parent, so hopefully the performance will not be too awful, excepting
> those hardlink farm backup systems.
>

get_parent() is only called to get parent of a *directory* inode (i.e. "..").
The O(1) improvement is only for reconnecting directory file handle.
What I meant by storing the parent of a *directory* with 'constant key':

".." -> (parent_ino, parent_gen, parent_offset, dirent name)

On xfs list this idea was shot down because it special cases how
parent pointers are stored/read from directory inodes.
And I agree that for an optimization, benchmarks need to be presented.
Just putting all the options on the table for the discussion.

Cheers,
Amir.
