Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EJaKEA014414 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 14:36:20 -0500
Received: from mx.meyering.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E61313E1E48
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 12:39:42 -0700 (PDT)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64]) by
	cuda.sgi.com with SMTP id qChorqbbHGRh5fGM for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2011 12:39:42 -0700 (PDT)
From: Jim Meyering <jim@meyering.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
In-Reply-To: <878vvcspz0.fsf@rho.meyering.net> (Jim Meyering's message of
	"Thu, 14 Apr 2011 19:27:31 +0200")
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <878vvcspz0.fsf@rho.meyering.net>
Date: Thu, 14 Apr 2011 21:39:39 +0200
Message-ID: <8739lksjus.fsf@rho.meyering.net>
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
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

Jim Meyering wrote:
...
> FYI, I see the same failure now using ext3 (and but not w/ext4)
> with rawhide's 2.6.39-0.rc2.git0.0.fc16.x86_64:

Correction.
The failure below is not on ext3, but on a loopback-mounted
ext4 file system.

The test detected that the current FS was ext3 -- and it's known
that this test is not useful on ext3 -- and since I was running it
as root, it creates a loopback ext4 file system on which to run the test.

>   + df -t ext3 .
>   + require_root_
>   + uid_is_privileged_
>   ++ id -u
>   + my_uid=0

However, other strange things are happening here.
I'm investigating.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
