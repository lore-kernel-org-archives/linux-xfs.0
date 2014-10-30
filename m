Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 888D97F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 20:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27362AC001
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 18:39:09 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id eP9A39bWzO0kcnsT for
	<xfs@oss.sgi.com>; Wed, 29 Oct 2014 18:39:06 -0700 (PDT)
Message-ID: <1414633063.17402.6.camel@G08JYZSD130126.localdomain>
Subject: Re: [Question]: xfstests test generic/233 failure
From: Zeng Linggang <zenglg.jy@cn.fujitsu.com>
Date: Thu, 30 Oct 2014 09:37:43 +0800
In-Reply-To: <20141029103636.GJ16186@dastard>
References: <1414575977.17402.3.camel@G08JYZSD130126.localdomain>
	<20141029103636.GJ16186@dastard>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2014-10-29 at 21:36 +1100, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 05:46:17PM +0800, Zeng Linggang wrote:
> > Hello,
> > 
> > Comparing user usage
> > -Comparing group usage
> > +4c4
> > +< #1001     --   31348   32000   32000            772  1000  1000
> > +---
> > +> #1001     --   31144   32000   32000            772  1000  1000
> > ...
> > generic/231 and generic/270 also have the similar quota accounting mismatch.
> 
> fsstress can result in different file and directory layouts, hence
> result in different amounts of metadata in the filesystem. Metadata
> is also accounted to quotas (e.g. to the user who owns the
> directory) and so even if data usage is identical the metadata can
> still vary.
> 
> I see these test give small variations quite frequently, but they
> are are usually only quite small (a handful of blocks) so I've never
> really worried about it too much.
> 

Yep, it make me more clearer.
And thank you very much.

Best regards,
Zeng

> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
