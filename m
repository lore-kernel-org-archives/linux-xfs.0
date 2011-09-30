Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U7ZRBY247293 for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 02:35:27 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1DE01C56C05
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:35:25 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	sU8bTCDu8ODZEy5R for <xfs@oss.sgi.com>;
	Fri, 30 Sep 2011 00:35:25 -0700 (PDT)
Received: by iaeo4 with SMTP id o4so1917811iae.26
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 00:35:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317367044-475-4-git-send-email-jweiner@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
Date: Fri, 30 Sep 2011 10:35:25 +0300
Message-ID: <CAOJsxLFWfH5zDG8ui=yQyOcZY_nXhK6r+ziapLg9Zhmb3ibuWQ@mail.gmail.com>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
From: Pekka Enberg <penberg@cs.helsinki.fi>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, Shaohua Li <shaohua.li@intel.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

Hi Johannes!

On Fri, Sep 30, 2011 at 10:17 AM, Johannes Weiner <jweiner@redhat.com> wrot=
e:
> But there is a flaw in that we have a zoned page allocator which does
> not care about the global state but rather the state of individual
> memory zones. =A0And right now there is nothing that prevents one zone
> from filling up with dirty pages while other zones are spared, which
> frequently leads to situations where kswapd, in order to restore the
> watermark of free pages, does indeed have to write pages from that
> zone's LRU list. =A0This can interfere so badly with IO from the flusher
> threads that major filesystems (btrfs, xfs, ext4) mostly ignore write
> requests from reclaim already, taking away the VM's only possibility
> to keep such a zone balanced, aside from hoping the flushers will soon
> clean pages from that zone.

The obvious question is: how did you test this? Can you share the results?

                        Pekka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
