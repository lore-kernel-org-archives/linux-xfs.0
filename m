Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAFB57CA4
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 12:42:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B3C0304048
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 10:42:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id xIjIcvHJiXW8nsp6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 10:42:48 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 71B6B2045A
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 19:42:46 +0200 (CEST)
Date: Tue, 9 Aug 2016 19:41:58 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 11/14] replace statvfs64 by equivalent statvfs
Message-ID: <20160809174158.GA4476@nyan>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
	<20160809074010.GM25647@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809074010.GM25647@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sun, Aug 07, 2016 at 08:24:40AM +0200, Felix Janda wrote:
> > For this it was necessary to change a workaround for missing
> > f_brsize on Mac OS X.
> 
> If we can get rid of that it'd be fine, but can you explain a bit
> more why we can get rid of it?

Since we are using transparent LFS, statvfs64 is the same as statvfs,
if statvfs64 is defined at all. In commit b35b4eb8f91d13a326213f989e
it was noticed that OS X is missing statvfs64, and a define was added
to darwin.h. The same commit also fixes the absense of the f_brsize
field in struct statfs on OS X by adding code conditional on the
statvfs64 define. (Notice that this condition might have false
positives. Indeed, on linux with musl libc, statvfs64 is also a
define.)

This patch removes the usage of statvfs64 and thus one of the problems
for Mac OS X. The other problem is solved by giving a suitable
definition of f_brsize. Note that this might collide with other uses
of f_brsize (if they exist). It might be cleaner to just check for Mac
OS X in xfs_fsr.c.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
