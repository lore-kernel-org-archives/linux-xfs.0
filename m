Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB54D7CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:15:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D9F88F804B
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:15:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fGi4cIICYOHhshX4 for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 18:15:53 -0700 (PDT)
Date: Mon, 12 Aug 2013 11:15:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH v3 1/2] xfstests: add fssum tool
Message-ID: <20130812011539.GM12779@dastard>
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
	<1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
	<5203D827.3050909@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5203D827.3050909@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de, xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
> On 8/8/13 3:17 AM, Jan Schmidt wrote:
> >  SUBDIRS =
> >  
> >  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
> >  
> > +OPT_LDLIBS = -lssl -lcrypto
> 
> Hm, new deps.  I guess it's not a huge problem, these should always
> be available, right?

Please, let's keep crypto out of xfstests if we can. That's just
going to add a nightmare of US export compliance garbage to any
distro that wants to package and ship this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
