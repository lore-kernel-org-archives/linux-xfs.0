Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2125E7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:17:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E632330404E
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:17:39 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1E5Ei6h7vZ82JXGe
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:17:38 -0700 (PDT)
Message-ID: <54512F62.2080303@hardwarefreak.com>
Date: Wed, 29 Oct 2014 13:18:10 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs fs on lvm, failed drive.
References: <CA+r9EUGbxdXxP7uA1ufw=bSKE035VVHcK-Tyatr=fr-t_U=ZAw@mail.gmail.com>
In-Reply-To: <CA+r9EUGbxdXxP7uA1ufw=bSKE035VVHcK-Tyatr=fr-t_U=ZAw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Gary Artim <gartim@gmail.com>, xfs@oss.sgi.com

On 10/29/2014 12:19 PM, Gary Artim wrote:
> Hi...wondering if there is anyway I can salvage a directory on the lvm
> volume that is xfs? thanks of any help, assembled:
> 
> parted /dev/sdx
> mklabel gpt
> mkpart primary xfs 1 -1 (sometime xfs doesnt work until the xfsprogs are
> installed and reboot)
> set 1 lvm on
> 
> do this for each drive.
> pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> vgcreate backup /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> lvcreate -L 9T -n backuplv backup
> mkfs.xfs -L backuplv /dev/mapper/backup-backuplv
> /dev/mapper/backup-backuplv /xfs xfs   (in fstab)
> 
> failed drive:
> /dev/sdc1

You've created an XFS filesystem atop a concatenation of non-redundant
drives so this condition should not be unexpected.  It's not a directory
you want to salvage, but the files within it.  If they reside on sdc1
you're out of luck without using data recovery tools.  If they reside on
sdb1, sdd1, or sde1, then running xfs_repair might make the FS mountable
and get you access to them again.

That's assuming LVM is still running with one drive gone, or will still
assemble the concatenation with one drive missing.  I don't use LVM.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
