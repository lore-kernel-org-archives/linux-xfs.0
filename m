Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8Q09OQO259282 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 19:09:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 574B915E9E32
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 17:23:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QODWmF8iov1yQzYC for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 17:23:07 -0700 (PDT)
Date: Sat, 25 Sep 2010 20:10:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH VER 5] xfstests: Quota project id setting overflow
Message-ID: <20100926001019.GC18984@infradead.org>
References: <1285332748-13648-1-git-send-email-arekm@maven.pl>
	<1285332769-13708-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285332769-13708-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Fri, Sep 24, 2010 at 02:52:49PM +0200, Arkadiusz Mi??kiewicz wrote:
> From: Arkadiusz Miskiewicz <arekm@maven.pl>
> 
> Test 3 quota project setting id conditions:
> - set 16bit project quota id -> should succeed
> - set 32bit project quota id -> should succeed (with projid32bit
>   patch applied; fail otherwise)
> - over 32bit project quota id -> should always fail
> 
> Signed-off-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
