Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9289C7F74
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 20:59:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 120A0AC00D
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 18:59:14 -0800 (PST)
Received: from BLU004-OMC3S33.hotmail.com (blu004-omc3s33.hotmail.com
	[65.55.116.108]) by cuda.sgi.com with ESMTP id BeYnZDXFeVb17mUB
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 09 Nov 2014 18:59:08 -0800 (PST)
Message-ID: <BLU175-W31362D67A4A5AB08F7DE3DDF800@phx.gbl>
From: GuangYang <yguang11@outlook.com>
Subject: RE: EIO and data corruption on XFS file system
Date: Mon, 10 Nov 2014 02:59:07 +0000
In-Reply-To: <20141106215400.GG23575@dastard>
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>,
	<20141106215400.GG23575@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks Dave. Yeah you are right, it seems the problem comes from hardware and system power cycling (so that some IO transaction get lost)..

----------------------------------------
> Date: Fri, 7 Nov 2014 08:54:01 +1100
> From: david@fromorbit.com
> To: yguang11@outlook.com
> CC: xfs@oss.sgi.com
> Subject: Re: EIO and data corruption on XFS file system
>
> On Thu, Nov 06, 2014 at 01:03:45PM +0000, GuangYang wrote:
>> Hello,While working on the storage system, I got one question in
>> terms of the XFS utilities to fix file system corruption.
>> Basically, our storage system put 3 copies of data and the system
>> would detect data inconsistency on regular basis, there are two
>> patterns we observed so far:
>>
>> 1) the data is corrupted which result in an EIO,
>
> Data corruption doesn't trigger EIO errors. EIO errors from the
> underlying storage might cause data corruption, but the only thing
> that can detect bad data is the application itself, not the kernel.
>
>> 2) data is still accessible but the content is changed.
>
> Again, data being incorrect is generally not a filesystem issue
> unless there's a bug somewhere in the filesystem IO path. You'll
> need to give us a *lot* more information about your storage and
> application workload if you think XFS is corrupting data. Start
> with:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
 		 	   		  
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
