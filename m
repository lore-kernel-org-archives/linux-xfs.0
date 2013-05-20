Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 323857F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 16:16:11 -0500 (CDT)
Date: Mon, 20 May 2013 16:16:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/14] xfs: fix missing KM_NOFS tags to keep lockdep happy
Message-ID: <20130520211607.GC20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 09:51:12AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are several places where we use KM_SLEEP allocation contexts
> and use the fact that there are called from transaction context to
			they

(fixed)

> add KM_NOFS where appropriate.

I think you're referring to the usage of PF_FSTRANS and us clearing __GFP_FS in
kmem_flags_convert?

> Unfortunately, there are several
> places where the code makes this assumption but can be called from
> outside transaction context but with filesystem locks held. These
> places need explicit KM_NOFS annotations to avoid lockdep
> complaining about reclaim contexts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  In each case you added KM_NOFS where there was no transaction and
locks would have been held.  Applied.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
