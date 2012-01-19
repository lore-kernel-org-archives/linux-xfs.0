Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0JIb78w032550 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 12:37:08 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id FjRBcvpuOcgIhF9J for <xfs@oss.sgi.com>;
	Thu, 19 Jan 2012 10:37:05 -0800 (PST)
Message-ID: <4F1862D0.1060708@sandeen.net>
Date: Thu, 19 Jan 2012 12:37:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Trouble activating xfs pquotas
References: <4F170A53.9070202@jdlawrie.co.uk>
In-Reply-To: <4F170A53.9070202@jdlawrie.co.uk>
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
To: James Lawrie <james@jdlawrie.co.uk>
Cc: xfs@oss.sgi.com

On 1/18/12 12:07 PM, James Lawrie wrote:
> Hi,
> 
> I'm unable to activate project quotas on a partition which used to
> have it enabled - I just get "Function not implemented". The
> partition is mounted with pquota, and I can't seem to find any other
> reason this would happen.
> 
> Please see more information and output at
> http://serverfault.com/questions/351137/unable-to-re-implement-xfs-project-quotas-function-not-implemented
> - I'd really appreciate any advice.
> 
> Thank you,
> 
> James Lawrie

Based on IRC conversations, the fs was never(?) properly mounted with quota in the first place; an actual remount w/ quota forced by a reboot seems to have resolved this.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
