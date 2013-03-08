Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 154B17FDF
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 04:10:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4C51AC003
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 02:10:02 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id L82JRf6rLtovK2Y7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:10:01 -0800 (PST)
Received: by mail-pa0-f54.google.com with SMTP id fa10so1204454pad.27
	for <xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:10:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130304232319.GR23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<20130301111701.GB23616@dastard>
	<CANU9nTkkEd61UsM+KngGzMzXVXdOa2oXOPtmqN4xGaPuEBN_nQ@mail.gmail.com>
	<20130301205305.GD23616@dastard>
	<CANU9nTmmw3FcHRBNvu_S6Uj8M-B2JFf5poQfHbZuCbJ6_=_RgA@mail.gmail.com>
	<20130304232319.GR23616@dastard>
From: Ole Tange <tange@binf.ku.dk>
Date: Fri, 8 Mar 2013 11:09:40 +0100
Message-ID: <CANU9nTkEcPC4=5-NN5K1dchT_QGkEJUx41ZjZRy=LR9E4e_H_A@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
Cc: xfs@oss.sgi.com

On Tue, Mar 5, 2013 at 12:23 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 04, 2013 at 10:03:29AM +0100, Ole Tange wrote:
>> On Fri, Mar 1, 2013 at 9:53 PM, Dave Chinner <david@fromorbit.com> wrote:
>> :
>> > What filesystem errors occurred
>> > when the srives went offline?
>>
>> See http://dna.ku.dk/~tange/tmp/syslog.3
>
> You log is full of this:
>
> mpt2sas1: log_info(0x31120303): originator(PL), code(0x12), sub_code(0x0303)
>
> What's that mean?

We do not know, but it is something we are continually trying to find
out. We have 5 other systems using the same setup and they experience
the same.

1 of these 5 systems drop disks off the RAID but the rest work fine.
In other words: we do not experience data corruption - only disk
dropping of the RAID. That leads me to believe it is some kind of
timeout error.

>> Feb 26 00:46:52 franklin kernel: [556238.429259] XFS (md5p1): metadata
>> I/O error: block 0x459b8 ("xfs_buf_iodone_callbacks") error 5 buf
>> count 4096
>
> So, the first IO errors appear at 23:00 on /dev/sdb, and the
> controller does a full reset and reprobe. Look slike a port failure
> of some kind. Notable:
>
> mpt2sas1: LSISAS2008: FWVersion(07.00.00.00), ChipRevision(0x03), BiosVersion(07.11.10.00)
>
> From a quick google, that firmware looks out of date (current
> LSISAS2008 firmwares are numbered 10 or 11, and bios versions are at
> 7.21).

We have tried updating the firmware using LSIs own tool. That fails as
LSI tools says the firmware is not signed correctly.

> /dev/md4 had a failure (/dev/sds) around 00:19, no rebuild started.

The rebuild of md4 is now complete.

> /dev/md1 had another failure (/dev/sdj) around 00:46, this time on a
> SYNCHRONISE CACHE command (i.e. log write). This IO failure caused
> the shutdown to occur. And this is the result:
>
> [556219.292225] end_request: I/O error, dev sdj, sector 10
> [556219.292275] md: super_written gets error=-5, uptodate=0
> [556219.292283] md/raid:md1: Disk failure on sdj, disabling device.
> [556219.292286] md/raid:md1: Operation continuing on 7 devices.
>
> At this point, /dev/md1 is reporting 7 working disks and has had an
> EIO on it's superblock write, which means it's probably in an
> inconsistent state. Further, it's only got 8 disks associated with
> it and as a rebuild is in progress it means that data loss has
> occurred with this failure. There's your problem.

Yep. What I would like to see from xfs_repair is salvaging the part
that is not affected - which ought to be the primary part of the 100
TB.

> Essentially, you need to fix your hardware before you do anything
> else. Get it all back fully online and fix whatever the problems are
> that are causing IO errors, then you can worry about recovering the
> filesystem and your data. Until the hardware is stable and not
> throwing errors, recovery is going to be unreliable (if not
> impossible).

As that has been an ongoing effort it is unlikely to be solved within
a short timeframe.


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
