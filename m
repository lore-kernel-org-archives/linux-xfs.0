Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FA0C7F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 21:02:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BB88304071
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 19:02:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	L8HOIP4qAEhWerBf for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 19:02:46 -0700 (PDT)
Date: Fri, 22 Mar 2013 13:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 0/5] xfs: Allow pquota and gquota to be used together
Message-ID: <20130322020243.GR17758@dastard>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 21, 2013 at 04:52:49PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> This is the version 7 of the changes to allow pquota and gquota to be used
> together.
> 
> Patchset applies cleanly on top of 56cea2d088811b8cf7d2893e29bcf369a912de69
> in xfs git tree.
> 
> Ran latest xfstests against it.

As an information point - I've got a separate pquota inode in the
version 5 superblock format used in the CRC patchset. Given that
this functionailty requires mkfs/db/repair support, woul dit be
better to wait until the CRC code goes in and we can then add this
feature without having to rework the superblock CRC patches around
it?

i.e. it will always be available on v5 superblocks, or v4
superblocks when the feature bit is set to indicate the pquota inode
part of the superblock is valid?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
