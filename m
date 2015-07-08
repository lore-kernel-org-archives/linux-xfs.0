Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 298DA29E05
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 11:15:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0585304032
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 09:15:00 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id VE0l6kRgOkc4NR6L (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 09:14:58 -0700 (PDT)
Date: Wed, 8 Jul 2015 12:14:56 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <2084199601.25014496.1436372096546.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150702230520.GA22807@dastard>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
	<20150625193748.GE36162@bfoster.bfoster>
	<413545489.22844725.1435841273912.JavaMail.zimbra@redhat.com>
	<20150702141403.GA61817@bfoster.bfoster>
	<20150702230520.GA22807@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>

> At one point during development of this patch set I started writing
> an xfstest to validate that mkfs did all the right input validation
> things and set parameters appropriately so that we didn't
> inadvertently change behaviour. I never really finished it off (like
> the patch set), but I've attached it below to give an idea of where
> I was going with it. It was based on validating the input and CLI
> parameters for the new code, so is guaranteed to fail on an existing
> mkfs binary.


I'm using and extending it, but I'm not sure about some tests, whether it is a change from current behaviour, or if it is rather an issue in the test.

> +
> +# basic "should fail" options
> +# logarithm based options are no longer valid
> +do_mkfs_fail -s log=9 $SCRATCH_DEV

There are some changes in logarithm input (mkfs: validate logarithmic parameters sanely), but it is still supported in the patches. Is there some issue, why to remove them?
Otherwise, it should rather test for (in)valid input for log=xxx, right?

> +rm -f $fsimg
> +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> +do_mkfs_pass -d file $fsimg
> +do_mkfs_pass -d file,name=$fsimg
> +rm -f $fsimg
> +do_mkfs_pass -d size=$fssize,file $fsimg
> +rm -f $fsimg
> +do_mkfs_pass -d size=$fssize,file,name=$fsimg
> +do_mkfs_pass -d file,name=$fsimg

Should all these inputs really pass? What is the expected behaviour for example on -d file,name=$fsimg if the file exists, and what if there is no such file? 

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
