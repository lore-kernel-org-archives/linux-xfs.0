Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUNAuaC149263 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 17:10:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 302071B00F8
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 15:12:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hgWi0hWPhk0JC1Gu for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 15:12:38 -0800 (PST)
Date: Wed, 1 Dec 2010 10:12:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: getfacl -n unsupported in older acl package
Message-ID: <20101130231235.GK3556@dastard>
References: <1291124858.3340.9.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291124858.3340.9.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 30, 2010 at 02:47:38PM +0100, Boris Ranto wrote:
> Test cases 051 and 067 use getfacl with option -n. This works well on newer systems but older acl package know only its longer version: --numeric.
> 
> I've tested the two tests with long option and they both passed.
> 
> Therefore I'd propose this patch to fix this for earlier acl versions:

Looks fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
