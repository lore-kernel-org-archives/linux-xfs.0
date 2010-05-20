Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KN2LN1233538 for <xfs@oss.sgi.com>; Thu, 20 May 2010 18:02:21 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88D25141DE3D
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 16:04:32 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id DBY7A2GFmIBYwLgG for
	<xfs@oss.sgi.com>; Thu, 20 May 2010 16:04:32 -0700 (PDT)
Message-ID: <4BF5B20F.1020400@tlinx.org>
Date: Thu, 20 May 2010 15:05:03 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
References: <201005181350.15308@zmi.at> <20100518123304.GH2150@dastard>
In-Reply-To: <20100518123304.GH2150@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

If the NFS system doesn't handle ACL's,
you might try using "star" which can handle ACL's and extended file attributes storing them in
an extended tar-format archive.

It has a "-copy" feature that I've used successfully to copy extended file attributes:
(cd sourcedir; star -acl -xattr -no-fsync . /destdir/.)&

and ACL's  from one XFS file system to another, so I'm reasonably sure it's 
archive format (see its manpage for correct options) would also store them.



Dave Chinner wrote:
> On Tue, May 18, 2010 at 01:50:15PM +0200, Michael Monnerie wrote:
>> Hello, I'm trying to rsync from an xfs with ACLs set to another server 
>> which has an xfs filesystem. I mounted the nfs using 
>>
>> Does it mean I can't sync ACLs? How could I do it? I need a full backup 
>> including ACLs, as I want to move all data and then restore.
> 
> NFSv3 doesn't support ACLs, IIRC.
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
