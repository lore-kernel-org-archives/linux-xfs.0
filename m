Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CFCD37F53
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 18:22:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A15DD304032
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 16:22:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rO90wasUNKjKu2lg for <xfs@oss.sgi.com>;
	Sat, 17 Oct 2015 16:22:53 -0700 (PDT)
Date: Sun, 18 Oct 2015 10:17:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
Message-ID: <20151017231759.GV27164@dastard>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<562141AD.60302@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <562141AD.60302@gmail.com>
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
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Fri, Oct 16, 2015 at 02:27:57PM -0400, Austin S Hemmelgarn wrote:
> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
> >On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
> ><ahferroin7@gmail.com> wrote:
> >>I would like to re-iterate, on both XFS and ext4, I _really_ think this
> >>should be a ro_compat flag, and not an incompat one.  If a person has the
> >>ability to mount the FS (even if it's a read-only mount), then they by
> >>definition have read access to the file or partition that the filesystem is
> >>contained in, which means that any ACL's stored on the filesystem are
> >>functionally irrelevant,
> >
> >It is unfortunately not safe to make such a file system accessible to
> >other users, so the feature is not strictly read-only compatible.
> If it's not safe WRT data integrity, then the design needs to be
> reworked, as that directly implies that isn't safe for even every
> day usage on a writable filesystem.

This is exactly what we have *incompat feature flags for*: to
protect old code that doesn't know about potentially dangerous new
on-disk formats from trying to parse those formats and causing
unpredictable bad things from happening.

Austin, your arguments hold no weight because they are no different
to the considerations for any new on-disk feature: the user needs to
have both kernel and userspace support to recover filesystems that
go bad. If you are using a brand new fs/kernel feature, then it is
expected that you know that your DR processes take this into
account.

This is also why we XFS devs wait at least a year after new on-disk
features are merged into XFS before we consider turning them on by
default. i.e.  to give distros and recovery utilities time to pick
up kernels and userspace pacakges that support the new feature
before the average user will encounter it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
