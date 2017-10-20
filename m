Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31671 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbdJTR51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 13:57:27 -0400
Date: Fri, 20 Oct 2017 10:56:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] generic/45[34]: force UTF-8 codeset to enable utf-8
 namer checks in xfs_scrub
Message-ID: <20171020175648.GA4741@magnolia>
References: <150836985024.27213.3715197937819365388.stgit@magnolia>
 <150836987529.27213.1335818370452284585.stgit@magnolia>
 <20171019071842.GA28970@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171019071842.GA28970@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Oct 19, 2017 at 12:18:42AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 18, 2017 at 04:37:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The upcoming xfs_scrub tool will have the ability to warn about
> > suspicious UTF-8 normalization collisions.  We want generic/45[34] to be
> > able to test this functionality, but to do that we have to forcibly set
> > the codeset to UTF-8 via LC_ALL since the rest of xfstests only uses
> > LC_ALL=C.
> 
> Wait.  Where do you want to validate UTF-8 normalization?  There is
> absolutely no guarantee that someone uses UTF-8, so any reliance on
> the character set in the file system is bogus.

I'll start by summarizing a problem statement[1].  In XFS (and nearly
all the other filesystems), neither the on-disk format nor the kernel
driver care about the contents of file names or attribute names; they
treat these as an arbitrary byte sequence.  Userspace can set whatever
localization and encoding parameters it wants, and the kernel doesn't
care except for '\0' and '/'.  That doesn't change.

In modern Linux userspace, however, we /do/ care about being able to
encode Unicode codepoints into byte streams, so we encode them in UTF8.
Because there's two different normalization methods in Unicode, this
leads to the funny situation where two unique filename byte sequences
can render the same but point to totally different files:

$ echo NFC > "$(echo -e "french_caf\xc3\xa9.txt")"
$ echo NFD > "$(echo -e "french_caf\xcc\x81.txt")"
$ ls -lai
133 -rw-r--r-- 1 root root   4 Oct 20 10:40 french_café.txt
132 -rw-r--r-- 1 root root   4 Oct 20 10:40 french_café.txt
$ echo $LANG
en_US.UTF-8

At least on my computer, the two filenames render identically yet point
to different inodes.  This could be used to mislead people into opening
a malicious file whose name appears identical to a legitimate file.

xfs_scrub is the (proposed) userspace component of XFS online fsck.  The
first four phases simply call the in-kernel fsck code and pass status
back, but the fifth phase walks the directory tree looking for problems.

If xfs_scrub (the userspace component of online fsck) was built with
libunistring and the LC_MESSAGES string contains "UTF-8", phase 5 will
warn if it finds multiple filenames in a directory that normalize to the
same string but point to different inodes.  Similarly, it will warn
about colliding attribute names.  Warnings in xfs_scrub are for
situations that warrant administrative review but are not filesystem
corruptions.

IOWs, if userspace is configured for UTF-8, the userspace part of online
fsck will flag suspicious-looking uses of Unicode for admin review.  The
kernel remains uninvolved.

--D

[1] https://eclecticlight.co/2017/04/06/apfs-is-currently-unusable-with-most-non-english-languages/

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
