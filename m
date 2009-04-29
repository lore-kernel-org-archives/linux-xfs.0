Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TElYUr166595 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:47:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF3E224CBB0
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:47:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hPj9ULY9mAAX5BqH for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:47:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LzB4Q-0003vw-EK
	for xfs@oss.sgi.com; Wed, 29 Apr 2009 14:47:34 +0000
Date: Wed, 29 Apr 2009 10:47:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: release.sh, take two
Message-ID: <20090429144734.GA15044@infradead.org>
References: <20090429141108.GA14578@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090429141108.GA14578@infradead.org>
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
To: xfs@oss.sgi.com

On Wed, Apr 29, 2009 at 10:11:08AM -0400, Christoph Hellwig wrote:
> A new release script, now using Makepkgs to simply things.  Needs to
> be run from the repository directory.
> 
> Anyone fine with commiting a copy to each of the repositories?

And now with actual content:


#!/bin/sh

. VERSION

version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
date=`date +"%-d %B %Y"`

echo "Updating CHANGES"
sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
	mv doc/CHANGES.tmp doc/CHANGES

echo "Commiting CHANGES update to git"
git-commit -a -m "${version} release"

echo "Tagging git repository"
git-tag v${version}

echo "Creating source tarball in build/tar/"
./Makepkgs

echo "Done."
echo "Please remember to push out tags using \"git push --tags\""

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
