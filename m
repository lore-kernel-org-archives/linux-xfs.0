Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNOaCv171605 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:24:36 -0600
Subject: Re: [PATCH v2 8/9] xfsrestore: remove nix_t
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163644.563280731@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163644.563280731@sgi.com>
Date: Fri, 12 Nov 2010 17:25:32 -0600
Message-ID: <1289604332.2315.910.camel@doink>
Mime-Version: 1.0
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> plain text document attachment (nuke_nix)
> The nix_t type is a 64-bit version of a (32-bit) nh_t, created "to
> facilitate conversion to a 64-bit offset." At this point there's only
> one case where an nh_t is converted to an off64_t, so just do an
> explicit cast in that case and remove the nix_t.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
