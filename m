Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24DjNrf170737 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 07:45:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DAA913F46E6
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 05:46:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5tx8BHFguGF7Ylop for
	<xfs@oss.sgi.com>; Thu, 04 Mar 2010 05:46:52 -0800 (PST)
Date: Thu, 4 Mar 2010 08:46:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100304134641.GA26871@infradead.org>
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304131511.GH14317@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

On Fri, Mar 05, 2010 at 12:15:11AM +1100, Dave Chinner wrote:
> On Thu, Mar 04, 2010 at 01:08:45PM +0100, Michael Weissenbacher wrote:
> > Hi Dave!
> >> Can you run the trace through ksymoops so that we get function names
> >> rather than numbers that don't mean anything?
> > I've never done that before. Could you point me to an howto about this?
> 
> I've never needed to use it myself, so all I'd be doing is reading
> the man page and doing a google search to answer your question. It's
> way past my bed time here, so I'll leave that to you for the
> moment - try searching for "ksymoops howto"....

Also when you next rebuilt the kernel please make sure to include
CONFIG_KALLSYMS in the configuration, possibly CONFIG_KALLSYMS_ALL too.
This will help greatly with decoding any kind of warning / oops.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
