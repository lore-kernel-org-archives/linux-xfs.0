Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F3647F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 00:49:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC1C18F8054
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 22:49:02 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id xKs9VhSzssxN9dxv
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Oct 2013 22:48:57 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: syslinux xfs support
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131015205434.GT4446@dastard>
Date: Tue, 15 Oct 2013 23:48:49 -0600
Message-Id: <F30DFA08-BD7B-433D-BFDD-23B893FA862F@colorremedies.com>
References: <20131015203319.GA20191@infradead.org>
	<20131015205434.GT4446@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, pcacjr@zytor.com, xfs@oss.sgi.com


On Oct 15, 2013, at 2:54 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 15, 2013 at 01:33:19PM -0700, Christoph Hellwig wrote:
>> Hi Paulo,
>> =

>> just wondering what the state of the xfs support for syslinux is?  I
>> talked to Peter at Linuxcon and he thought it's merged, but looking at
>> the kernel.org tree I can't find the support.
>> =

>> Also when looking over your branches I noticed that you're using a free
>> sector in the first filesystem block to store the bootloader.  If we
>> want to go down that route we need to make sure to reserve this sector,
>> otherwise it might get taken up by newly added metadata.
> =

> It's also worth pointing out that there's no guarantee that there's
> a free sector in the first filesystem block. It's only by luck that
> there's free sectors on the default config (512 byte sector, 4
> sector sized AG headers, 4k filesystem block). If we have <=3D 2k filesys=
tem
> block there are no free "pad" sectors that can be used, 4k sectors
> mean no free sectors either, etc.
> =

> Much better would be to create a sector sized file and use fiemap to
> get the disk address of the block and feed that into the
> bootloader. That works for all filesystems without needing to know
> anything about the underlying filesystem structures=85=85

I'm curious how that would work.

The minimum bit of code for GRUB or extlinux is a lot bigger than 4KB. A ba=
sic self-generated GRUB configuration file is 5.6KB; for extlinux a basic o=
ne I have is 518 bytes. The minimum code needed to find the configuration f=
ile is ~26KB for GRUB's core.img, and ~34KB for extlinux's ldlinux.sys.

So are both of you referring to the < 440 bytes of bootstrap code that goes=
 in either the MBR or VBR, whose job is to find core.img or ldlinux.sys and=
 blindly load them?


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
