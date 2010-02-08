Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18Ja1FJ155626 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:36:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9412E1CB1932
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 11:37:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KR08t0C6XKyARgeN for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 11:37:14 -0800 (PST)
Date: Mon, 8 Feb 2010 14:36:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: vfs/fsnotify trees build warning
Message-ID: <20100208193658.GA9527@infradead.org>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
	<20100125042925.GM25842@discord.disaster>
	<7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
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
To: Eric Paris <eparis@parisplace.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>, xfs@oss.sgi.com, linux-next@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Feb 08, 2010 at 01:01:46PM -0500, Eric Paris wrote:
> On Sun, Jan 24, 2010 at 11:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Jan 25, 2010 at 03:04:56PM +1100, Stephen Rothwell wrote:
> >> Hi Eric, Al,
> >>
> >> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> I just switched fsnotify to use const unsigned char * so hopefully
> they will shut up tomorrow....

The xfs tree is also about to get a patch to turn off -Wpointer-sign
again.  If it was up to me we should turn it on for the whole build,
we'll just need good way to deal with static initializers and strlen,
but some simple wrappers might do it for those.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
