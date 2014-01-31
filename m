Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CAFB7FA1
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:32:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB86EAC003
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 11:31:59 -0800 (PST)
Received: from mail-ee0-f51.google.com (mail-ee0-f51.google.com
	[74.125.83.51]) by cuda.sgi.com with ESMTP id L2MITT1aJVaC5yVw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 11:31:58 -0800 (PST)
Received: by mail-ee0-f51.google.com with SMTP id b57so2520852eek.10
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 11:31:57 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
From: "Juan A. Sillero" <juan.sillero@gmail.com>
In-Reply-To: <20140129184250.7af7200f@harpe.intellique.com>
Date: Fri, 31 Jan 2014 20:31:25 +0100
Message-Id: <CC18E95B-75B3-47CE-8FBE-9FA511A38CD5@torroja.dmt.upm.es>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<1391009068.4294.83.camel@montana.filmlight.ltd.uk>
	<1391014448.2573.95.camel@islero.dmt.upm.es>
	<20140129184250.7af7200f@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com, Roger Willcocks <roger@filmlight.ltd.uk>, Guillem Borrell i Nogueras <guillem@torroja.dmt.upm.es>

Hello Emmanuel,

The disk controller are QLogic:

04:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI =
Express HBA (rev 02)
04:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI =
Express HBA (rev 02)
05:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI =
Express HBA (rev 03)
05:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI =
Express HBA (rev 03)

06:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5G=
T/s - IB QDR / 10GigE] (rev b0)


Thanks again,

Juan

On Jan 29, 2014, at 6:42 PM, Emmanuel Florac <eflorac@intellique.com> wrote:

> Le Wed, 29 Jan 2014 17:54:08 +0100
> "Juan A. Sillero" <sillero@torroja.dmt.upm.es> =E9crivait:
> =

>> We'd like to know your opinion about what to do next. The data is
>> still probably on the disks, but the RAID topology is gone.  We'd
>> also like to know if someone has experienced a similar hardware
>> problem that could give us some advice.
> =

> I tought it was a dmraid raid 5 device? If it's a RAID controller, what
> brand/model is it? =

> =

> At this point you could give a try to UFS Explorer.
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
