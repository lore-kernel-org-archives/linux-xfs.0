Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65DIx4K261876 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 08:18:59 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98CC01E58582
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 06:18:58 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id i8VknEhdKblPpfZw
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 06:18:58 -0700 (PDT)
Message-ID: <4E130F3C.3050207@dermichi.com>
Date: Tue, 05 Jul 2011 15:18:52 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs_bmap Cannot allocate memory
References: <4E129B00.4020709@dermichi.com>
	<20110705103217.GC561@dastard>	<4E12EB13.50302@dermichi.com>
	<20110705113929.GA21663@dastard>
In-Reply-To: <20110705113929.GA21663@dastard>
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
To: xfs@oss.sgi.com

Hi Dave!
> 
> Ah, there's a mismatch betwenteh man page and the implementation,
> then. The man page implies that "-n <num>" means query num extents
> at a time to map the entire file. It's implemented as "map the first
> <num> extents", though.
> 
> You could try this:
> 
> # xfs_io -f -c "fiemap -v" <file>
> 
> Because fiemap loops doing getting a small number of extents at a
> time...
> 
Ok, after i found out that fiemap is bleeding-edge (xfsprogs 3.1.5
doesn't support it) i compiled the latest git version of xfsprogs.

"fiemap -v" doesn't bail out on this file but continues to print extents
forever. I stopped it after the redirected output had already reached
90GiB and printed negative numbers. I guess it must have run into an
endless loop somewhere. xfs_bmap from the git version also throws
"Cannot allocate memory" at me.

# ./io/xfs_io -f -c "fiemap" /backup/tmp/cannot_allocate_memory.vhd >
/tmp/fiemap_output.txt
(Control-C)

# ls -lh /tmp/fiemap_output.txt
-rw-r--r-- 1 root root 90G 2011-07-05 15:06 /tmp/fiemap_output.txt

# tail -n10 /tmp/fiemap_output.txt
	-1925931740: [599928..602239]: 399016..401327
	-1925931739: [602240..603895]: hole
	-1925931738: [603896..603903]: 2480..2487
	-1925931737: [603904..606199]: hole
	-1925931736: [606200..608127]: 366632..368559
	-1925931735: [608128..1183]: hole
	-1925931734: [1184..134279]: 444611744..444744839
	-1925931733: [134280..134399]: hole
	-1925931732: [134400..206495]: 433472688..433544783
	-1925931731: [206496..210455]: hole

# ./io/xfs_io -f -c "bmap" /backup/tmp/cannot_allocate_memory.vhd
xfs_io: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0
["/backup/tmp/cannot_allocate_memory.vhd"]: Cannot allocate memory

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
