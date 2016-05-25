Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75BA97CA0
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 02:37:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1A54AC007
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 00:37:54 -0700 (PDT)
Received: from mr003msb.fastweb.it (mr003msb.fastweb.it [85.18.95.87]) by
	cuda.sgi.com with ESMTP id GKpvNGK6eQ3xoPnQ for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 00:37:51 -0700 (PDT)
Subject: Re: LVM snapshot and log record CRC mismatch
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <57455645.5040608@assyoma.it>
Date: Wed, 25 May 2016 09:37:41 +0200
MIME-Version: 1.0
In-Reply-To: <20160524221205.GM21200@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Gionatan Danti <g.danti@assyoma.it>, xfs@oss.sgi.com

On 25/05/2016 00:12, Dave Chinner wrote:
>
> How did you take the snapshot? (full command lines, please)
>

The snapshot is accomplished using the following commands:

lvcreate -s hypervisor/KVM_Storage --name Backup_SNAP
lvchange -ay -K hypervisor/Backup_SNAP
mount -o nouuid /dev/hypervisor/Backup_SNAP /mnt/lvm/

As additional information, this is my logical volume setup (I am using 
thin provisioning):

[root@hypervisor ~]# lvs
   LV           VG         Attr       LSize  Pool         Origin Data% 
Move Log Cpy%Sync Convert
   000-ThinPool hypervisor twi-a-t---  1.75t                      42.42 

   KVM_Storage  hypervisor Vwi-aot---  1.70t 000-ThinPool         43.61 

   root         hypervisor -wi-ao---- 64.00g 

   swap         hypervisor -wi-ao----  7.73g


Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
