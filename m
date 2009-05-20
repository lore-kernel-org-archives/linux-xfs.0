Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KCkDFw103418 for <xfs@oss.sgi.com>; Wed, 20 May 2009 07:46:14 -0500
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2825329B3DC
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 05:46:23 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14])
	by cuda.sgi.com with ESMTP id 7WXqOvR7lIpo46lB for
	<xfs@oss.sgi.com>; Wed, 20 May 2009 05:46:23 -0700 (PDT)
Date: Wed, 20 May 2009 06:46:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: EXT vs XFS at 80% filled filesystem
Message-ID: <20090520124622.GJ31779@parisc-linux.org>
References: <49F9565E.40804@gslab.com> <20090430183450.GB19276@mit.edu>
	<1242651808.3339.28.camel@alhena> <20090518131755.GJ32019@mit.edu>
	<1242798210.3457.4.camel@alhena> <20090520105011.GD3523@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090520105011.GD3523@mit.edu>
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
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Milind <milind@gslab.com>, xfs@oss.sgi.com

On Wed, May 20, 2009 at 06:50:11AM -0400, Theodore Tso wrote:
> The debian packages ultimately end up building e2fsprogs three times,
> with different sets of configure options.  One is the standard build,
> one is for the restricted-size build for boot floppies (which arguably
> we don't need any more since we these days CD-ROM's have plenty of
> space, and Debian doesn't support boot floppies any more) and one is
> for the static build for e2fsck.static (although the utility of that
> one is somewhat dubious given that even the shell is with shared
> library, so if the filesystem is corrupted enough that shared libaries
> don't work, it's rescue CD-ROM time; the main use for e2fsck.static is
> for emergency use when someone running an older version of Debian
> needs a newer e2fsck to fix a filesystem corruption).

If you install sash, you really do get a statically linked shell:

$ ldd /bin/sash 
ldd: exited with unknown exit code (126)
$ file /bin/sash 
/bin/sash: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, for GNU/Linux 2.6.8, stripped

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
