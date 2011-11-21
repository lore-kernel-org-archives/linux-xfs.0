Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAL1lYRR194220 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 19:47:35 -0600
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1D3B162980C
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 17:47:32 -0800 (PST)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id yEhW9QolsktABgTV for
	<xfs@oss.sgi.com>; Sun, 20 Nov 2011 17:47:32 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3D7443EE0B6
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:47:29 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 1CF5A45DEB3
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:47:29 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0347B45DEB2
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:47:29 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EAA841DB803E
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:47:28 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B59C41DB803B
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:47:28 +0900 (JST)
Message-ID: <4EC9AD92.6020000@jp.fujitsu.com>
Date: Mon, 21 Nov 2011 10:46:58 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 254: disable space cache
References: <4EC61AC3.6010806@cn.fujitsu.com>
In-Reply-To: <4EC61AC3.6010806@cn.fujitsu.com>
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
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

(2011/11/18 17:43), Li Zefan wrote:
> I can't pass 254, and below is the output:
> 
> 254 3s ... - output mismatch (see 254.out.bad)
> ...
>  ID 256 top level 5 path snap
> -ID 257 top level 5 path subvol
> +ID 258 top level 5 path subvol
> 
> When space cache is enabled (and now mkfs.btrfs always enables it),
> there will be some space cache inodes in the root tree, and they
> consume some IDs, and that's why "subvol" has the ID 258 but not 257.
> 
> Just disable space cache for this test case.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  254 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/254 b/254
> index 5216120..1cd4832 100755
> --- a/254
> +++ b/254
> @@ -48,7 +48,7 @@ _supported_os Linux
>  _require_scratch
>  
>  _scratch_mkfs > /dev/null 2>&1
> -_scratch_mount
> +_scratch_mount -o nospace_cache
>  
>  # First test basic snapshotting
>  echo "Creating file foo in root dir"

I got following error on fedora 16 with your patch:

@@ -1,40 +1,36 @@
 QA output created by 254
+mount: wrong fs type, bad option, bad superblock on /dev/sdc2,
+       missing codepage or helper program, or other error
+       In some cases useful info is found in syslog - try
+       dmesg | tail  or so
+
 Creating file foo in root dir
 List root dir
 foo
 Creating snapshot of root dir
-Create a snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap'
+ERROR: '/mnt2' is not a subvolume
 List root dir after snapshot
 foo
-snap
 List snapshot dir
-foo
+ls: cannot access /mnt2/snap: No such file or directory
 :
 :

And in dmesg:

[246554.739092] btrfs: unrecognized mount option 'nospace_cache'


Thanks,
H.Seto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
