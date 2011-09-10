Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8A65Rkb082765 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 01:05:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A549B13DC6DD
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 23:09:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UpNQRG6BHaXTfsCq for <xfs@oss.sgi.com>;
	Fri, 09 Sep 2011 23:09:45 -0700 (PDT)
Date: Sat, 10 Sep 2011 02:05:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Performance regression between 2.6.32 and 2.6.38
Message-ID: <20110910060522.GA26968@infradead.org>
References: <F70D1B6A-0387-4646-B97B-98ED895F7759@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F70D1B6A-0387-4646-B97B-98ED895F7759@fusionio.com>
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
To: Joshua Aune <luken@fusionio.com>
Cc: Paul Saab <ps@fb.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Sep 09, 2011 at 06:23:54PM -0600, Joshua Aune wrote:
> Are there any mount options or other tests that can be run in the failing configuration that would be helpful to isolate this further?

The best thing would be to bisect it down to at least a kernel release,
and if possible to a -rc or individual change (the latter might start
to get hard due to various instabilities in early -rc kernels)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
