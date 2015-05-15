Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B6B87F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 07:10:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9904FAC003
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 05:10:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fhiIfb4gutfVDig4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 05:10:17 -0700 (PDT)
Date: Fri, 15 May 2015 08:10:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair fails
Message-ID: <20150515121014.GA7099@bfoster.bfoster>
References: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
	<20150514104341.GA15457@bfoster.bfoster>
	<D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
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
To: "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 15, 2015 at 03:08:05AM +0000, Rhorer, Leslie wrote:
> kernel 3.16-2-amd64
> xfs_repair  3.2.1
> CPU cores 8
> 
...
> Mount hangs if attempted
> 

FWIW, I didn't reproduce a mount hang on my test vm running a variant of
the 4.0 kernel.

> The XFS meta dump0 can be found at http://fletchergeek.com/images/metaxfs.gz
> 
> RAID-Server:/var/log# xfs_repair -v /dev/md0
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
>         - block cache size set to 395032 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 8 tail block 8
> ... <after a few minutes>
>         - scan filesystem freespace and inode maps...
> agi unlinked bucket 38 is 163000358 in ag 31 (inode=133306986534)
> zeroing unused portion of secondary superblock (AG #5)
> Segmentation fault

Thanks for all of the data and the metadump. I could reproduce with
xfsprogs v3.2.2 but not with the very latest build out of my source
tree. It looks like the crash is due to zeroing a 512 byte sized buffer
based on a 4k sector size. This is already fixed in the following
commit:

	8bc43a39 repair: superblock buffers need to be sector sized

... which is available as of v3.2.3-rc1. I'm not sure what/whether
packages might be available with that. You might need to grab the source
to deal with this particular issue:

	https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/

With that fix, repair gets through and fixes whatever corruption it
finds.

Brian

> 
> -----Original Message-----
> From: Brian Foster [mailto:bfoster@redhat.com]
> Sent: Thursday, May 14, 2015 5:44 AM
> To: Rhorer, Leslie
> Cc: xfs@oss.sgi.com
> Subject: Re: xfs_repair fails
> 
> On Thu, May 14, 2015 at 04:17:17AM +0000, Rhorer, Leslie wrote:
> > I have an XFS filesystem built on a 24T RAID6 Array under Debian Jessie Linux.  The kernel is 3.16-2-amd64, and the xfs_repair version is 3.2.1.  The file system has some inconsistencies, but every time I try to run xfs_repair, it segfaults.  What should I do?
> >
> 
> Include as much information as you can about the filesystem, storage and
> problem:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> For a repair crash, the full output of the repair is a good start. Also, an xfs_metadump of the fs is probably the most effective tool to help us try and reproduce the problem, if you have somewhere you can post one.
> 
> Brian
> 
> >
> >
> > -------------
> >
> > The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.
> 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 
> -------------
> 
> 
> 
> The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
