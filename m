Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9GG5uU4194520
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 11:05:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37DB41CFABF
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 09:05:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uMojtPvw9pmxfqxo for <linux-xfs@oss.sgi.com>;
	Sun, 16 Oct 2011 09:05:54 -0700 (PDT)
Date: Sun, 16 Oct 2011 12:05:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: tasks hangs in D state while writing to xfs
Message-ID: <20111016160553.GA10406@infradead.org>
References: <j7bs98$5bs$1@dough.gmane.org> <20111015220922.GR3159@dastard>
	<4E9AC49D.60303@mejor.pl> <20111016123547.GA16297@infradead.org>
	<4E9ADE66.1020300@mejor.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9ADE66.1020300@mejor.pl>
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
To: Marcin Miros?aw <marcin@mejor.pl>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Sun, Oct 16, 2011 at 03:38:46PM +0200, Marcin Miros?aw wrote:
> > 3.1-rc9 does not include these fixes yet, you'll either need to get
> > Linus' latests git tree or apply these patches manually.
> 
> I checked random patch (
> http://oss.sgi.com/archives/xfs/2011-10/msg00309.html ) it was in tree
> so i though other patches from series was in tree. But they don't :)

Sorry, that was the 3.0-stable backport that includes two additional
patches.

> > I'd also love to see the output of dmesg after doing a
> > 
> > 	'echo t > /proc/sysrq-trigger'
> > 
> > from these hangs if you can still reproduce them.
> 
> I tried kernel from git master. I can't reproduce problem now. Thank you
> for help!

Good to know.  If anything strange happens again please notify the list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
