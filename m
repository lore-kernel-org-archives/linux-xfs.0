Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J32F9X015213 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 22:02:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEAD9BFA00D
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 20:05:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id kh5EwB4d1KIf2oU9 for <xfs@oss.sgi.com>;
	Mon, 18 Apr 2011 20:05:16 -0700 (PDT)
Message-ID: <4DACFBEB.9040909@sandeen.net>
Date: Mon, 18 Apr 2011 22:05:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419025949.GA3030@thunk.org>
In-Reply-To: <20110419025949.GA3030@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On 4/18/11 9:59 PM, Ted Ts'o wrote:

...

> Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
> it's the only way to guarantee correct behaviour for XFS.  But I would
> really rather that be the long-term way we leave things!

XFS ... or ext4:

# xfs_io -Ff -c "falloc 0 1m" -c "pwrite 0 512k" testfile; /root/fiemap-test testfile
wrote 524288/524288 bytes at offset 0
512 KiB, 128 ops; 0.0000 sec (161.342 MiB/sec and 41303.6463 ops/sec)
start 0 length -1 flags 0x0 count 32
ext:   0 logical: [       0..     255] phys:    34048..   34303 flags: 0x801 tot: 256

# uname -r
2.6.39-0.rc3.git2.0.fc16.x86_64

Above is on ext4.  It behaves exactly like XFS in my testing; data in the page cache does not cause fiemap to return anything other than "unwritten" for preallocated extents.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
