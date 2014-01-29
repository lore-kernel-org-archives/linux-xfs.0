Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3F6A7F86
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 13:12:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B410A8F8066
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 11:12:02 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id MlJaKSRYyZIPe191
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 11:12:01 -0800 (PST)
Received: from localhost (al.wesleyan.edu [129.133.22.76])
	(authenticated bits=0)
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id s0TJBxhi002716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:11:59 -0500
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <52E91923.4070706@sandeen.net>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
Date: Wed, 29 Jan 2014 14:11:59 -0500
Message-Id: <1391022066-sup-5863@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

Thanks for the quick reply.

Excerpts from Eric Sandeen's message of 2014-01-29 10:07:15 -0500:
> The stripe unit and width are units of geometry of the underlying
> storage; a filesystem will span some number of stripe units, depending
> on its size.
> 
> So no, the filesystem's notion of stripe geometry does not change
> with the filesystem size.
> 
> You do want to make sure that stripe geometry is correct and aligned
> from top to bottom.

Just to make sure I've understood, for 3 14-disk RAID 6 groups striped
together into a single RAID 60, with stripe units of 128k, split up into
some number of LVM logical volumes, I'd create the filesystems with the
following:

    mkfs.xfs -d su=128k,sw=36 ...

for all of the filesystems, regardless of how many and what size they
were.  Does that sound right?

> I helped write up the RHEL storage admin guide, and there are some
> nice words about geometry and alignment in there:
> 
> https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-iolimits.html

Thanks for the resource!
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
