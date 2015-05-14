Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 484727F4E
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 05:43:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DF4A304032
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 03:43:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T5tzkX127BD4DD63 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 03:43:44 -0700 (PDT)
Date: Thu, 14 May 2015 06:43:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair fails
Message-ID: <20150514104341.GA15457@bfoster.bfoster>
References: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
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

On Thu, May 14, 2015 at 04:17:17AM +0000, Rhorer, Leslie wrote:
> I have an XFS filesystem built on a 24T RAID6 Array under Debian Jessie Linux.  The kernel is 3.16-2-amd64, and the xfs_repair version is 3.2.1.  The file system has some inconsistencies, but every time I try to run xfs_repair, it segfaults.  What should I do?
> 

Include as much information as you can about the filesystem, storage and
problem:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

For a repair crash, the full output of the repair is a good start. Also,
an xfs_metadump of the fs is probably the most effective tool to help us
try and reproduce the problem, if you have somewhere you can post one.

Brian

> 
> 
> -------------
> 
> The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
