Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96KEb3h199669 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 15:14:37 -0500
Subject: Re: [PATCH] xfstests: 261: test failures caused by bogus mtab entries
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006194913.GF13434@infradead.org>
References: <201110032301.p93N1ISR023771@stout.americas.sgi.com>
	<20111006194913.GF13434@infradead.org>
Date: Thu, 6 Oct 2011 15:14:30 -0500
Message-ID: <1317932070.2870.33.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-10-06 at 15:49 -0400, Christoph Hellwig wrote:
> > +mtab=/proc/self/mounts
> > +if [ ! -r "${mtab}" ]; then
> > +    mtab=/etc/mtab
> > +    if [ ! -r "${mtab}" ]; then
> > +	echo "warning: proceeding without use of mount table" >&2
> > +    fi
> > +fi
> 
> Just use /proc/self/mounts unconditionally, it's been there for a long
> time.

OK.  I was just following the logic embedded in libxcmd
but I do prefer keeping it simple.

					-Alex
> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
