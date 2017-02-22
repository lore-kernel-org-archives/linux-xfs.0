Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35253 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932295AbdBVNJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2017 08:09:39 -0500
Received: by mail-ua0-f170.google.com with SMTP id 40so1270174uau.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2017 05:09:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170222130028.mrl6yimvwlj4zjid@eorzea.usersys.redhat.com>
References: <CADWLRhrkA6pa_OeddSf281Lr+53JyEp5dxaHc+KTJPRLShWvkQ@mail.gmail.com>
 <20170222130028.mrl6yimvwlj4zjid@eorzea.usersys.redhat.com>
From: Vaibhaw Pandey <vaibhaw@scalegrid.io>
Date: Wed, 22 Feb 2017 18:39:37 +0530
Message-ID: <CADWLRhpwHqGawvXHX2KSJ9yCsqYcNbBGoStue1KKuMMFC7upqw@mail.gmail.com>
Subject: Re: Consider these for the XFS FAQ wiki
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaibhaw Pandey <vaibhaw@scalegrid.io>, linux-xfs@vger.kernel.org

Carlos,

> Comparing XFS with EXT4 is not really the goal of xfs.org, and adding things
> such as: ext4 do/don't do this, will just feed the filesystem war that
> happens so often over internet, and most of us around here are tired of that. It
> would just be another source (and official) of information  to feed such hot
> and pointless discussions about it, I've seen even the simplest differences
> being used as fuel for crappy discussions.

I should have probably phrased the questions better then. :) I do not
much care about ext4 but wanted that general XFS behavior (journal
size, replace-by-rename) and design choices (e.g. sync rate) that
should be available for folks to find easily and authoritatively so
that they don't spend too much time finding it. You folks, obviously,
are the best judge.

Thanks,
Vaibhaw


On Wed, Feb 22, 2017 at 6:30 PM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> Hello,
>
>> I would suggest the following questions:
>>
>> 0. Does XFS support a mount option equivalent to ext4's auto_da_alloc?
>> i.e. Does XFS have the workarounds to support the replace by truncate
>> and replace by rename?
>> Ans:
>> Answered exactly in http://oss.sgi.com/archives/xfs/2015-12/msg00553.html
>>
>> 1. Does XFS support a mount option equivalent to ext4's commit? i.e.
>> How do I control how often does XFS sync to disk? Or Does XFS never
>> sync to disk until a sync/fsync is called?
>>
>> Ans:
>> Answered here: http://article.gmane.org/gmane.comp.file-systems.xfs.general/53376
>> Reproducing from source:
>> <snip>
>> By and large, buffered IO in a filesystem is flushed out by the vm,
>> due to either age or memory pressure.  The filesystem then responds
>> to these requests by the VM, writing data as requested.
>>
>> You can read all about it in
>> https://www.kernel.org/doc/Documentation/sysctl/vm.txt See
>> dirty_expire_centisecs and dirty_writeback_centisecs - flushers wake
>> up every 30s and push on data more than 5s old, by default.
>> </snip>
>
> Comparing XFS with EXT4 is not really the goal of xfs.org, and adding things
> such as: ext4 do/don't do this, will just feed the filesystem war that
> happens so often over internet, and most of us around here are tired of that. It
> would just be another source (and official) of information  to feed such hot
> and pointless discussions about it, I've seen even the simplest differences
> being used as fuel for crappy discussions.
>
> Filesystems have different features and handle issues in different ways, in XFS
> for example, there is no mount option to fix the sync-on-close-after-truncate,
> such behavior is enforced, as mentioned in the thread pointed by you above,
> IMHO, FAQ is not a place for bug fixes history, git log does that.
>
> I wouldn't object to have some information about sync-after-rename, but it still
> is some extra fuel for such discussions (it it has already been before).
>
> Regarding the ext4's 'commit' option, as Eric said in the thread, it's VM
> responsibility to request a flush to the filesystem, and this, to act as
> requested, I wouldn't object to have something like: "xfs flushes buffered IO as
> requested by the VM", but, still, it's buffered IO design, and XFS has no "for a
> commit every X seconds" optiosn, so, still sounds pointless to me to have it in
> a FAQ.
>
> Anyway, I am not the xfs.org maintainer, and this is just my opinion anyway :)
> Everytime somebody says something about posting a filesystem comparison, my eyes
> burns :)
>>
>> 2. What is the maximum size of the XFS journal?
>> Ans: Not sure. But this is the closest answer I could find:
>> https://serverfault.com/questions/367973/xfs-maximum-log-size-sw-raid-10-mdadm-sles-11-sp1
>
> This should go to mkfs.xfs manpage also :)
>
> Cheers.
>
> --
> Carlos
