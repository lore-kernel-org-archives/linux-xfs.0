Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55510 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbeCEXdL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Mar 2018 18:33:11 -0500
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
Date: Mon, 5 Mar 2018 17:33:10 -0600
MIME-Version: 1.0
In-Reply-To: <20180305223148.GG18129@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/5/18 4:31 PM, Dave Chinner wrote:
> On Mon, Mar 05, 2018 at 04:06:38PM -0600, Eric Sandeen wrote:

...

> Nope, xfs_repair is not packaged in the debian initramfs. And, well,
> on a more recently installed machine:
> 
> $ lsinitramfs /boot/initrd.img-4.15.0-rc8-amd64  |grep xfs
> lib/modules/4.15.0-rc8-amd64/kernel/fs/xfs
> lib/modules/4.15.0-rc8-amd64/kernel/fs/xfs/xfs.ko
> $
> 
> fsck.xfs isn't even in the built initramfs for a machine running
> only XFS filesystems....

Ok, well, that's a distro issue not an xfsprogs issue.  :)  Shows
that the script needs to test for presence of xfs_repair, though.

>>> Also, if the log is dirty, xfs_repair won't run. If the filesystem
>>> is already mounted read-only, xfs_repair won't run. So if we're
>>> forcing a boot time check, we want it to run unconditionally and fix
>>> any problems found automatically, right?
>>
>> Yep, I'm curious if this was tested - I played with something like this
>> a while ago but didn't take notes.  ;)
>>
>> As for running automatically and fix any problems, we may need to make
>> a decision.  If it won't mount due to a log problem, do we automatically
>> use -L or drop to a shell and punt to the admin?  (That's what we would
>> do w/o any fsck -f invocation today...)
> 
> Define the expected "forcefsck" semantics, and that will tell us
> what we need to do. Is it automatic system recovery? What if the
> root fs can't be mounted due to log replay problems?

You're asking too much.  ;)  Semantics?  ;)  Best we can probably do
is copy what e2fsck does - it tries to replay the log before running
the actual fsck.  So ... what does e2fsck do if /it/ can't replay
the log?
 
>>> I also wonder if we can limit this to just the boot infrastructure,
>>> because I really don't like the idea of users using fsck.xfs -f to
>>> repair damage filesystems because "that's what I do to repair ext4
>>> filesystems"....
>>
>> Depending on how this gets fleshed out, fsck.xfs -f isn't any different
>> than bare xfs_repair...  (Unless all of the above suggestions about dirty
>> logs get added, then it certainly is!)  So, yeah...
>>
>> How would you propose limiting it to the boot environment? 
> 
> I have no idea - this is all way outside my area of expertise...

A halfway measure would be to test whether the script is interactive, perhaps?

https://www.tldp.org/LDP/abs/html/intandnonint.html

case $- in
*i*)    # interactive shell
;;
*)      # non-interactive shell
;;

-Eric
