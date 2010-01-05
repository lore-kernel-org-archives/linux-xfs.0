Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05Cpmiu206334 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 06:51:50 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04451509E22
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 04:52:38 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id FF4PG2BMOIJuhUmw for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 04:52:38 -0800 (PST)
Date: Tue, 5 Jan 2010 13:52:35 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100105125234.GD1778@basil.fritz.box>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
	<87eim4dbzw.fsf@basil.nowhere.org>
	<20100105122101.GR13802@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100105122101.GR13802@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>

> > Also it would seem cleaner to have it in a own file.
> 
> That might make sense if we had a large number of generic sort
> functions and it was difficult to tell the code apart, but we've
> only got 2 right now....

I was more thinking of the case that it can be easily made a lib-y
and then eliminated by the linker on non modular kernels if not needed
(unfortunately that would require putting the EXPORT_SYMBOL somewhere else)

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
