Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 727E57FA4
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:11:21 -0500 (CDT)
Date: Thu, 22 Aug 2013 14:11:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Register hotcpu notifier after initialization
Message-ID: <20130822191117.GQ5262@sgi.com>
References: <1376945804-29508-1-git-send-email-richard@nod.at>
	<20130819222129.GA5262@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130819222129.GA5262@sgi.com>
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
To: Richard Weinberger <richard@nod.at>
Cc: elder@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 19, 2013 at 05:21:29PM -0500, Ben Myers wrote:
> On Mon, Aug 19, 2013 at 10:56:44PM +0200, Richard Weinberger wrote:
> > Currently the code initializizes mp->m_icsb_mutex and other things
> > _after_ register_hotcpu_notifier().
> > As the notifier takes mp->m_icsb_mutex it can happen
> > that it takes the lock before it's initialization.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Looks good.  Thanks Richard.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks Richard.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
