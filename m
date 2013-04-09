Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 158B47F6A
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:02:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0284E304059
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:02:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	E8tmdrkSgBr3QLIy for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 05:02:42 -0700 (PDT)
Date: Tue, 9 Apr 2013 22:02:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair has been running for a very long time, no disk IO.
Message-ID: <20130409120236.GL17758@dastard>
References: <20130409121726.6342519e@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130409121726.6342519e@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 09, 2013 at 12:17:26PM +0200, Emmanuel Florac wrote:
> 
> On a quite badly mangled filesystem, xfs_repair (v. 3.1.4) seems to
> never end. It has run for 16 hours with absolutely no disk activity.
> 
> Usually xfs_repair takes much less than one hour on a similar (9 TB)
> filesystem.
> 
> I know I should try the latest version. What else can be wrong? 
> What should I try?

Either use the latest version, or use the -P option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
