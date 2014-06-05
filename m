Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E72217F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 20:38:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B40530407A
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 18:38:43 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	YwYol4AjIhtmiRgb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 18:38:42 -0700 (PDT)
Received: by mail-wi0-f181.google.com with SMTP id n15so2512831wiw.14
	for <xfs@oss.sgi.com>; Wed, 04 Jun 2014 18:38:41 -0700 (PDT)
Message-ID: <538FCA1E.5070600@gmail.com>
Date: Thu, 05 Jun 2014 04:38:38 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E4E1B.1020003@gmail.com> <20140605005538.GB4523@dastard>
In-Reply-To: <20140605005538.GB4523@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

>> I think you're trying too hard to defend XFS which may be causing
>> you to miss my point. Or it could be my bad communication.
> 
> Or it coul dbe you lack the knowledge base to understand what I 
> explained to you. That happens all the time because this stuff is 
> complex and very few people actually have the time to understand
> how it is all supposed to work.

Yup, it's arcane, but I understand what you're trying to tell me, I
just don't agree. Mostly because I simply don't believe the kernel
(block device layer) won't indicate a permanent error (device gone)
and the FS needs to hold onto a FS (uuid) which it won't ever reach
again through that dead reference. Consequently I believe the FS
should be able to determine that it's time to stop blocking the use of
the FS. And since I believe it could, I think it should. .... OTOH
what seems to be happening is that the FS keeps trying to finish
writing the log entries to the journal on a device it won't ever see
again. And at the same time, it's stopping the use of the FS (uuid),
for the right reasons (I get it) but in the wrong circumstances
(device gone, no need to block, no plans to finish writing). IMHO.

> XFS can't determine correctly if it is a fatal permanent or 
> temporary error condition.

I don't believe the block device doesn't return an error codes
detailed enough to know if the device is GONE or just temporary
insane. Or is the block device layer so bad?

> Hence if we get an error from the storage (regardless of the error)
> in a situation we can't recover from, it is considered fatal
> regardless of whether the device is replugged or not. You case is a
> failed log IO, which is always a fatal, unrecoverable error....

I think you're misunderstanding me, I am not expecting the FS to
automagically start writing again after a reconnect (though I wish for
it). The old device is dead, there's a new device, the old device will
be dead until there's any reference to it, at which point the device
ID will be freed up for use. I'm merely hoping the the complete and
permanent disappearance of a disk on one device wouldn't prevent the
use of the same disk as a new device.

>> Isn't XFS just forcing me to take a manual action by accident?
> 
> No, by intent. Obvious, in-your-face intent. Filesystem corruption 
> events require manual intervention to analyse and take appropriate 
> action. You may not think it's necessary for your use case, but 
> years of use in mission critical data storage environments has 
> proven otherwise....
> 
>> Imagine, I have some files, just saved them, didn't call fsync,
>> the data is still in some cache, the cable is yanked, and the
>> data is lost. But in this case the XFS won't complain.
> 
> It does complain - it logs that it is discarding data unless a 
> shutdown has already occurred, and then it doesn't bother because 
> it's already indicated to the log that the filesystem is in big 
> trouble....

Yes, it always complains, which is not the same as what it's doing to
me, it's preventing the use of the filesystem until some processes are
killed, processes which will never ever EVER succeed in messing up the
filesystem, since the device the FS was using is dead and gone. And
the reason I'm stressing that this is accidental is because A) it
doesn't provide any benefit for the FS (no one will ever write to the
device from the old device) B) it makes me jump through hoops only on
the one PC, which means it's not a FS related hustle, it's PC related.
In which case, why am I going through it?

>> Only if there's a process. Seems more like circumstance than
>> design. Is it? Is this an actual intentional behavior.
> 
> Lazy unmount does this by intent and XFS has not control over
> this. Lazy unmount is done by your userspace software, not the
> filesystem. You're shooting the messenger.

Okay, I get that, automount is triggering the disappearance of the
mount point and the /proc/mounts entry, triggered by
udev/dbus/whatever. I get it.

>>> Yup - XFS refuses to mount a filesystem with a duplicate UUID,
>>>  preventing you from mounting the same filesystem from two 
>>> different logical block device instances that point to the
>>> same physical disk. That's the only sane thing to do in
>>> enterprise storage systems that use multi-pathing to present
>>> failure-tolerant access to a physical device.
>> 
>> Actually, IMHO it would also be sane to forget you ever saw a
>> UUID after the last underlying physical device is gone and you're
>> not going to be ever writing to this.
> 
> And how does the referenced, mounted filesystem know this? It
> can't - it actually holds a reference to the block device that got
> yanked, and internally that block device doesn't go away until the 
> filesystem releases it's reference.

But a write and read should return a different error message, doesn't
it? Doesn't the block device layer let the FS layer know that the
device is gone? Something like ENODEV, or something like it, I don't
know, something. There must be something, otherwise it's a kernel bug.
IMHO, etc.

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTj8odAAoJELsEaSRwbVYr1xwP/RkrIvq+DmF+8YUd6bSgDCe+
/HQdMOl8u5ln+h7hYwfPKniMWwnPhEx8I4VfHLNXY7S0o0iTbfpBXUacsQGc25IF
Xf3Ktv5JpW6X/pzCwAhr+ZY35NMjMR79ySjQeXeEyanEd5ghG0PP1Fsh/zQIDBpU
SdurLJirgbFufPBIJerxFtR0WKyDUAoGO0rcfsl67RaEMy4KS/Cusodb0a5UXZMd
P57Ef1rUVYoGBvh9pieplHKQIfPvW//p7B++oeWrYhQF2c+hUhWeOIfv81o7vRvn
8lYuVGgv2BLgUQ1rCi3jT5zUfy/RAW8GA5/M1AMksLgEkIOzSxavYHE+K7ALRCRt
1PXMk01KLO3VyYkE4qkArVH+vypKgd+Ma11ofYGoCTbKCjKXgeRtahzBXvvEyFrh
l4I5jNBsNB7RYiuBpEnf0Orx1cdk6no18373CtmLWRadRxJhjJiq9DHRmzr94CA6
Csnv0LpewScXmLeWeSG7EkSYUeO3KNu3rNBvhcg+tkL5XATZi4cN4kvoq+yoAhX8
sZxGtWJBNJ3ModIISOh85M6T1b8+Uu1psS3dz2vDWhhWRQu6PiuLSaDqKzift+Va
4zfUn3O1DnaRqm359swWffOWA+pOeUQSgYCrftGeeAlu6nJtgM726KbvQ+ovWJIu
LiyqWfKjJjTqqNIvyrtP
=5aBA
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
