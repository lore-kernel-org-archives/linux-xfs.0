Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDB527F76
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 20:58:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73A63AC004
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 18:58:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DRfPpzxDrqRqAWMz for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 18:58:25 -0700 (PDT)
Date: Sat, 27 Jul 2013 11:58:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
Message-ID: <20130727015822.GV13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com> <51F2E011.5020904@gmail.com>
	<51F2E4DD.4020301@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F2E4DD.4020301@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 04:06:37PM -0500, Mark Tinguely wrote:
> 
> I can reproduce a problem in patch 44 too. It takes my copy test 20
> minutes to deplete the log space with patch 44, Same test with patch
> 43 has been running a day and a half. I do not think that patch 44
> is 100 times faster than patch 43 but I will let patch 43 spin all
> weekend on a couple machines to verify that patch 43 does not hang.

Details, please. What's your "copy test"?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
