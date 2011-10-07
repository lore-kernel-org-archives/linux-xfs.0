Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97NYsHh009051 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 18:34:54 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 193D91C77D1C
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 16:34:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WeXdzZrJt1XEToPS for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 16:34:52 -0700 (PDT)
Date: Sat, 8 Oct 2011 10:34:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TRIM on XFS
Message-ID: <20111007233450.GK3159@dastard>
References: <201110071352.20135@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110071352.20135@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 01:52:19PM +0200, Michael Monnerie wrote:
> It's been a long time since I've been reading about TRIM. What is the 
> current state for XFS? I believe there's TRIM support, but only offline. 
> Can someone explain how to activate that and actually run a TRIM?
> 
> And there was some talk of "inline TRIM", i.e. always TRIMing on delete. 
> Is that implemented already?
> 
> We're on VMware with thin provisioned machines, and that would hugely 
> benefit from TRIM.
> 

e84661a xfs: add online discard support

and 

a46db60 xfs: add FITRIM support

So both online and background trim methods are available. Test well
before using them in production, though, as buggy hardware or thinp
implementations are quite common....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
