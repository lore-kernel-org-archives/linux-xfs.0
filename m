Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 648CD7F4E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:50:49 -0500 (CDT)
Date: Fri, 19 Jul 2013 15:50:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: skip generic/192 if noatime is set
Message-ID: <20130719205048.GK3572@sgi.com>
References: <1372860005-1016-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372860005-1016-1-git-send-email-dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Jul 03, 2013 at 04:00:05PM +0200, David Sterba wrote:
> Test generic/192 fails if noatime is set
> 
> generic/192
>     -delta1 - access time after sleep in-core: 40
>     -delta2 - access time after sleep on-disk: 40
>     +delta1 - access time after sleep in-core: 0
>     +delta2 - access time after sleep on-disk: 0
> 
> but it's pointless to test atime effects with noatime.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks David.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
