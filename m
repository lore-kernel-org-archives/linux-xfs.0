Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7FEble063713 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 09:14:38 -0600
Message-ID: <4EB7F5DA.5040103@sgi.com>
Date: Mon, 07 Nov 2011 09:14:34 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] path: fix 1 byte overflow with empty lists
References: <1320554817-2594-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1320554817-2594-1-git-send-email-vapier@gentoo.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On 11/05/2011 11:46 PM, Mike Frysinger wrote:
> If pap->pa_cnt is 0, then the local buffer is allocated as 1 byte,
> but the code then writes two bytes to it '/' and '\0'.
>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>

Looks good,

Reviewed-by: Bill Kendall <wkendall@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
