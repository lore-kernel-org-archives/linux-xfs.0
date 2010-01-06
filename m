Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06HMZN1098022 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 11:22:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC1651DAF95C
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 09:23:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jp9OQB49MWssVoow for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 09:23:27 -0800 (PST)
Date: Wed, 6 Jan 2010 12:23:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100106172319.GA25046@infradead.org>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
	<87eim4dbzw.fsf@basil.nowhere.org>
	<20100105122101.GR13802@discord.disaster>
	<20100105125234.GD1778@basil.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100105125234.GD1778@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>

On Tue, Jan 05, 2010 at 01:52:35PM +0100, Andi Kleen wrote:
> > > Also it would seem cleaner to have it in a own file.
> > 
> > That might make sense if we had a large number of generic sort
> > functions and it was difficult to tell the code apart, but we've
> > only got 2 right now....
> 
> I was more thinking of the case that it can be easily made a lib-y
> and then eliminated by the linker on non modular kernels if not needed
> (unfortunately that would require putting the EXPORT_SYMBOL somewhere else)

lib-y doesn't work together with EXPORT_SYMBOL, having the export
outside would also always pull it in.  These days the whole lib-y mess
doesn't make sense anymore - if we really need an optional library
symbol we can just pull it in through a Kconfig variable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
