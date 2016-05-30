Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2B9C7CCD
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 04:20:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 741D58F8033
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 02:20:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YeRlcyCFqlqfmh2Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 May 2016 02:20:18 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 72289486B6
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 09:20:17 +0000 (UTC)
Received: from redhat.com (dhcp-26-103.brq.redhat.com [10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4U9KEml020306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Mon, 30 May 2016 05:20:16 -0400
Date: Mon, 30 May 2016 11:20:14 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
Message-ID: <20160530092014.GB13872@redhat.com>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
	<9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
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
To: xfs@oss.sgi.com

On Mon, May 30, 2016 at 04:48:36PM +0800, baotiao wrote:
>    how can I set the extent size hint to a file with command line?
> 
>    I have google for a lot, but I can't find a answer
> 

It can be set with xfs_io, like:

xfs_io -c "extsize 8m" <file>   # To set an extent size hint of 8m

Although, it only works if the file is empty, or more specific, the file must
not have any extents allocated
>    ----------------------------------------
> 
>    Github: [1]https://github.com/baotiao
>    Blog: [2]http://baotiao.github.io
>    Stackoverflow: [3]http://stackoverflow.com/users/634415/baotiao
>    Linkedin: [4]http://www.linkedin.com/profile/view?id=145231990
> 
>    On May 30, 2016, at 13:04, Dave Chinner <[5]david@fromorbit.com> wrote:
> 
>    On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:
> 
>      This machine is running for qemu,  the file is qemu qcow file type
>      [root@w-openstack20
>      /data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file
>      disk
>      disk: QEMU QCOW Image (v3), has backing file (path
>      /data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e),
>      429496729600 bytes
> 
>    Oh, you're using delta/snapshot based qcow images. That, by it's
>    very nature, generates fragmented image files as they are a delta
>    over the backing file.
>    ....
> 
>      actual 48421430, ideal 20716, fragmentation factor 99.96%
>      How can I solve this problem, what do you suggest me to do?
> 
>    Use a extent size hint (say 1-8MB) for your qcow2 image files so that
>    they don't fragment badly as they are written to.
>    Cheers,
>    Dave.
>    --
>    Dave Chinner
>    [6]david@fromorbit.com
> 
> References
> 
>    1. https://github.com/baotiao
>    2. http://baotiao.github.io/
>    3. http://stackoverflow.com/users/634415/baotiao
>    4. http://www.linkedin.com/profile/view?id=145231990
>    5. mailto:david@fromorbit.com
>    6. mailto:david@fromorbit.com

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
