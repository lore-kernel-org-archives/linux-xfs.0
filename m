Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A35487D23
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 08:07:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28013AC002
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 06:07:18 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id xNE8UN4NR9p3Tc3m
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 06:07:15 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id n129so3560011wmn.1
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 06:07:15 -0700 (PDT)
Date: Wed, 27 Apr 2016 15:07:12 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1.2/2] mm: introduce memalloc_nofs_{save,restore} API
Message-ID: <20160427130712.GK2179@dhcp22.suse.cz>
References: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
	<1461758075-21815-1-git-send-email-mhocko@kernel.org>
	<1461758075-21815-2-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461758075-21815-2-git-send-email-mhocko@kernel.org>
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
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Wed 27-04-16 13:54:35, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 

Ups missed Dave's note about:

> GFP_NOFS context is used for the following 4 reasons currently
> 	- to prevent from deadlocks when the lock held by the allocation
> 	  context would be needed during the memory reclaim
> 	- to prevent from stack overflows during the reclaim because
> 	  the allocation is performed from a deep context already
> 	- to prevent lockups when the allocation context depends on
> 	  other reclaimers to make a forward progress indirectly
> 	- just in case because this would be safe from the fs POV

	- silence lockdep false positives
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
