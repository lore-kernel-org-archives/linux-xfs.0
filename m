Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 13:38:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FKchWt027338
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 13:38:44 -0700
Message-ID: <4672F7A7.9040904@sandeen.net>
Date: Fri, 15 Jun 2007 15:33:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Tunables for High Speed Linux SW RAID5 Systems?
References: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

Justin Piszcz wrote:
> Hi,
> 
> I was wondering if the XFS folks can recommend any optimizations for high 
> speed disk arrays using RAID5?
> 
> As well as if there is anything else I can do on the MD side?
> 
> fs.xfs.restrict_chown = 1
> fs.xfs.irix_sgid_inherit = 0
> fs.xfs.irix_symlink_mode = 0

OT but...

/me wonders if some of these could go away by now... :)

-Eric

> fs.xfs.panic_mask = 0
> fs.xfs.error_level = 3
> fs.xfs.xfssyncd_centisecs = 3000
> fs.xfs.inherit_sync = 1
> fs.xfs.inherit_nodump = 1
> fs.xfs.inherit_noatime = 1
> fs.xfs.xfsbufd_centisecs = 100
> fs.xfs.age_buffer_centisecs = 1500
> fs.xfs.inherit_nosymlinks = 0
> fs.xfs.rotorstep = 1
> fs.xfs.inherit_nodefrag = 1
> fs.xfs.stats_clear = 0
> 
> There is also vm/dirty tunable in /proc.
> 
> I was wondering what are some things to tune for speed?  I've already 
> tuned the MD layer but is there anything with XFS I can also tune?
> 
> echo "Setting read-ahead to 64MB for /dev/md3"
> blockdev --setra 65536 /dev/md3
> 
> echo "Setting stripe_cache_size to 16MB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> 
> (also set max_sectors_kb) to 128K (chunk size) and disable NCQ
> 
> Justin.
> 
> 
