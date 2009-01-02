Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n029lgBr015644 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 03:47:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCB7D58FF9
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 01:47:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4DvlLkuf72wLghu1 for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 01:47:41 -0800 (PST)
Date: Fri, 2 Jan 2009 04:47:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] freeze feature ver 1.14
Message-ID: <20090102094730.GA17841@infradead.org>
References: <20081027215811t-sato@mail.jp.nec.com>
	<495DA488.7080702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495DA488.7080702@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Takashi Sato <t-sato@yk.jp.nec.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Jan 01, 2009 at 11:22:16PM -0600, Eric Sandeen wrote:
> In lieu of the timeout feature which was originally proposed, how
> about access to an emergency un-freeze via magic sysrq, maybe
> piggy-backed on emergency sync... something like this (not
> tested or even built yet...), would this be a good compromise to
> help save people from frozen roots?

Looks sane to me.  But for that we'd need to get the generic freeze bits
in first.  Andrews, as they are in 2.6.28-rc2 do you plan to send them?

Any chance for a general -mm merge plan, btw?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
