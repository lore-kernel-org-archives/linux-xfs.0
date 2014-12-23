Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9D1F7F51
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 18:32:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6587EAC001
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 16:32:43 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tc2W068X8iXdmfSS for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 16:32:40 -0800 (PST)
Date: Tue, 23 Dec 2014 11:32:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: weird quota issue
Message-ID: <20141223003237.GA4521@dastard>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
	<2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 22, 2014 at 05:46:42PM -0500, Weber, Charles (NIH/NIA/IRP) [C] wrote:
> I wonder if it is a thin-provision issue? ~40TB allocated by the SAN but setup to not really allocate space until it is claimed by the OS. 
> 
>  xfs_db -c "sb 0" -c p /dev/dm-7
> 
....
> versionnum = 0xb5e4

So the quota bit is set (0x40) hence quotas will attempt to be
enabled.

> uquotino = 131
> gquotino = 0
> qflags = 0

But we have no quota enabled but a user quota inode allocated.
the quota flags would have been written to zero by the initial
failure, so this implies that reading the  user quota inode failed.
Output of 'xfs_db -c "inode 131" -c p /dev/dm-7', please?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
