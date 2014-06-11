Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E037F7F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 09:20:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF9A1304039
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 07:20:41 -0700 (PDT)
Received: from app02.fccn.pt (app02.fccn.pt [193.137.198.37]) by cuda.sgi.com
	with ESMTP id FCEhBqQiSHZbCm2i (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 07:20:35 -0700 (PDT)
Received: from mx.anubis.local (ste [10.1.2.2])
	by outbound.anubis.local (Postfix) with ESMTP id 1FFC9D2C23
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 15:20:35 +0100 (WEST)
From: "Duarte  Franco" <duarte.franco@fccn.pt>
References: <27c101cf84e1$7259a7a0$570cf6e0$@fccn.pt>
	<53975CF1.3050807@sandeen.net>
In-Reply-To: <53975CF1.3050807@sandeen.net>
Subject: RE: XFS data lost recover
Date: Wed, 11 Jun 2014 15:20:32 +0100
Message-ID: <2ccc01cf8580$4e230620$ea691260$@fccn.pt>
MIME-Version: 1.0
Content-Language: pt
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Eric Sandeen' <sandeen@sandeen.net>, xfs@oss.sgi.com

Thanks for you reply


-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] =

Sent: 10 de junho de 2014 20:31
To: Duarte Franco; xfs@oss.sgi.com
Subject: Re: XFS data lost recover

On 6/10/14, 2:23 PM, Duarte Franco wrote:
> Hi
> =

>  =

> =

> I have a Linux RHEL 5.3 server with a XFS partition over lvm on an =

> infortrend Fc storage.

> Recently we have a system failure that corrupt the XFS partition.
> After a xfs_restore the partition was recovered but the lost+found =

> directory contain about 5.5TB of inode files. (almost the total size
> 7TB)
> =


presumably you mean xfs_repair?

lost+found/ is populated with files for which name data has been lost.
There is no great way to recover the names; if there were, xfs_repair would
do it.

Yes it was a xfs_repair.

> =

> After that the partitions were used to write a few more data, without =

> any problem.
> =

> =

> =

> I would like to ask if there is any way to recover the files in
> lost+found directory? Do you have any service to recover these
> files?

The files themselves are not lost, but they have lost their names.

Depending on the data you have in the files, perhaps they are still
recognizable, and could be renamed back to their original locations via
script?

The files are essentially http pages but are thousands of them! Is there any
way to restore the name of the files or is only by their content?

Regards
Duarte

-Eric

> =

> =

> If possible I would prefer to be contacted by email.
> =

>  =

> =

> Best Regards
> =

>  =

> =

> Duarte Franco
> =

> *AIA*=96 Area Infra-estruturas Aplicacionais
> =

>  _________________________________________________
> =

> FCT, FCCN
> =

> Av. do Brasil, 101 Apartado 50435 1708-001 Lisboa
> =

> Telf. 300 005 257  Fax 351 21 8472167
> =

> http://www.fccn.pt/ <blocked::http://www.fccn.pt/>
> =

>  =

> =

> *Aviso de Confidencialidade*
> =

> Esta mensagem =E9 exclusivamente destinada ao seu destinat=E1rio, podendo
conter informa=E7=E3o CONFIDENCIAL, cuja divulga=E7=E3o est=E1 expressament=
e vedada
nos termos da lei. Caso tenha recepcionado indevidamente esta mensagem,
solicitamos-lhe que nos comunique esse mesmo facto por esta via ou para o
telefone +351 218440100 devendo apagar o seu conte=FAdo de imediato.
> =

> This message is intended exclusively for its addressee. It may
containCONFIDENTIAL information protected by law. If this message has been
received by error, please notify us via e-mail or by telephone +351
218440100 and delete it immediately.
> =

>  =

> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
