Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04CXfax133318 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 06:33:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HaSWyA4SvMU3znMS for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 04:33:39 -0800 (PST)
Date: Wed, 4 Jan 2012 07:33:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20120104123331.GA12204@infradead.org>
References: <CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr> <20120102203543.GP23662@dastard>
	<4F02BA35.9040909@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F02BA35.9040909@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Tue, Jan 03, 2012 at 09:20:05AM +0100, Yann Dupont wrote:
> >As it is, I can't see any material difference between the traces.
> >both reads and writes are taking the same amount of time to service,
> >so I don't think there's any problem here.
> 
> ok,
> >
> >I do recall that some years ago that we changed one of the ways we
> 
> Do you recall exactly what some years ago means ? Is this post 2.6.26 era ?

The only thing that I remember is Jens switching xfs_buf_wait_unpin from
schedule to io_schedule in "block: remove per-queue plugging", which
went into Linux 2.6.39.  With this processed that wait for buffers to
be unpinned now count towards the load average.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
