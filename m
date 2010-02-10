Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AKE9eu076507 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 14:14:09 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 238D81396BB6
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:15:21 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id VGFhwAzeGfOri3aC for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:15:21 -0800 (PST)
Message-ID: <4B7313D9.9020603@sandeen.net>
Date: Wed, 10 Feb 2010 14:15:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] enable inode64 by default when possible
References: <4B7309D7.5090800@sandeen.net>
	<20100210210448.36f16aba@galadriel.home>
In-Reply-To: <20100210210448.36f16aba@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Wed, 10 Feb 2010 13:32:39 -0600 vous =E9criviez:
> =

>> As such, this patch changes the default to inode64 whenever
>> XFS_BIG_INUMS is set, which in turn depends on either
>> CONFIG_LBDAF or 64-bit longs.
> =

> But doesn't it cause problems specially for NFS sharing ?
> =


For some clients, yes - as do other NFS servers.

That's what noinode64 is for...

Also, newer nfs clients have an option:

        nfs.enable_ino64=3D
                        [NFS] enable 64-bit inode numbers.
                        If zero, the NFS client will fake up a 32-bit inode
                        number for the readdir() and stat() syscalls instead
                        of returning the full 64-bit number.
                        The default is to return 64-bit inode numbers.

(see Documentation/kernel-parameters.txt)

At some point we have to drag people kicking and screaming
out of 1988, I think! :)

(I am mindful that this may manifest itself as "xfs is incompatible"
but if we document this and advertise it a bit, I hope we can avoid
that.  At some point, apps just need to be fixed.)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
