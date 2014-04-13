Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEE727F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 07:44:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE7B930407F
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 05:44:00 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id tsMknQpwCGARbi0R (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 05:43:59 -0700 (PDT)
Date: Sun, 13 Apr 2014 08:43:53 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] generic/237: fix filtering for expected failure
	message
Message-ID: <20140413124353.GD14599@thunk.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
	<1397343317-14669-4-git-send-email-tytso@mit.edu>
	<20140413081738.GA5331@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140413081738.GA5331@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Apr 13, 2014 at 01:17:38AM -0700, Christoph Hellwig wrote:
> On Sat, Apr 12, 2014 at 06:55:17PM -0400, Theodore Ts'o wrote:
> > Newer kernels return EACCES instead of EPERM when modifying an acl
> > fails.  Update the filtering to handle this.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> I've not seen this yet.  What exact configuration do you use to get the
> error?

I was using a 32-bit kernel, using a recent Linus upstream.  The bug
was showing up for both ext4 and xfs, and xfstests-bld is using a very
recent version of the acl package?

If you're not seeing it, perhaps the most likely cause would be the
fact that I was using an i386 kernel, and/or the version of the acl
userspace package found in kvm-xfstests?

If you want a repro, you could grab:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

and then building the per the README.

If you don't have a Debian testing system conviently to hand, you
could pull down:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.i386

... and then update the image to have the xfstests upstream version of
/root/xfstests/tests/generic/237*.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
