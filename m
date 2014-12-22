Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C89429DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A7CCAC006
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 12:43:34 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HoCvedOhmjS124iT for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 12:43:28 -0800 (PST)
Date: Tue, 23 Dec 2014 07:43:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump questions
Message-ID: <20141222204325.GJ24183@dastard>
References: <20141219095738.6b6e6c88@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141219095738.6b6e6c88@localhost>
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
To: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 19, 2014 at 09:57:38AM +0100, Stevie Trujillo wrote:
> Hello!
> 
> Is xfsdump an ancient relic or something recommended to new users (I
> have never seen anyone recommending it)? I gave it a try and found the
> incremental backups to be really fast!

Still supported, still works, still used in production by lots of
people.

> How are incremental backups implemented? I saw that my inventory file
> is really small. Does it use some internal xfs metadata to detect
> changes? Is it resilient against all kinda renames and changing
> timestamps etc that a user might do? (I've previously used a backup
> system that broke when doing stuff like that)

It should detect renames and changing timestamps, etc. without any
problems.

> Is it possible to backup (and restore) ctimes?

No.

> I read that the incremental backups are limited to a depth of 10. Are
> they intended to be used in a binary tree like fashion?

In theory. Not sure anyone actually uses incremental dumps like that
though, so you'd need to do a bunch of testing before deploying such
a solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
