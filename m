Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODjrBl184670 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:45:54 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD472E62C83
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:59:28 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	3NoCIMoDawEivRiR for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 06:59:28 -0700 (PDT)
Message-ID: <4C9CABC5.6040806@open-e.com>
Date: Fri, 24 Sep 2010 15:46:45 +0200
From: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
MIME-Version: 1.0
Subject: Re: Problem with file system on iSCSI FileIO
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
	<20100924151858.10528c86@harpe.intellique.com>
In-Reply-To: <20100924151858.10528c86@harpe.intellique.com>
Reply-To: slawomir.nowakowski@open-e.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Dear Emmanuel,


> Le Fri, 24 Sep 2010 13:11:25 +0200
> Slawomir Nowakowski<slawomir.nowakowski@open-e.com>  =E9crivait:
>
>    =

>> But we believe the problem is with the XFS. With unknown reason we
>> are not able to mount the LV and after running xfs_repair the file is
>> missing from the LV. Do you have any ideas how we can try to fix the
>> broken XFS?
>>      =

> This doesn't really make much sense to me. What target are you using?
> scst, tgt, lio or iet? What looks weird to me is that the dd command
> example you gave writes over the xfs filesystem :
>
> dd if=3D/dev/zero of=3D/dev/vg+vg00/lv+i+lv0000 bs=3D1M conv=3Dnotrunc
>
> This is definitely incorrect. Given that /dev/vg+vg00/lv+i+lv0000 is
> your xfs formatted lv, you must mount it somewhere :
>
> mount /dev/vg+vg00/lv+i+lv0000 /mnt/whatever
>
> Then you dd the file on /mnt/whatever :
>
> dd if=3D/dev/zero of=3D/mnt/whatever/lunfile bs=3D1M
>
> Lastly, you declare /mnt/whatever/lunfile as the lun in your target
> (method varies depending upon the target used), something like (ietd
> example):
>
> Target iqn.2010-09:com.whatever.host.target1
> 	Alias host.target1
> 	Lun 0 Type=3Dfileio,Path=3Dmnt/whatever/lunfile,IOMode=3Dwback
>
>    =

It's my mistake in dd command, sorry for that.

First we mount the LV:

mount
[...]
/dev/vg+vg00/lv+i+lv0000 on /mnt/point type xfs =

(rw,nouuid,attr2,nobarrier,noquota)
[...]

then we run dd to file

dd if=3D/dev/zero of=3D/mnt/point/lun bs=3D1M conv=3Dnotrunc count=3D$size

$size is counted to leave some free space on the device

As the iSCSI target we use SCST 1.0.1.2. The scst.conf looks likes like =

this:

[HANDLER vdisk]
DEVICE 0QSP199WJI1yKOPj,/mnt/point/lun,WT,512,0QSP199WJI1yKOPj

[GROUP Default_iqn.2010-03:sn1.target0]
[GROUP Default]

[ASSIGNMENT Default_iqn.2010-03:sn1.target0]
DEVICE 0QSP199WJI1yKOPj,0
[ASSIGNMENT Default]

[TARGETS enable]

[TARGETS disable]

The problem is that we were able to use this LUN in the target, but =

suddenly after a reboot we are not.

Cheers
Slawek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
