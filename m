Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 23:26:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l097QZqw011375
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jan 2007 23:26:37 -0800
Date: Tue, 9 Jan 2007 18:25:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and 2.6.18 -> 2.6.20-rc3
Message-ID: <20070109072535.GH44411608@melbourne.sgi.com>
References: <45A27BC7.2020709@exegy.com> <20070109012212.GG44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070109012212.GG44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Mr. Berkley Shands" <bshands@exegy.com>, Eric Sandeen <sandeen@sandeen.net>, Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

On Tue, Jan 09, 2007 at 12:22:12PM +1100, David Chinner wrote:
> On Mon, Jan 08, 2007 at 11:13:43AM -0600, Mr. Berkley Shands wrote:
> > My testbench is a 4 core Opteron (dual 275's) into
> > two LSI8408E SAS controllers, into 16 Seagate 7200.10 320GB satas.
> > Redhat ES4.4 (Centos 4.4). A slightly newer parted is needed
> > than the contemporary of Moses that is shipped with the O/S.
> > 
> > I have a standard burn in script that takes the 4 4-drive raid0's
> > and puts a GPT label on them, aligns the partitions to stripe
> > boundary's. It then proceeds to write 8GB files concurrently
> > onto all 4 raid drives.

I just ran up a similar test - single large file per device on a 4
core Xeon (woodcrest) with 16GB RAM, a single PCI-X SAS HBA and
12x10krpm 300GB SAS disks split into 3x4 disk dm raid zero stripes
on 2.6.18 and 2.6.20-rc3.

I see the same thing - 2.6.20-rc3 is more erractic and quite a
bit slower than 2.6.18 when going through XFS.

I suggest trying this on 2.6.20-rc3:

# echo 10 > /proc/sys/vm/dirty_ratio

That restored most of the lost performance and consistency
in my testing....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
