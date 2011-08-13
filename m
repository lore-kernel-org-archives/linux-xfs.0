Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7DG1Cf6147910 for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 11:01:12 -0500
Received: from mo-p00-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EFCB1EFC3F0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 09:01:10 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.160]) by
	cuda.sgi.com with ESMTP id Hbx5LF9FOwGMFx8C for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2011 09:01:10 -0700 (PDT)
Message-ID: <4E469EFD.7070407@giantdisaster.de>
Date: Sat, 13 Aug 2011 17:57:49 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: xfstests #62 broken on ext4
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
In-Reply-To: <E1QsFMR-0001iq-Vt@tytso-glaptop>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 13.08.2011 16:38, Theodore Ts'o wrote:
> Xfstests #62 was recently enabled by commit b2b36d0a4.
>
> However, this test is failing for ext4 because ext4 doesn't support
> extended attributes on anything other than regular files and
> directories.  This is behavior is documented in the attr(5) man page:

> (3) Modify test #62 so that it can support both the XFS and Linux
> generic behavior.

> (5) Change XFS to match the generic behavior, and then change test #62.

I would volunteer for implementing the required changes for option #3 
and start next week except people favour option #5.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
