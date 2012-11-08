Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8KSJgh020456 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 14:28:19 -0600
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 5DGt4Arsvol75oTV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 12:30:14 -0800 (PST)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	qA8KUBNS009579 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 12:30:13 -0800
Message-ID: <509C1653.7050906@tlinx.org>
Date: Thu, 08 Nov 2012 12:30:11 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: better perf and memory uage for xfs_fsr? Trivial patch
	against	xfstools-3.16 included...
References: <509BAABF.3030608@tlinx.org>
In-Reply-To: <509BAABF.3030608@tlinx.org>
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
To: xfs-oss <xfs@oss.sgi.com>

FWIW, the benefit, probably comes from the read-file, as the written file
is written with DIRECT I/O and I can't see that it should make a difference
there.

Another thing I noted -- when xfs_fsr _exits_, ALL of the space it had used
for file cache read into memory -- gets freed - whereas before, it just stayed in
the buffer cache and didn't get released until the space was needed.

Linda Walsh wrote:
> I wondered why it lumped all this memory reclaiming and thought to try 
> using
> the posix_fadvise calls in xfs_fsr to tell the kernel what data was 
> unneeded
> and such...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
