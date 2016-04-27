Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6983D7D29
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 14:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B47F304051
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 12:43:52 -0700 (PDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com
	[74.125.82.65]) by cuda.sgi.com with ESMTP id NCAXCvoWUtzPrJNH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 12:43:50 -0700 (PDT)
Received: by mail-wm0-f65.google.com with SMTP id e201so16108705wme.2
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 12:43:50 -0700 (PDT)
Date: Wed, 27 Apr 2016 21:43:47 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1.1/2] xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
Message-ID: <20160427194347.GA22544@dhcp22.suse.cz>
References: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
	<1461758075-21815-1-git-send-email-mhocko@kernel.org>
	<04798BA8-2157-4611-B4EA-B8BCBA88AEC3@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <04798BA8-2157-4611-B4EA-B8BCBA88AEC3@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel <cluster-devel@redhat.com>, Linux MM <linux-mm@kvack.org>, linux-mtd@lists.infradead.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, XFS Developers <xfs@oss.sgi.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Wed 27-04-16 11:41:51, Andreas Dilger wrote:
> On Apr 27, 2016, at 5:54 AM, Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -80,13 +80,13 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> > 	 * context via PF_MEMALLOC_NOIO to prevent memory reclaim re-entering
> > 	 * the filesystem here and potentially deadlocking.
> > 	 */
> > -	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
> > +	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
> > 		noio_flag = memalloc_noio_save();
> > 
> > 	lflags = kmem_flags_convert(flags);
> > 	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
> > 
> > -	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
> > +	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
> > 		memalloc_noio_restore(noio_flag);
> 
> Not really the fault of this patch, but it brings this nasty bit of code into
> the light.  Is all of this machinery still needed given that __vmalloc() can
> accept GFP flags?  If yes, wouldn't it be better to fix __vmalloc() to honor
> the GFP flags instead of working around it in the filesystem code?

This is not that easy. __vmalloc can accept gfp flags but it doesn't
honor __GFP_IO 100%. IIRC some paths like page table allocations are
hardcoded GFP_KERNEL. Besides that I would like to have GFP_NOIO used
via memalloc_noio_{save,restore} API as well for the similar reasons as
GFP_NOFS - it is just easier to explain scope than particular code paths
which might be shared.
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
