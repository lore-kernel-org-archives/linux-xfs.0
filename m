Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p114ghT0149448 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 22:42:44 -0600
Received: from mx-out.facebook.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 966AA8E28B4
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 20:45:11 -0800 (PST)
Received: from mx-out.facebook.com (outmail020.snc4.facebook.com
	[66.220.144.152]) by cuda.sgi.com with ESMTP id
	oOHWd5tmuvQnz9Ht for <xfs@oss.sgi.com>;
	Mon, 31 Jan 2011 20:45:11 -0800 (PST)
From: Peter Vajgel <pv@fb.com>
Subject: RE: XFS Preallocation
Date: Tue, 1 Feb 2011 04:45:09 +0000
Message-ID: <3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
	<20110128045205.GR21311@dastard>
	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
	<20110129001700.GZ21311@dastard>
In-Reply-To: <20110129001700.GZ21311@dastard>
Content-Language: en-US
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
To: Dave Chinner <david@fromorbit.com>, Jef Fox <jef.fox@kinetx.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Preallocation is the only option. Allowing preallocation without marking extents as unwritten opens a massive security hole (i.e.
> exposes stale data) so I say no to any request for addition of such functionality (and have for years).

How about opening this option to at least root (root can already read the device anyway)?. There are cases when creating large files without writing to them is important. A good example is testing xfs overhead when doing a specific workload (like random reads) to large files. In this case we want to hit the disk on every request. Currently we have a workaround (below) but official support would be preferable.

--pv


# create_xfs_files

dev=$1
mntpt=$2
dircount=$3
filecount=$4
size=$5

# Umount.
umount $2

# Create the fs.
mkfs -t xfs -f -d unwritten=0,su=256k,sw=10 -l su=256k -L "/hay" $dev

# Clear unwritten flag - current xfs ignores this flag
typeset -i agcount=$(xfs_db -c "sb" -c "print" $dev | grep agcount)
typeset -i i=0
while [[ $i != $agcount ]]
do
  xfs_db -x -c "sb $i" -c "write versionnum 0xa4a4" $dev
  i=i+1
done

# Mount the filesystem.
mount -t xfs -o nobarrier,noatime,nodiratime,inode64,allocsize=1g $dev $mntpt

i=0
while [[ $i != $dircount ]]
do
  mkdir $mntpt/dir$i
  typeset -i j=0
  while [[ $j != $filecount ]]
  do
    file=$mntpt/dir$i/file$j
    xfs_io -f -c "resvsp 0 $size" $file
    inum=$(ls -i $file | awk '{print $1}')
    umount $mntpt
    xfs_db -x -c "inode $inum" -c "write core.size $size" $dev
    mount -t xfs -o nobarrier,noatime,nodiratime,inode64,allocsize=1g $dev $mntpt
    j=j+1
  done
  i=i+1
done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
