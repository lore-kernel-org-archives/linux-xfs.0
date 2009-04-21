Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LENccY132181 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 09:23:38 -0500
Received: from pond.fysh.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECC5822BCAD
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 07:23:34 -0700 (PDT)
Received: from pond.fysh.org (pond.fysh.org [166.84.7.109]) by cuda.sgi.com
	with ESMTP id 2LwYHOScO7GurXKc for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 07:23:34 -0700 (PDT)
Received: from mike by pond.fysh.org with local (Exim 4.69 #1 (Debian))
	id 1LwGso-0002Ku-2D
	for xfs@oss.sgi.com; Tue, 21 Apr 2009 15:23:34 +0100
Date: Tue, 21 Apr 2009 15:23:34 +0100
From: Mike Ashton <mike@fysh.org>
Subject: fsck.xfs proposed improvements
Message-ID: <20090421142333.GA5197@fysh.org>
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello folks,

I've been using XFS as my filesystem of choice for many, many years
now and for all the years of, er, joy, I have encountered a few
difficulties with filesystem recovery after machine crashes/hard
reboots and so on.  Google confirms that I'm not alone in this.

You're all probably perfectly well aware that fsck.xfs is a shell
script that does nothing much, on the premise that XFS has a journal
and therefore doesn't suffer from the routine corruption of more
primitive filesystems.  However, I have found that the journal itself
is prone to corruption (bad clientid, and friends) on contemporary,
even enterprise class, hardware.  Now I don't doubt this is due to
stupidities in the underlying hardware - SATA disks' naughty
non-battery write caches or what have you - and XFS is not to blame,
but I feel we maybe need to be more pragmatic about these annoying
realities.

I'm also sure that this is not the first time this design decision has
been challenged, although a search of the list archives implies that
it hasn't been suggested in the forum.  Forgive me if I'm wrong there.

I'm here to make the case for fsck.xfs being enhanced to verify the
journal and invoke xfs_repair -L in the event that it's screwed.  Now,
I'm sure half of you just sprayed coffee at the screen and are already
firing up an angry reply, but bear with me.  Automatic filesystem
repair is a normal, everyday necessity.  It's what non-journaling
filesystems do all the time; the days of offering the sysadmin the
choice of whether to repair this inode count, or that dnode entry are
long gone.  A filesystem with a corrupted journal is no use to me; I'm
not going to be able to repair the journal.  All I'm going to do is
invoke xfs_repair -L and pray.  I'm happy for that, *as an option* (
as it is on all fsck invocations) to happen on boot without my
intervention.  

I'd like that to happen.  I do not accept that fsck.xfs has a null
function.  The filesystem is kept consistent by the journal, but the
journal needs to be verified and the filesystem repaired otherwise.
Otherwise, fsck passes, mount fails, my computer doesn't boot and that
makes me a sad panda.  Thankfully this would be a pretty quick
operation - I'm sure there's a lot of cleverness that could be
incorporated into a binary fsck.xfs that could detect, report on and
repair all sorts of exciting situations, but you can even do it
primitively in shell by simply trying to mount it.  I've included an
example of what I mean at the end.

Hopefully, you'll give this some serious consideration.  I'm quite
sure this is going to end up being a bun-fight issue, but I'm in no
way implying that you didn't think about what you were doing when you
made the decision to make mkfs.xfs do nothing.  I'm just asking that
you consider again whether it now needs to do something, because that
hasn't worked as a strategy, even if that is due to hardware
manufacturers cutting corners.

Thanks,
Mike.

#!/bin/sh -f
#
# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
#

AUTO=false
while getopts ":aApy" c
do
        case $c in
        a|A|p|y)        AUTO=true;;
        esac
done
eval DEV=\${$#}
if [ ! -e $DEV ]; then
        echo "$0: $DEV does not exist"
        exit 8
fi
if $AUTO; then
# rw initrd should allow mkdir but direct mounting of / read-only, we require to have a /mnt already
        mkdir -p /mnt
        if [ ! -d /mnt ]
        then
                echo no /mnt to test XFS journal recovery
                exit 0
        fi
        if mount -t xfs "$DEV" /mnt -o ro,norecovery
        then
                umount /mnt
                echo "$DEV is an xfs filesystem"
                if mount -t xfs "$DEV" /mnt
                then
                        echo "Recovery by journal successful"
                        umount /mnt
                else
                        echo "writable mount of $DEV failed - invoking xfs_repair"
                        xfs_repair -L "$DEV"
                fi
        else
                echo "$DEV appears not to be an xfs filesystem"
        fi
else
        echo "If you wish to check the consistency of an XFS filesystem or"
        echo "repair a damaged filesystem, see xfs_check(8) and xfs_repair(8)."
fi
exit 0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
