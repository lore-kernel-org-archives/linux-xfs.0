Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBgfXh206297 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:42:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 171309176F
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:42:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yDtfHHZbFR7cSSze for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:42:40 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:42:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
	->fsync() handlers
Message-ID: <20110724114235.GG26332@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de>
	<4E2B2E88.8080006@redhat.com>
	<20110723203824.GB1652@x4.trippels.de>
	<20110723220212.GA1648@x4.trippels.de>
	<20110724111625.GA12658@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110724111625.GA12658@infradead.org>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

On Sun, Jul 24, 2011 at 07:16:26AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> > The following patch fixes the problem for me:
> 
> Good catch, can you send it with a proper signoff and description?

This also fixes the xfstests 130 regression that popped up in latest
Linus HEAD.  Good to know we have some QA coverage for O_SYNC writes,
althoug I wish it would be more than just one testcase..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
