Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfFTT52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 15:57:28 -0400
Date: Thu, 20 Jun 2019 12:57:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/12] libxfs-diff: try harder to find the kernel
 equivalent libxfs files
Message-ID: <20190620195722.GD5402@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104944022.1172531.15814499652713220817.stgit@magnolia>
 <2721bbee-5ff4-4016-f18a-5008e86ad4ab@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2721bbee-5ff4-4016-f18a-5008e86ad4ab@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 02:53:14PM -0500, Eric Sandeen wrote:
> On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
> > files, teach the diff tool to try fs/xfs/xfs_foo.c if
> > fs/xfs/libxfs/xfs_foo.c doesn't exist.
> 
> do we really need this or should I just send a patch for the kernel
> to move it?

Nah just send a kernel patch.

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tools/libxfs-diff |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/tools/libxfs-diff b/tools/libxfs-diff
> > index fa57c004..c18ad487 100755
> > --- a/tools/libxfs-diff
> > +++ b/tools/libxfs-diff
> > @@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
> >  
> >  for i in libxfs/xfs*.[ch]; do
> >  	kfile="${dir}/$i"
> > +	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
> >  	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
> >  done
> > 
