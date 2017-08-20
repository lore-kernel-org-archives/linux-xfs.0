Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56038 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753122AbdHTR7e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 Aug 2017 13:59:34 -0400
Subject: Re: xfs errors
References: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <da41ec6e-0009-6515-7c60-a48c3b07369b@sandeen.net>
Date: Sun, 20 Aug 2017 12:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

On 8/20/17 12:57 AM, ToddAndMargo wrote:
> Dear Xfs,
> 
> Do I report this to you or Red Hat?
> 
> Fedora Core 26, x564

Here is fine, or Fedora if you want, but it'll be the same people responding in any case.

> xfsdump-3.1.6-4.fc26.x86_64
> 
> When I run the following
> 
>     # /sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f /lin-bak/2017-08-19_22-30-27_md126p2.XfsDump  /
> 
> randomly, I get this error message when I run xfsdump:
> 
> 
>     /sbin/xfsdump: ino map phase 1: constructing initial dump list
>     /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 739
>     /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 954
>     /sbin/xfsdump: WARNING: failed to get bulkstat information for inode 1118
>     about 40 more of them
> 
> And the next time it will run clean.  What gives?

Most likely it's files that got deleted while xfsdump was running.  xfsdump has a bad habit of issuing warnings for things that are not actually problematic.

But you could also look for those inodes on the filesystem you're dumping; what are they?  Are they still there, or were they transient files?

If you quiesce the filesystem first, or dump from a snapshot, you should not see such errors.

-Eric

> I put a `sunc; sync` before the dump command and it seems to help, but it is random, so who knows.
> 
> Is this a bug?  Or am I doing something wrong?
> 
> Many thanks,
> -T
