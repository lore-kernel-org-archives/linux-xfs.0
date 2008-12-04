Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CZ4d0027217 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:35:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F8CD169547A
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 04:35:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9s37BjKw1SAn4CI6 for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 04:35:03 -0800 (PST)
Date: Thu, 4 Dec 2008 07:34:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/22] fix compile on 32 bit systems
Message-ID: <20081204123432.GC7085@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160649.658660000@bombadil.infradead.org>
	<87vdu07nvp.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87vdu07nvp.fsf@cxhome.ath.cx>
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
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 04, 2008 at 12:03:22PM +1100, Niv Sardi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> [???]
> > +xfs_file_compat_ioctl_invis(
>                    ^^^^^^^^^^^
> [???]
> > -extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
>                                ^^^^^^^^^^^
> 
> Fixed it up, it's in QA now,

Doh, thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
