Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79Kt9nt124090 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 15:55:09 -0500
Subject: Re: [PATCH] xfsdump: allow multi-digit dialog prompts
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1311784913-14191-1-git-send-email-wkendall@sgi.com>
References: <1311784913-14191-1-git-send-email-wkendall@sgi.com>
Date: Tue, 9 Aug 2011 15:55:05 -0500
Message-ID: <1312923305.9482.0.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-07-27 at 11:41 -0500, Bill Kendall wrote:
> xfsdump issues a multiple-choice dialog in various circumstances
> (e.g., media change request). An assert incorrectly limits this to
> at most 8 choices even though the code can handle up to 9.  Remove
> the assert and change the code to handle multi-digit responses.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Sorry I didn't get to this sooner.

I had a few minor quibbles, but I'm not going to even bother
mentioning them.  Your change looks good.  I'll commit this
for you.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
