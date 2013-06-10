Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E51277F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 17:16:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D25028F8037
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 15:16:36 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id AdeXqPp8hbwzmvWu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 15:16:36 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 10 Jun 2013 18:16:35 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 7B8BD6E803F
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:16:27 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5AMGVS2282168 for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:16:31 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5AMGUrw018650 for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:16:31 -0400
Subject: Re: [PATCH 00/48] xfsprogs: CRC support
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130607210447.GP20932@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130607061139.GM29338@dastard>  <20130607210447.GP20932@sgi.com>
Date: Mon, 10 Jun 2013 17:16:29 -0500
Message-ID: <1370902589.22504.8.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

This is helpful. Thanks.

Chandra
On Fri, 2013-06-07 at 16:04 -0500, Ben Myers wrote:
> Hey,
> 
> On Fri, Jun 07, 2013 at 04:11:39PM +1000, Dave Chinner wrote:
> > On Fri, Jun 07, 2013 at 10:25:23AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is the latest update of the series of patches tht introduces
> > > CRC support into xfsprogs. Of note, for CRC enabled filesystems;
> > > 
> > > 	- write support for xfs-db is disabled
> > > 	- obfuscation for metadump is disabled
> > > 	- xfs_check does nothing ("always succeed") so that xfstests
> > > 	  can run without needing this
> > > 	- all structures shoul dbe supported for printing in xfs_db
> > > 	- xfs_repair should be able to fully validate the structure
> > > 	  of a CRC enabled filesystem.
> > > 	- xfs_repair still ignores CRC validation errors when
> > > 	  reading metadata
> > > 	- mkfs.xfs enforces limitations on the format of CRC enabled
> > > 	  filesystems (inode size, attr format, projid32bit, etc).
> > > 	- whenever a v5 superblock is parsed on read by any utility,
> > > 	  it outputs a wanring about it being an experimental
> > > 	  format.
> > > 
> > > Bug reports, patches, comments, reviews, etc all welcome.
> > 
> > I've just realised that I haven't ported any of the recent kernel
> > fixes across to this patch set, so there will be another few patches
> > needed for those as well...
> 
> These two series are applied to the crc-dev branch at
> git://oss.sgi.com/xfs/cmds/xfsprogs.git 
> 
> Regards,
> 	Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
