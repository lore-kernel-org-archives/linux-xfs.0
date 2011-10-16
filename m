Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9GCZv88184022
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 07:35:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48BCC16C035D
	for <linux-xfs@oss.sgi.com>; Sun, 16 Oct 2011 05:43:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZWSCXSNBxgMJ0iaA for <linux-xfs@oss.sgi.com>;
	Sun, 16 Oct 2011 05:43:39 -0700 (PDT)
Date: Sun, 16 Oct 2011 08:35:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: tasks hangs in D state while writing to xfs
Message-ID: <20111016123547.GA16297@infradead.org>
References: <j7bs98$5bs$1@dough.gmane.org> <20111015220922.GR3159@dastard>
	<4E9AC49D.60303@mejor.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9AC49D.60303@mejor.pl>
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
Cc: linux-xfs@oss.sgi.com

On Sun, Oct 16, 2011 at 01:48:45PM +0200, Marcin Miros?aw wrote:
> Thanks for link. I've tried kernel linux-3.1-rc9, xfs behaves better but
> still is something not right. I'm rsyncincg many files, after sometime
> rsync hangs, it looks like do nothing for about 30-90 seconds and
> continues copying. I did run "sync" when rsync was hanging and sync also
> hangs. It looks like xfs has hiccup.

3.1-rc9 does not include these fixes yet, you'll either need to get
Linus' latests git tree or apply these patches manually.

I'd also love to see the output of dmesg after doing a

	'echo t > /proc/sysrq-trigger'

from these hangs if you can still reproduce them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
