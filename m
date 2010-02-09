Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19M3UsU255071 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 16:03:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 201DF139278A
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 14:04:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TkfZl2eMiq8oLhd3 for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 14:04:43 -0800 (PST)
Date: Tue, 9 Feb 2010 17:04:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: optionally run all tests under quota
Message-ID: <20100209220443.GB20187@infradead.org>
References: <4B71B6E7.1000203@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B71B6E7.1000203@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 09, 2010 at 01:26:31PM -0600, Eric Sandeen wrote:
> This patch might be a little heavy handed, but it seems to
> work; if you set USE_QUOTA=1 in your environment, all
> tests should be run with quota on and enabled.

I'd rather prefer a -quota option to ./check than a magic
environment variable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
