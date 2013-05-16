Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B6527F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 15:30:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 290C8AC003
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 13:30:43 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id WunhPYSCXcvYhDgm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 13:30:38 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D1FE39A03DC
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 14:30:37 -0600 (MDT)
Date: Thu, 16 May 2013 16:30:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device V2
Message-ID: <20130516203035.GE1765@localhost.localdomain>
References: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
	<5194E764.6030207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5194E764.6030207@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 16, 2013 at 08:04:20AM -0600, Rich Johnston wrote:
> On 05/15/2013 10:20 AM, Josef Bacik wrote:
> > Dave pointed out that xfs was having issues with 311 because of caching issues.
> > He suggested that I fsck the dm-flakey device to make sure we don't have this
> > problem.  Make _check_scratch_fs take an optional argument to use as the device
> > to fsck.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> Hi Josef,
> 
> Looks like it fails test 19 , are we supposed to see failures for ext4 
> and xfs?
> 

Yeah that's what I was seeing, if you run the fsync tester without the reboot
option and look at the file itself it should match the md5sum thats in the good
output.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
