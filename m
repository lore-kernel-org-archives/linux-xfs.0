Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51NfHsg155480 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 18:41:17 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0057815DA77F
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 16:41:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	904Cya4yGtQK0sy6 for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 16:41:16 -0700 (PDT)
Date: Thu, 2 Jun 2011 09:41:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: What is xfs_prepair64 ?
Message-ID: <20110601234114.GK561@dastard>
References: <BANLkTi=eMCp6U8+um1vXKaj+0rstsYjHiw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=eMCp6U8+um1vXKaj+0rstsYjHiw@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 01, 2011 at 12:11:31PM +0530, Ajeet Yadav wrote:
> xfstests FS QA Test No. 148 needs "xfs_prepair64" to run ?
> I did not find this in xfsprogs-3.1.5, please guide from where to find this ?

You'll never find it.

It was an Irix-only, one-off parallelised xfs_repair prototype that
was thrown away when the OSS xfs_repair code was parallelised much
more effectively.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
