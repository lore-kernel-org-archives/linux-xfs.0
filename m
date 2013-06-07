Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C83087CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:34:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0C8C30407F
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 03:34:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	02HLHBVDJWuSYmMp for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 03:34:31 -0700 (PDT)
Date: Fri, 7 Jun 2013 20:34:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to Override Default inode64 mount option in openSUSE 12.3?
Message-ID: <20130607103429.GD13113@dastard>
References: <1370597593.78403.YahooMailClassic@web192202.mail.sg3.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370597593.78403.YahooMailClassic@web192202.mail.sg3.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 05:33:13PM +0800, Gim Leong Chin wrote:
> Hi,
> 
> 
> I have just set up openSUSE 12.3 on my Acer notebook with a 750 GB WD hard drive, "/" with 80 GB and "/home" with 587 GB, both are XFS.
> 
> Both file systems are mounted with inode64 and no matter what I put in /etc/fstab, I am not able to remove inode64 option.

Your filesystem is smaller than 1TB, so inode numbers will never go
over 32 bits, so inode32/inode64 is irrelevant to your problem.

> Is there any method to override the inode64 default mount option?

-o inode32.

> The reason I need to get rid of it is that acroread will not
> start, and I suspect that it is due to inode64, although I cannot
> confirm with strace on acroread.

inode64 is not your problem.

> Since the two file systems are under 1 TB, what is the point of
> inode64 any way?

Because it's the metadata/data allocation policy that is used for
filesystems of less than 1TB.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
