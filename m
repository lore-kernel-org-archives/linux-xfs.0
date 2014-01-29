Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FDEF7F80
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 09:07:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A2E1304075
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 07:07:16 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MXu4CLm1p7s3uIvG for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 07:07:15 -0800 (PST)
Message-ID: <52E91923.4070706@sandeen.net>
Date: Wed, 29 Jan 2014 09:07:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
In-Reply-To: <1391005406-sup-1881@al.wesleyan.edu>
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
To: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs <xfs@oss.sgi.com>

On 1/29/14, 8:26 AM, C. Morgan Hamill wrote:
> Howdy folks,
> 
> I understand that XFS have stripe unit and width configured according to
> the underlying RAID device when using LVM, but I was wondering if this
> is still the case when a given XFS-formatted logical volume takes up
> only part of the available space on the RAID.  In particular, I could
> imagine that stripe width would need to be modified proportionally with
> the decrease in filesystem size.  My intuition says that's false, but
> I wanted to check with folks who know for sure.

The stripe unit and width are units of geometry of the underlying
storage; a filesystem will span some number of stripe units, depending
on its size.

So no, the filesystem's notion of stripe geometry does not change
with the filesystem size.

You do want to make sure that stripe geometry is correct and aligned
from top to bottom.

I helped write up the RHEL storage admin guide, and there are some
nice words about geometry and alignment in there:

https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-iolimits.html

(Hopefully this is available w/o login, I think it is)

-Eric

> Thanks for any help!
> --
> Morgan Hamill
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
