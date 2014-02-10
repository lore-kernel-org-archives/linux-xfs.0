Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EEF77F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 08:50:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3F36AC004
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 06:50:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id t2GyyDbmNaFcFkOQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 06:50:25 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s1AEoOI8029068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:50:24 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s1AEoNBZ011749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:50:24 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s1AEoNpY000577 for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:50:23 GMT
Date: Mon, 10 Feb 2014 17:50:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: potential use after free in xfs_iomap_write_allocate()
Message-ID: <20140210145041.GC26776@mwanda>
References: <20140210103626.GA15018@elgon.mountain>
	<52F8E086.8030805@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F8E086.8030805@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 10:21:58PM +0800, Jeff Liu wrote:
> 
> On 02/10 2014 18:36 PM, Dan Carpenter wrote:
> > There is a static checker warning in xfs_iomap_write_allocate().  It's
> > sort of old so probably it's a false positive.
> > 
> > 	fs/xfs/xfs_iomap.c:798 xfs_iomap_write_allocate()
> > 	warn: 'tp' was already freed.
> > 
> > fs/xfs/xfs_iomap.c
> >    677  
> >    678          while (count_fsb != 0) {
> > 
> > There are some paths where if (count_fsb == 0) then "tp" is free.
> 
> I can not see a call pach would introduce "count_fsb == 0" because we only
> call xfs_iomap_write_allocate() in extent delayed allocation context,
> that is the count_fsb should be >= 1.

I am confused.  That's a while condition and not an if condition.
On line 792 we do:

	count_fsb -= imap->br_blockcount;

I assume you saw that, and it's still a false positive but I just want
to be sure.

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
