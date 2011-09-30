Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U8udiF250963 for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 03:56:40 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13A96143568D
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 02:02:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dy8Fag6Gqf6tdx14 for
	<xfs@oss.sgi.com>; Fri, 30 Sep 2011 02:02:51 -0700 (PDT)
Date: Fri, 30 Sep 2011 10:55:39 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
Message-ID: <20110930085539.GD30857@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
	<CAOJsxLFWfH5zDG8ui=yQyOcZY_nXhK6r+ziapLg9Zhmb3ibuWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOJsxLFWfH5zDG8ui=yQyOcZY_nXhK6r+ziapLg9Zhmb3ibuWQ@mail.gmail.com>
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
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, Shaohua Li <shaohua.li@intel.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Fri, Sep 30, 2011 at 10:35:25AM +0300, Pekka Enberg wrote:
> Hi Johannes!
> =

> On Fri, Sep 30, 2011 at 10:17 AM, Johannes Weiner <jweiner@redhat.com> wr=
ote:
> > But there is a flaw in that we have a zoned page allocator which does
> > not care about the global state but rather the state of individual
> > memory zones. =A0And right now there is nothing that prevents one zone
> > from filling up with dirty pages while other zones are spared, which
> > frequently leads to situations where kswapd, in order to restore the
> > watermark of free pages, does indeed have to write pages from that
> > zone's LRU list. =A0This can interfere so badly with IO from the flusher
> > threads that major filesystems (btrfs, xfs, ext4) mostly ignore write
> > requests from reclaim already, taking away the VM's only possibility
> > to keep such a zone balanced, aside from hoping the flushers will soon
> > clean pages from that zone.
> =

> The obvious question is: how did you test this? Can you share the results?

Meh, sorry about that, they were in the series introduction the last
time and I forgot to copy them over.

I did single-threaded, linear writing to an USB stick as the effect is
most pronounced with slow backing devices.

[ The write deferring on ext4 because of delalloc is so extreme that I
  could trigger it even with simple linear writers on a mediocre
  rotating disk, though.  I can not access the logfiles right now, but
  the nr_vmscan_writes went practically away here as well and runtime
  was unaffected with the patched kernel. ]

			Test results

15M DMA + 3246M DMA32 + 504M Normal =3D 3765M memory
40% dirty ratio, 10% background ratio
16G USB thumb drive
10 runs of dd if=3D/dev/zero of=3Ddisk/zeroes bs=3D32k count=3D$((10 << 15))

		seconds			nr_vmscan_write
		        (stddev)	       min|     median|        max
xfs
vanilla:	 549.747( 3.492)	     0.000|      0.000|      0.000
patched:	 550.996( 3.802)	     0.000|      0.000|      0.000

fuse-ntfs
vanilla:	1183.094(53.178)	 54349.000|  59341.000|  65163.000
patched:	 558.049(17.914)	     0.000|      0.000|     43.000

btrfs
vanilla:	 573.679(14.015)	156657.000| 460178.000| 606926.000
patched:	 563.365(11.368)	     0.000|      0.000|   1362.000

ext4
vanilla:	 561.197(15.782)	     0.000|2725438.000|4143837.000
patched:	 568.806(17.496)	     0.000|      0.000|      0.000

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
