Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QBTMXw067886 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:29:23 -0500
Received: from VA3EHSOBE004.bigfish.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F31B8151FDD7
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:46:11 -0700 (PDT)
Received: from VA3EHSOBE004.bigfish.com (va3ehsobe004.messaging.microsoft.com
	[216.32.180.14]) by cuda.sgi.com with ESMTP id 5PTOfZSm5R69TB9W
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:46:11 -0700 (PDT)
From: =?iso-8859-1?Q?Larsen=2C_Tore_H=F8ivaag?=
	<tore.hoivaag.larsen@cggveritas.com>
Date: Tue, 26 Oct 2010 12:30:22 +0100
Subject: RE: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <CFFC47E79E870F4EBAD0CA24D8CD7652ED04A5F7F8@CRW-EXM01.int.cggveritas.com>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>	<4CC68249.7050409@profihost.ag>
	<20101026094111.48670eb7@galadriel.home>	<4CC688FE.7010206@profihost.ag>
	<20101026130103.7cc43aec@harpe.intellique.com>,
	<4CC6B56B.7020007@profihost.ag>
In-Reply-To: <4CC6B56B.7020007@profihost.ag>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

You should keep the driver and firmware ins sync wither kernel.  Choose e.g=
. latest 9.4.3 iso for 2.6.9, and 9.5.3 for RHEL5/SLES11/Fedora13. Do not u=
se 9.5.3 firmware with RHEL4/SLES10 native driver. If I remeber correctly t=
w_update doesn't even let you mix a downgrade driver with new firmware, and=
 vs.versus.

Iow, If you are on a legacy level, stay with latest legacy 9.4.3 for it.   =


http://kb.lsi.com/KnowledgebaseArticle14546.aspx

I've use a lot of 9550SXU and 9650SE and various MegaRaid. I find 3ware muc=
h easier to work with and better performing with xfs.


//seisqc1> /c2 show all
/c2 Driver Version =3D 2.26.08.003-2.6.18RH
/c2 Model =3D 9550SXU-8LP
/c2 Available Memory =3D 112MB
/c2 Firmware Version =3D FE9X 3.08.00.029


Rgds,
--ToreL

________________________________________
From: xfs-bounces@oss.sgi.com [xfs-bounces@oss.sgi.com] On Behalf Of Stefan=
 Priebe - Profihost AG [s.priebe@profihost.ag]
Sent: Tuesday, October 26, 2010 1:03 PM
To: Emmanuel Florac
Cc: xfs@oss.sgi.com
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1

Hi,

it is a 9650SE-8LPML with Firmware: FE9X 3.06.00.003.

So you mean i should upgrade to 4.x Firmware? Do i then have to do a
filesystem repair? Or just wait if the error accours again?

Stefan

Am 26.10.2010 13:01, schrieb Emmanuel Florac:
> Le Tue, 26 Oct 2010 09:53:34 +0200
> Stefan Priebe - Profihost AG<s.priebe@profihost.ag>  =E9crivait:
>
>> No it is a Raid 5 (3Ware Controller).
>
> What model? Which firmware? If it's a 96x0 model, notice that 4.x.x
> firmwares added lots of performance enhancements and solved many
> problems.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
