Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CYHMq027118 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:34:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23B4A169546F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 04:34:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ouSAvoll9MdKz0jB for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 04:34:17 -0800 (PST)
Date: Thu, 4 Dec 2008 07:33:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Assertion failed: atomic_read(&mp->m_active_trans)
Message-ID: <20081204123346.GA7085@infradead.org>
References: <492BB095.1000104@sgi.com> <4934AAA9.5090405@sgi.com>
	<20081203104849.GF15485@infradead.org>
	<20081203213950.GX18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203213950.GX18236@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Thu, Dec 04, 2008 at 08:39:50AM +1100, Dave Chinner wrote:
> On Wed, Dec 03, 2008 at 05:48:49AM -0500, Christoph Hellwig wrote:
> > I'd rather fix it properly.
> 
> Sure, but in the mean time, I'd suggest changing it to a WARN_ON()
> rather than an ASSERT(). That way we'll continue to have ppl bug us
> about it until the VFS can support read-only remounts without racing
> correctly.

Makes sense.

> Has that work been dropped on the floor, Christoph? We've
> been holding off removing this ASSERT or adding the hack
> I did to work around the common case of the assert triggering
> based on the fact that the problem in the VFS would be fixed
> in the next release. That was the case each release since
> 2.6.25 and there doesn't seem to be much progress...

Yeah, once we got the r/o bind mounts which introduces the
infrastructure to deal with people dropped that ball and we never fixed
it.  But I just heard from Al that he's looking into some major surgery
for the remount path, which should include this in the second or third
batch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
