Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38E197F37
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:22:06 -0500 (CDT)
Date: Mon, 18 Mar 2013 13:22:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Xfs_repair and journalling
Message-ID: <20130318182202.GD22182@sgi.com>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Hi Subranshu,

On Sun, Mar 17, 2013 at 05:12:36PM +0530, Subranshu Patel wrote:
> What I understand is that, XFS being a journalling filesystem makes running
> xfs_repair after a unclean unmount unnecessary.

You are correct.

> After a system crash or force power down, one can mount the filesystem
> which causes the journal to be replayed and handles the half finished
> writes. This is one part. But there can be other file corruption as well
> and these can be handled by xfs_repair.

As Dave mentioned, XFS only journals metadata.  Unwritten cached file contents
will not be recovered in this situation.

> So the crux is to mount the filesystem so that journal will be replayed,
> and then unmount the filesystem and run xfs_repair. (Assuming xfs_repair
> may not be a mandatory step always)

If you are set up correctly, (e.g. write caches are turned off on your disk)
you shouldn't even need to unmount the filesystem an run xfs_repair.

See this section of the xfs faq for more about write caches:
http://www.xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F

> In case of EXT4, journal will not be replayed on performing mount. One need
> to invoke fsck which performs journal playback and then other corruption
> checks/recovery.

I can't speak for ext4.  I do think that your expectation that fsck/repair be
able to replay a journal is pretty reasonable.  That's just not how it is
implemented here.  In xfs, log recovery is in the kernel and xfs_repair knows
just enough about the log to avoid clobbering your precious metadata when it
needs to be recovered.  There was some discussion in the past about making
xfs_repair able to recover the log but I wouldn't expect that any time soon.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
