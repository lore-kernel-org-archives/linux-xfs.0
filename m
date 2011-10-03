Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93DVVnr243978 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 08:31:32 -0500
Date: Mon, 3 Oct 2011 09:31:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] xfsprogs: tolerate mount or project errors
Message-ID: <20111003133127.GA7875@infradead.org>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317646160-5437-1-git-send-email-aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 03, 2011 at 07:49:14AM -0500, Alex Elder wrote:
> The trouble report that led to fixing this had to do with a
> situation in which automount left some sort of artifact in the list
> of mounted filesystems, and any attempt to run xfs_growfs was met
> with an error that prevented it from being run.  The errant entry in
> /proc/self/mounts contained something like this in the mnt_fsname
> field returned by getmntent(): "/tmp/auto7fGuI5 (deleted)"

I'd really like to do some sort of QA for this.  Given that xfs_quota
already has an (uncodumented) -t flag to use a replacement for
/proc/mounts and /etc/mtab this seems fairly easy to do.

If you're motivated for even more cleanups it would be good if all
xfs_quota options are actully documented, and making sure the
/proc/mounts, /etc/mtab and co handling in xfsprogs doesn't differ
for different tools.  Currently libxcmd, libxfs and xfs_fsr all
have their own variants.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
