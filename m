Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QLWOId219000 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 16:32:24 -0500
Subject: Re: [PATCH v4] commit.rc: Add helper for math operation using bc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317062709-2133-1-git-send-email-lczerner@redhat.com>
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
	<1317062709-2133-1-git-send-email-lczerner@redhat.com>
Date: Mon, 26 Sep 2011 16:32:17 -0500
Message-ID: <1317072737.2925.55.camel@doink>
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

On Mon, 2011-09-26 at 20:45 +0200, Lukas Czerner wrote:
> Sometimes using bash $(()) math might not be enough due to some
> limitation (big numbers), so add helper using 'bc' program. For
> now the results are only in perfect numbers (as in bash) since this is
> all I need for now.
> 
> This commit also adds _require_math() helper which should be called by
> every test which uses _math() since it requires "bc" to be installed on
> the system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks fine.  Thanks for updating it.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
