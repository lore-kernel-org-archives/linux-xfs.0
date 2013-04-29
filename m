Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4994C7F52
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 12:28:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B49F3AC001
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 10:28:29 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id 3obaUc0wB8CFerXN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Apr 2013 10:28:28 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 29 Apr 2013 11:28:27 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 7BE0B19D804A
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:28:18 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3THSCDJ089908 for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:28:13 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3THSBtN006916
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:28:11 -0600
Subject: Re: [PATCH v7 0/5] xfs: Allow pquota and gquota to be used together
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130322020243.GR17758@dastard>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
	<20130322020243.GR17758@dastard>
Date: Mon, 29 Apr 2013 12:28:03 -0500
Message-ID: <1367256483.4098.22.camel@chandra-dt.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

Hi Dave,

Now that CRC changes are in. I am beginning to get my patches on top ot
the current tree.

If you can review and provide me feedback on my patch set, I will work
it in my next revision.

Regards,

Chandra
On Fri, 2013-03-22 at 13:02 +1100, Dave Chinner wrote:
> On Thu, Mar 21, 2013 at 04:52:49PM -0500, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > This is the version 7 of the changes to allow pquota and gquota to be used
> > together.
> > 
> > Patchset applies cleanly on top of 56cea2d088811b8cf7d2893e29bcf369a912de69
> > in xfs git tree.
> > 
> > Ran latest xfstests against it.
> 
> As an information point - I've got a separate pquota inode in the
> version 5 superblock format used in the CRC patchset. Given that
> this functionailty requires mkfs/db/repair support, woul dit be
> better to wait until the CRC code goes in and we can then add this
> feature without having to rework the superblock CRC patches around
> it?
> 
> i.e. it will always be available on v5 superblocks, or v4
> superblocks when the feature bit is set to indicate the pquota inode
> part of the superblock is valid?
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
