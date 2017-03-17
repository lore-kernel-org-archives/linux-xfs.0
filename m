Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36351 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdCQEOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 00:14:36 -0400
Received: by mail-yw0-f174.google.com with SMTP id o4so46193645ywd.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2017 21:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170315193040.GG5280@birch.djwong.org>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org> <20170315193040.GG5280@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 16 Mar 2017 22:07:41 -0600
Message-ID: <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 1:30 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Mar 15, 2017 at 12:13:55PM -0700, Darrick J. Wong wrote:
>> On Wed, Mar 15, 2017 at 12:11:22PM -0600, Chris Murphy wrote:
>> > On Wed, Mar 15, 2017 at 1:23 AM, Darrick J. Wong
>> > <darrick.wong@oracle.com> wrote:

>> > Unmounting file systems.
>> > Remounting '/tmp' read-only with options 'seclabel'.
>> > Unmounting /tmp.
>> > Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
>> > Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
>> > Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
>>
>> (I wonder why it does this three times?)
>
> Because systemd (v229, anyway) doesn't ever unmount /; it merely tries
> to remount it readonly.  Regrettably it /also/ throws away the return
> code from the mount call so there's no way to positively confirm my
> current theory, which is that we don't actually succeed at the
> remount-ro request and that's why the log needs recovery after the
> reboot.

The last line after those three is "All filesystems unmounted." So if
it isn't really unmounting, then that's a bogus message.

Also, on Btrfs I'm getting the same three remounting messages, and the
unmounted message.

Remounting '/' read-only with options
'seclabel,space_cache,subvolid=5,subvol=/'.
Remounting '/' read-only with options
'seclabel,space_cache,subvolid=5,subvol=/'.
Remounting '/' read-only with options
'seclabel,space_cache,subvolid=5,subvol=/'.
All filesystems unmounted.


> So maybe plymouthd, or journald, or systemd, or something else entirely
> still holds a writable file descriptor to somewhere on the rootfs.  I
> guess you could build a custom systemd that actually logs the return
> value....

Yuck. I'll ask on systemd list if there's a way to get more verbose
information about this without that. It really ought to be in
systemd.log_level=debug anyway.


-- 
Chris Murphy
