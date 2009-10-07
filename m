Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97K9qmC207415 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 15:09:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 806BC4AC896
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 13:11:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8OaKdv1CrzCaNnA2 for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 13:11:18 -0700 (PDT)
Date: Wed, 7 Oct 2009 16:11:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: update configure defaults
Message-ID: <20091007201118.GA25462@infradead.org>
References: <20091006151458.GA2560@infradead.org>
	<4ACCE594.3050207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACCE594.3050207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 02:01:40PM -0500, Eric Sandeen wrote:
> This almost works for me in fedora, except that fedora's rpm uses a %configure
> which sets --libdir=/usr/lib64 and then I end up with stuff installed in
> /usr/lib6464 \o/
>
> With this patch things are ok again if I add --disable-lib64 :

Thanks, I've added it.  Need to think a bit more about the
enable/disable-lib64 default, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
