Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3GCIEKM135061 for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 07:18:14 -0500
Received: from dmz-mailsec-scanner-2.mit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CD033E6429
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 05:21:37 -0700 (PDT)
Received: from dmz-mailsec-scanner-2.mit.edu (DMZ-MAILSEC-SCANNER-2.MIT.EDU
	[18.9.25.13]) by cuda.sgi.com with ESMTP id S42JeCpp4O3iMVgm
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 05:21:37 -0700 (PDT)
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Mime-Version: 1.0 (Apple Message framework v1084)
From: Theodore Tso <tytso@mit.edu>
In-Reply-To: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
Date: Sat, 16 Apr 2011 08:21:28 -0400
Message-Id: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>


On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:

> In that case, it means cp should just always use FIEMAP_FLAG_SYNC, which is fine. 

Except that if someone is copying a large delay allocated file, it will cause 
the file to immediately snapped to disk, which might not be the greatest
thing in the world.  Christoph is write, SEEK_HOLE and SEEK_DATA are
a much better API for what cp woulld lke to do.  Unfortunately it hasn't
been implemented yet in the VFS...

- Ted
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
