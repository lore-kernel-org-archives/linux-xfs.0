Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3G583iM113930 for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 00:08:03 -0500
Received: from mail.shawcable.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63B923E5F20
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 22:11:26 -0700 (PDT)
Received: from mail.shawcable.com (shawmail.shawcable.com [64.59.128.220]) by
	cuda.sgi.com with ESMTP id 3kF5Sty1xEkewoC3 for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 22:11:26 -0700 (PDT)
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
In-Reply-To: <20110416005040.GP21395@dastard>
Mime-Version: 1.0 (iPhone Mail 8G4)
Message-Id: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 23:11:23 -0600
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?utf-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On 2011-04-15, at 6:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> What you are suggesting is that FIEMAP needs to be page cache
> coherent, and that is far, far away from the intended use of the
> interface. Even consiering that you need to looking for active pages
> in the page cache when mapping extents say to me that you are
> doing something very wrong.
> 
> Unwritten extents remain unwritten until the data is physically
> written to them. Therefore, to change their state, you need to sync
> the data covering the range.

In that case, it means cp should just always use FIEMAP_FLAG_SYNC, which is fine. 

Cheers, Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
