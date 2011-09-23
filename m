Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NF0opV113420 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 10:00:50 -0500
Subject: Re: [PATCH 1/2 v3] commit.rc: Add helper for math operation using bc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
Date: Fri, 23 Sep 2011 10:00:42 -0500
Message-ID: <1316790042.2879.38.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-09-23 at 16:15 +0200, Lukas Czerner wrote:
> Sometimes using bash $(()) math might not be enough due to some
> limitation (big numbers), so add helper using 'bc' program. For
> now the results are only in perfect numbers (as in bash) since this is
> all I need for now.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Clever.  This looks OK to me.  I'd like to hear what
others think.

If it gets committed maybe we should revisit tests
to see if using this function is warranted elsewhere.
Boris Ranto's recent test (which I am on the verge
of committing) in particular would be better the
way it was originally posted, making use of this.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
