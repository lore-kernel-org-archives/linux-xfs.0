Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA3B27F47
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 21:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C79C304043
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 19:41:10 -0700 (PDT)
Received: from mx0b-00153101.pphosted.com (mx0b-00153101.pphosted.com
	[208.86.201.240]) by cuda.sgi.com with ESMTP id
	k2dTotKdEzAtNHRG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 19:41:06 -0700 (PDT)
From: "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Subject: RE: xfs_repair fails
Date: Wed, 20 May 2015 02:41:03 +0000
Message-ID: <D42CEF46A796364580AFE375880EF73F01AD645A5D@SRVMSXMBDEN2.ad.twtelecom.com>
References: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
	<20150514104341.GA15457@bfoster.bfoster>
	<D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
	<20150515121014.GA7099@bfoster.bfoster>
In-Reply-To: <20150515121014.GA7099@bfoster.bfoster>
Content-Language: en-US
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

        Um, OK, it would definitely hang every time I attempt to mount the FS.  It didn't produce errors, it just sat there, and the process could not be killed.  Attempts to kill it would result in it attaching to the init process.  An attempted soft boot would hang after a mount attempt.  Per your suggestion, I cloned the git tree and compiled a new xfsprogs.  It worked!  I'm comparing to the backup system, and so far there are no unexpected failures.  I don't think I lost much, and nothing irreplaceable.

        Thanks a ton.

-----Original Message-----
From: Brian Foster [mailto:bfoster@redhat.com]
Sent: Friday, May 15, 2015 7:10 AM
To: Rhorer, Leslie
Cc: xfs@oss.sgi.com
Subject: Re: xfs_repair fails

On Fri, May 15, 2015 at 03:08:05AM +0000, Rhorer, Leslie wrote:
> kernel 3.16-2-amd64
> xfs_repair  3.2.1
> CPU cores 8
>
...
> Mount hangs if attempted
>

FWIW, I didn't reproduce a mount hang on my test vm running a variant of the 4.0 kernel.

> The XFS meta dump0 can be found at
> http://fletchergeek.com/images/metaxfs.gz
>
> RAID-Server:/var/log# xfs_repair -v /dev/md0 Phase 1 - find and verify
> superblock...
>         - reporting progress in intervals of 15 minutes
>         - block cache size set to 395032 entries Phase 2 - using
> internal log
>         - zero log...
> zero_log: head block 8 tail block 8
> ... <after a few minutes>
>         - scan filesystem freespace and inode maps...
> agi unlinked bucket 38 is 163000358 in ag 31 (inode=133306986534)
> zeroing unused portion of secondary superblock (AG #5) Segmentation
> fault

Thanks for all of the data and the metadump. I could reproduce with xfsprogs v3.2.2 but not with the very latest build out of my source tree. It looks like the crash is due to zeroing a 512 byte sized buffer based on a 4k sector size. This is already fixed in the following
commit:

        8bc43a39 repair: superblock buffers need to be sector sized

... which is available as of v3.2.3-rc1. I'm not sure what/whether packages might be available with that. You might need to grab the source to deal with this particular issue:

        https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/

With that fix, repair gets through and fixes whatever corruption it finds.

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
> Include as much information as you can about the filesystem, storage
> and
> problem:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_
> when_reporting_a_problem.3F
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


-------------



The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
