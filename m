Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FC877F53
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 10:01:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F51A8F8049
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 08:01:24 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id qGuHy6Ne1jylasBm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Mar 2013 08:01:23 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 22 Mar 2013 11:01:22 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 8C48DC9007F
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 11:01:14 -0400 (EDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2MF1DoT273094 for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 11:01:14 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2MF3SgJ006746
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 09:03:28 -0600
Subject: Re: [PATCH v7 0/5] xfs: Allow pquota and gquota to be used together
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130322020243.GR17758@dastard>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
	<20130322020243.GR17758@dastard>
Date: Fri, 22 Mar 2013 10:00:46 -0500
Message-ID: <1363964446.27672.14.camel@chandra-dt.ibm.com>
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
Cc: xfs@oss.sgi.com

Sure. I will look at your CRC patchset and see what changes are needed
to mine.

Meantime, you can answer my dilemma with the change in fs_quota_stat
(see patch 4).

As per your suggestion, I changed the data structure, to include pads at
relevant places in the data structure, which also means that the new
modified structure is not compatible with older user space code. 

So, I created a copy of the older structure (fs_quota_stat_v1) and used
that if the user space request has older structure. So, now the new
kernel code is backward compatible with the old (already running) user
space code. All is well till now....

Now, I make the changes to the user space code so as to use the new
fs_quota_stat. Since the data structure has changed, the new user space
code will not work with the old kernel code.

This is where I have the dilemma. 

1. Leave the user space code to work only with the newer version,
breaking the compatibility with the older kernel (with an error
message).
   or
2. Read the superblock, and if pquotino is _not_ present conclude older
version of fs_quota_stat would suffice for getting quota information
from kernel (note that this will work properly with newer kernel code
too), and use the older version of fs_quota_stat_v1 for quotactl.
   or
3. Any other clever way ? :)

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
