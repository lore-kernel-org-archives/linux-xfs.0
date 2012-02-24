Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OFhV8P060113 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 09:43:32 -0600
Received: from smtprelay02.ispgateway.de (smtprelay02.ispgateway.de
	[80.67.31.36]) by cuda.sgi.com with ESMTP id rK5fvfH8cIQvzoNJ
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 07:43:30 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay02.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S0xIv-0005aP-0d
	for xfs@oss.sgi.com; Fri, 24 Feb 2012 16:43:29 +0100
Message-ID: <4F47B020.4000202@cape-horn-eng.com>
Date: Fri, 24 Feb 2012 16:43:28 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
In-Reply-To: <20120224150805.243e4906@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 02/24/2012 03:08 PM, Emmanuel Florac wrote:
> Le Fri, 24 Feb 2012 13:52:40 +0100
> Richard Ems <richard.ems@cape-horn-eng.com> =E9crivait:
> =

>> Hi list,
>>
>> We are getting now 32 x 3 TB Hitachi SATA HDDs.
>> I plan to configure them in a single RAID 6 set with one or two
>> hot-standby discs. The raw storage space will then be 28 x 3 TB =3D 84
>> TB. On this one RAID set I will create only one volume.
>> Any thoughts on this?
> =

> If you'd rather go for more safety you could build 2 16 drives RAID-6
> arrays instead. I'd be somewhat reluctant to make a 30 drives array
> --though current drives are quite safe apparently.

Thanks, yes, this sounds good, but it's a matter of administration
simplicity doing the backups why I chose to have only one
volume/partition/XFS. At some point one of both drives will become near
to full and moving dirs from one partition to the other won't be that
easy with out backup system ...

> =

>>
>> *MKFS*
>> We also heavily use ACLs for almost all of our files. Christoph
>> Hellwig suggested in a previous mail to use "-i size=3D512" on XFS
>> creation, so my mkfs.xfs would look something like:
>>
>> mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sdX1
> =

> Looks OK to me.
>  =

>>
>> *MOUNT*
>> On mount I will use the options
>>
>> mount -o noatime,nobarrier,nofail,logbufs=3D8,logbsize=3D256k,inode64
>> /dev/sdX1 /mount_point
> =

> I think that the logbufs/logbsize option matches the default here. Use
> delaylog if applicable. See the xfs FAQ.

Yes, if I trust the mount manual page, it states "The default value is 8
buffers for any recent kernel." . I suppose 3.2.6 is "a recent kernel",
so this could be avoided, but having it explicitly on the mkfs.xfs line
does not hurt, or?
And for logbsize: "The default value for any recent kernel is 32768."

But then at the end of the manual page for mount it says "December
2004", so how actual is this information? Can the default mount values
be shown by running mount with some verbose and dry-run parameters?

>  =

>> What about the largeio mount option? In which cases would it be
>> useful?
>>
> =

> If you're mostly writing/reading large files. Like really large
> (several megabytes and more).
> =


Ok, thanks.

Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
