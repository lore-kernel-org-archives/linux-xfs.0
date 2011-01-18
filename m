Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ID9jdT129653 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 07:09:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4BAB1EA07FB
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:12:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QuIq5LASNaFwmDgn for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:12:03 -0800 (PST)
Date: Tue, 18 Jan 2011 08:12:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: add fpunch command for hole punching via
	fallocate
Message-ID: <20110118131203.GA4349@infradead.org>
References: <1295009545-17839-1-git-send-email-josef@redhat.com>
	<20110118125112.GB21440@infradead.org>
	<20110118130603.GA23491@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118130603.GA23491@dhcp231-156.rdu.redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 08:06:03AM -0500, Josef Bacik wrote:
> Sounds good.  So which do we want, a new command or a new flag?  Thanks,

I'll wait for dave to chime in.  I think we should absolutely expose
it as a fallocate flag, but if there's a good reason we can also expose
it as a separate command.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
