Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 63A1C7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 18:59:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 41A8C8F8033
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 16:59:38 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5qtHNRI5BG71Oqny for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 16:59:33 -0800 (PST)
Date: Fri, 28 Nov 2014 11:59:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: OS Upgrade Considerations For XFS Volume
Message-ID: <20141128005930.GF27262@dastard>
References: <CANoQhnbjv08FVe0iRFff0fNMV7u7POY9kPtAhCbe_Vz=d8kPxg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANoQhnbjv08FVe0iRFff0fNMV7u7POY9kPtAhCbe_Vz=d8kPxg@mail.gmail.com>
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
To: Bharathiraja P <raja@where2getit.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 27, 2014 at 07:59:59PM +0530, Bharathiraja P wrote:
> Hi there,
> 
> We recently upgraded our database system from OpenSuSE-11.4 to OpenSuSE-13.1
> 
> Post the upgrade we are noticing load spikes on our database system.

And ...?

Is there any actual performance problem you've measured?

> OpenSuSE 11.4 uses kernel-2.6.37 and OpenSuSE-13.1 uses kernel-3.11.10
> 
> There seems to be some changes related to XFS in new kernel and I'm getting
> this error when I run xfs_logprint
> 
> ==============
> sudo /usr/sbin/xfs_logprint /dev/mapper/pgsql-data
> raja's password:
> xfs_logprint:
> xfs_logprint: /dev/mapper/pgsql-data contains a mounted and writable

logprint is completely unreliable on an active and mounted
filesystem. It's not going to tell you anything useful about any
sort of performance issue - logprint is for debugging log recovery
problems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
