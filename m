Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 06:32:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VDWYqN003371
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:32:35 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A458E564D97
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:32:35 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 6hiie3KYweMSYoNS for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 06:32:35 -0700 (PDT)
Date: Fri, 31 Oct 2008 09:32:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Which FileSystem do you use on your postfix server?
In-Reply-To: <alpine.DEB.1.10.0810310810520.468@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0810310932150.468@p34.internal.lan>
References: <20081031121002.D94A11F3E98@spike.porcupine.org> <alpine.DEB.1.10.0810310810520.468@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com



On Fri, 31 Oct 2008, Justin Piszcz wrote:

>
>
> On Fri, 31 Oct 2008, Wietse Venema wrote:
>
>> Does XFS still overwrite existing files with zeros, when those
>> files were open for write at the time of unclean shutdown? This
> I believe this was fixed in an early 2.6.2x release, cc'ing xfs mailing list 
> to confirm.
>
>> would violate a basic requirement of Postfix (don't lose data after
>> fsync).  Postfix updates existing files all the time: it updates
>> queue files as it marks recipients as done, and it updates mailbox
>> files as it appends mail.
>
>

No need to respond to this, sent a reply to the postfix list:

http://oss.sgi.com/projects/xfs/faq.html#nulls

Q: Why do I see binary NULLS in some files after recovery when I unplugged 
the power?

Update: This issue has been addressed with a CVS fix on the 29th March 
2007 and merged into mainline on 8th May 2007 for 2.6.22-rc1.

XFS journals metadata updates, not data updates. After a crash you are 
supposed to get a consistent filesystem which looks like the state 
sometime shortly before the crash, NOT what the in memory image looked 
like the instant before the crash.

Since XFS does not write data out immediately unless you tell it to with 
fsync, an O_SYNC or O_DIRECT open (the same is true of other filesystems), 
you are looking at an inode which was flushed out, but whose data was not. 
Typically you'll find that the inode is not taking any space since all it 
has is a size but no extents allocated (try examining the file with the 
xfs_bmap(8) command).
