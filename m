Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JBYFiS182731 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 06:34:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFF721DB81D8
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:34:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8EiC1m0vVAgcyef5 for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 04:34:14 -0700 (PDT)
Date: Wed, 19 Oct 2011 07:34:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
Message-ID: <20111019113404.GA13670@infradead.org>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
	<4E9EB187.40306@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9EB187.40306@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Wed, Oct 19, 2011 at 01:16:23PM +0200, Stefan Priebe - Profihost AG wrote:
> Any news on this problem? What happens with the next long term
> stable kernel 3.0.X? How do you proceed with this bug?

The patches are in 3.1-rc10 and I have submitted them for 3.0-stable,
but haven't heard anything back from Greg yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
