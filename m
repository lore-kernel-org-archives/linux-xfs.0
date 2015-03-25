Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A8917F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 11:56:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76B88304043
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 09:56:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ivyabv6iuOUm05fu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 09:56:39 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2PGuctM007568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 12:56:38 -0400
Received: from laptop.bfoster (vpn-49-154.rdu2.redhat.com [10.10.49.154])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2PGuavP029005
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 12:56:38 -0400
Date: Wed, 25 Mar 2015 12:56:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2] xfs: avoid overflow of attr3 leaf block headers with
	64k blocks
Message-ID: <20150325165636.GA3436@laptop.bfoster>
References: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On Tue, Feb 24, 2015 at 03:50:22PM -0500, Brian Foster wrote:
> Hi all,
> 
> As it turns out, some of the leaf block codepaths other than xattr
> addition look like they wouldn't work properly with an unaligned
> firstused value as demonstrated in my previous patch:
> 
> http://oss.sgi.com/archives/xfs/2015-02/msg00479.html
> 
> Here's an alternate approach that handles the overflow in the header
> conversion functions. It passes the basic tests so far, but more testing
> is needed to make sure I've made valid assumptions. Thoughts?
> 
> FWIW, another approach could be to leak the last few bytes of the blocks
> (e.g., max firstused at the last valid aligned offset and update freemap
> size accordingly)...
> 

ping?

> Brian
> 
> Brian Foster (2):
>   xfs: pass attr geometry to attr leaf header conversion functions
>   xfs: use larger in-core attr firstused field and detect overflow
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 99 +++++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  6 ++-
>  fs/xfs/libxfs/xfs_da_format.h |  8 +++-
>  fs/xfs/xfs_attr_inactive.c    |  3 +-
>  fs/xfs/xfs_attr_list.c        |  9 ++--
>  5 files changed, 86 insertions(+), 39 deletions(-)
> 
> -- 
> 1.9.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
