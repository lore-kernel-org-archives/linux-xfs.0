Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93ELTwN246290 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 09:21:29 -0500
Subject: Re: [PATCH 0/6] xfsprogs: tolerate mount or project errors
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111003133127.GA7875@infradead.org>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
	<20111003133127.GA7875@infradead.org>
Date: Mon, 3 Oct 2011 09:21:25 -0500
Message-ID: <1317651685.1972.5.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-03 at 09:31 -0400, Christoph Hellwig wrote:
> On Mon, Oct 03, 2011 at 07:49:14AM -0500, Alex Elder wrote:
> > The trouble report that led to fixing this had to do with a
> > situation in which automount left some sort of artifact in the list
> > of mounted filesystems, and any attempt to run xfs_growfs was met
> > with an error that prevented it from being run.  The errant entry in
> > /proc/self/mounts contained something like this in the mnt_fsname
> > field returned by getmntent(): "/tmp/auto7fGuI5 (deleted)"
> 
> I'd really like to do some sort of QA for this.  Given that xfs_quota
> already has an (uncodumented) -t flag to use a replacement for
> /proc/mounts and /etc/mtab this seems fairly easy to do.

Yes I agree, and that's exactly what I intend to do (and how I
was thinking of doing it).  I also owe a quota test for the
doubling of what gets reported from a month ago or so.  I
thought I could address both issues in the same test (unless
someone feels it's important to have each test have a more
specific focus).

> If you're motivated for even more cleanups it would be good if all
> xfs_quota options are actully documented, and making sure the
> /proc/mounts, /etc/mtab and co handling in xfsprogs doesn't differ
> for different tools.  Currently libxcmd, libxfs and xfs_fsr all
> have their own variants.

To be honest I kind of went further with this than I intended
to and I had to sort of put a stop to it...  I have three or
four other cleanup patches started but I just have to move on
and so posted what I have working and am content with.

I think what you suggest are all good but for now I'm not
planning to work on them.

					-Alex



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
