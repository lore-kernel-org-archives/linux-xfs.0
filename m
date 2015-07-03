Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B38C47F51
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:06:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1500304064
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:06:09 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id 8MiUDwGm1QHM1Qmc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:06:07 -0700 (PDT)
Date: Fri, 3 Jul 2015 06:06:06 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1516143302.23299575.1435917966372.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150702141403.GA61817@bfoster.bfoster>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
	<20150625193748.GE36162@bfoster.bfoster>
	<413545489.22844725.1435841273912.JavaMail.zimbra@redhat.com>
	<20150702141403.GA61817@bfoster.bfoster>
Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
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
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com



----- Original Message -----
> From: "Brian Foster" <bfoster@redhat.com>
> On Thu, Jul 02, 2015 at 08:47:53AM -0400, Jan Tulak wrote:
> >
> > When I look on the code, where did you got the 4 vs 5? In the old code, for
> > 512GB and bigger is assigned shift=5 directly. In the new one, shift is
> > set to XFS_MULTIDISK_AGLOG which is 5, and then, if the disk is smaller
> > than 512GB, it decrements the value. But unless I'm missing something, the
> > multidisk configuration is not changing anything, there is just a
> > different syntax.
> > 
> 
> I was referring to the multidisk case. The old code looks like this:
> 
>         if (!multidisk && dblocks >= MEGABYTES(128, blocklog)) {
> 		...
>         } else if (dblocks > GIGABYTES(512, blocklog))
>                 shift = 5;
>         else if (dblocks > GIGABYTES(8, blocklog))
>                 shift = 4;
> 
> ... which means if multidisk && dblocks == 512GB, then shift is set to
> 4. With the new code, we set XFS_MULTIDISK_AGLOG as you noted and then
> execute:
> 
> 	if (dblocks < GIGABYTES(512, blocklog))
> 		shift--;
> 	...
> 
> ... which will not decrement shift if dblocks == 512GB (i.e., shift is
> 5).
> 
> If you're still not convinced, create an exact sized 512GB file, mkfs it
> (with the su/sw options set for multidisk) with and without this change
> and observe agcount. :)
> 
> Brian
> 

Ah, mea culpa, I didn't thought about what happens when the size is exactly 512 GB when I wrote the reply. :-) You are right, I'll fix it.

Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
