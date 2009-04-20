Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3KJDLBh080713 for <xfs@oss.sgi.com>; Mon, 20 Apr 2009 14:13:21 -0500
Received: from rgminet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FBE71435A91
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2009 12:15:52 -0700 (PDT)
Received: from rgminet12.oracle.com (rcsinet12.oracle.com [148.87.113.124]) by
	cuda.sgi.com with ESMTP id CF711snyCS9q5xQm for
	<xfs@oss.sgi.com>; Mon, 20 Apr 2009 12:15:52 -0700 (PDT)
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<49E4A131.5040309@isg.de>
	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
	<20090419081927.GE16929@discord.disaster>
	<49EB487C.1020205@sandeen.net> <49ECC2CA.20108@isg.de>
Date: Mon, 20 Apr 2009 15:11:19 -0400
In-Reply-To: <49ECC2CA.20108@isg.de> (Peter Niemayer's message of "Mon, 20 Apr
	2009 20:45:30 +0200")
Message-ID: <yq1ab6b2l9k.fsf@sermon.lab.mkp.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Niemayer <niemayer@isg.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

>>>>> "Peter" == Peter Niemayer <niemayer@isg.de> writes:

Peter> And I did not find any requirement or hint to "tell the largest
Peter> free space around the area just freed" in
Peter> http://www.t13.org/Documents/UploadedDocuments/docs2008/e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc

This was never an issue with SSDs.  The requirement comes from
thin-provisioned SCSI disk arrays that would like us to do unmaps
(trims) in units of their internal block size.

There was a huge pushback from the industry about this.  This is clearly
something the array firmware should have to keep track of and not the
operating system.  As a result the unmap granularity size proposal was
pulled and for a while it looked like everything was going to be fine.

Unfortunately yet another array vendor recently discovered that thin
provisioning is hard and sent out a request to have the granularity
brain damage reinstated in the latest protocol draft.

I'm just hoping that all the vendors who came around on the issue will
stay that way...

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
