Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 011647F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:12:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84AC7AC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 00:12:32 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id fSueFGiEaiSLuxGu
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 00:12:30 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: XFS on Fedora i686, armv7hl
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140227072122.GL29907@dastard>
Date: Thu, 27 Feb 2014 01:12:28 -0700
Message-Id: <E9A85068-46AF-496E-A997-7AFCB32F067C@colorremedies.com>
References: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
	<20140227072122.GL29907@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Feb 27, 2014, at 12:21 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 26, 2014 at 10:37:59PM -0700, Chris Murphy wrote:
>> Hi,
>> =

>> Fedora is considering XFS as their default file system. They
>> support three primary architectures: x86_64, i686, and armv7hl.
>> Do XFS devs have any reservations about XFS as a default file
>> system on either i686, or arm?
> =

> i686 is regularly tested on upstream dev kernels. ARM is less tested
> as it's not the primary development platform for anyone - we tend to
> rely on community feedback for arm because the hardware is so wide
> and varied and there are some crackpot CPU cache architectures out
> there in ARM land that we simply can't test against=85.

OK good, I'll post the URL for your response to the relevant Fedora lists.

> =

>> So far the only thing I've run into with kernel
>> 3.13.4-200.fc20.i686+PAE will not mount an XFS volume larger than
>> 16TB.
> =

> That's not an XFS limit - that's a limit of the block device caused
> by the page cache address space being limited to 16TB. Techinically
> the XFS kernel doesn't have such a limit because it doesn't use the
> block device address space to index or cache metadata, but that
> doesn't help anyone if the userspace tools don't work on anything
> larger than a 16TB block device.

Are the kernel messages regarding corruption slightly misleading? i.e. the =
file system on-disk isn't corrupt, but the kernel's view of it is distorted=
 because of the page cache limit? Someone has a weird drunken bet, because =
I can't think of a good reason why, and they mount a valued 16+TB XFS volum=
e from a 64-bit system on a 32-bit system, they don't really have to run xf=
s_repair once putting it back on the 64-bit system, do they?

> =

> As it is, you're crazy if you put more than a couple of TB of
> storage on a 32 bit system. The machiens simply don't have the
> process address space to repair a filesystem larger than a few
> terabytes (i.e. 2GB RAM limit). That holds true for any filesystem -
> ext3 and ext4 also have the same problems when running e2fsck=85

Right no kidding.

> =

>> But I haven't tried filling a < 16TB volume with a
>> significant amount of data while running 32bit, and anyway it's
>> just easier to ask if there are other gotchas, or reservations
>> about this combination.
> =

> It'll work just as well as ext3 and ext4 in such situations. That
> doesn't mean we recommend that you do it ;)

Sure. It's good to have that feedback.

> =

> I bet that's because nobody has filled a btrfs filesystem past the
> point where it tries to access beyond 16TB on a 32 bit system and so
> it's never been reported as a bug=85 :/

That makes sense.

Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
