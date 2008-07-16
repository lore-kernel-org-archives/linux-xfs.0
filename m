Return-Path: <cw@f00f.org>
Date: Wed, 16 Jul 2008 09:00:08 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Power loss causes bad magic number??
Message-ID: <20080716160008.GB754@puku.stupidest.org>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL> <487D5F80.1050909@sandeen.net> <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL> <20080716073503.GE29319@disturbed> <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
To: Stephen Porter <stephenp@r-s.com.au>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, sandeen@sandeen.net
List-ID: <xfs>

On Wed, Jul 16, 2008 at 06:17:37PM +1000, Stephen Porter wrote:

> Ok, my apologies, I've just done an ls of /dev/sd* and the devices
> have been remapped (any idea what would have caused that?), sdc is
> no longer sdc, it is now sda, the boot devices are now detected as
> sdb and sdc (2 mirrored physical disks, used to be sda and sdb).
> How was the machine able to boot?  I'm more confused than ever now,
> but the data is all there.

There are quite a few things that can cause devices to get 'remapped'
from the kernels point of view between reboots.  It's actually a lot
better now than it used to be.

For mount-points you need to think about labels or UUIDs if this
becomes a problem.  For booting (I've also had this happen, the boot
volume which is bios device 0x80 moved from /dev/sda to /dev/sdc) so
you need to be sure the boot-loader DTRT and also the kernel is able
to find the root file-system on boot (I think most distributions use
initrd's which can mount my label).
