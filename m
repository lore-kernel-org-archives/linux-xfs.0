Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36CF98050
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:50:12 -0500 (CDT)
Message-ID: <53458854.3030908@sgi.com>
Date: Wed, 09 Apr 2014 12:50:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: remove write-only assignments
References: <53457FAF.7060208@redhat.com>
In-Reply-To: <53457FAF.7060208@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/09/14 12:13, Eric Sandeen wrote:
> There are many instances where variable assignments are made,
> but never read (or are re-assigned before they are read).
> The Clang static analyzer finds these.
>
> Here's a chunk of what I think are trivial removals of such
> assignments; other detections point to more serious problems
> (or are shared w/ kernel code so should probably be fixed there
> first).
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> These may be a bit tedious to review; perhaps graphical diff
> w/ more context would help in some cases?
>

This patch length is not so bad. Light reading with lunch. They all look 
good to me.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
