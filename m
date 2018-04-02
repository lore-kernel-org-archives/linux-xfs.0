Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36240 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754036AbeDBCBN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Apr 2018 22:01:13 -0400
Subject: Re: xfs_scrub: call for testing
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <CAJCQCtTA4YPxYupZjeb41dYxJGjZm1=W30mtfMPDuusNp6XjLA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <85489e2c-6527-33a8-39ea-6e66e30b3b92@sandeen.net>
Date: Sun, 1 Apr 2018 21:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTA4YPxYupZjeb41dYxJGjZm1=W30mtfMPDuusNp6XjLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 4/1/18 7:10 PM, Chris Murphy wrote:
> On Fri, Feb 2, 2018 at 2:36 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> 
>>
>> I'd really value feedback on scrub as it stand at this point -
>> Is the documentation clear?  Is the output correct?  Do the
>> tool's arguments make sense?  Does it segfault?  Does it
>> find real errors?  Does it crash your kernel? Does it
>> eat your data?
> 
> xfsprogs-4.15.1-1.fc27.x86_64
> I've built mainline 4.16.0-rc7 with CONFIG_XFS_ONLINE_SCRUB=y but I get this:
> 
> [chris@f27s ~]$ sudo xfs_scrub -T -v /mnt/fourth
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Phase 1: Find filesystem geometry.
> /mnt/fourth: using 4 threads to scrub.
> Info: /mnt/fourth: Kernel metadata repair facility not detected.
> Info: /mnt/fourth: Kernel metadata repair facility is not available.
> Use -n to scrub.

Yup, that's all it can do in that kernel.

> Info: /mnt/fourth: Scrub aborted after phase 1.
> /mnt/fourth: errors found: 1

I think we've fixed it now to not call this an error.

> Memory used: 132k/0k (17k/116k), time:  0.40/ 0.00/ 0.01s
> I/O: 84.0KiB in, 0.0B out, 84.0KiB tot
> I/O rate: 211.4KiB/s in, 0.0B/s out, 211.4KiB/s tot
> 
> Kernel message
> 
> mount
> [  329.930644] SGI XFS with ACLs, security attributes, scrub, no debug enabled
> [  329.940197] XFS (dm-16): Mounting V5 Filesystem
> [  330.553888] XFS (dm-16): Ending clean mount
> 
> scrub command
> [  373.941951] XFS (dm-16): EXPERIMENTAL online scrub feature in use.
> Use at your own risk!
> 
> 
> [chris@f27s ~]$ grep XFS linux/.config
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> # CONFIG_XFS_RT is not set
> CONFIG_XFS_ONLINE_SCRUB=y
> CONFIG_XFS_WARN=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_VXFS_FS is not set
> [chris@f27s ~]$
> 
> 
> When I try it with just -n then I get entries
> 
> Info: AG 2 superblock: Optimization is possible.
> 
> that appears to be working but it's also a noop.

So essentially it found nothing to worry about.  But it seems that
this is not particularly obvious or informative to the user when
presented this way ...

> Also the -n output has many unicode complaints with full filenames in
> the output. e.g.
> 
> Info: inode 1815560251 (27/3620923): Unicode name
> "Chapter\xc2\xa02.\xc2\xa0Securing Your Network.webloc" in directory
> should be normalized as "Chapter 2. Securing Your Network.webloc".

TBH, I don't quite understand the "should" - should according to
who, and why?  It's very difficult to determine which oddly-encoded
names are actually security risks (which is, I think, the intention
here.)

> This should be less verbose by default. Perhaps something generic
> like, "Some unicode filenames should be normalized, use -v for verbose
> output."  I don't want to have to report a scrub with a bunch of
> filenames interlaced in the output. Plus that's nothing I can or even
> want to do anything about. That file likely came from a Mac using
> netatalk or samba. Hopefully the repair mode for scrub doesn't
> normalize these files, I don't really want to find out the hard way
> that corrected files then can't be properly read over that same
> network connection or otherwise have filenames apparently mangled.

Very good points.

Personally, I've been conflicted about the whole name-checking thing.
On the one hand, you don't want to have to make two passes, because
that's not very efficient.  On the other hand, mingling name 'suggestions'
in with possible corruption errors is a good way to miss critical
information...

Thanks,
-Eric
