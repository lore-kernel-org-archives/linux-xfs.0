Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n459sb6M011019 for <xfs@oss.sgi.com>; Tue, 5 May 2009 04:54:37 -0500
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 469B614720FC
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 02:58:35 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com
	[216.241.235.118]) by cuda.sgi.com with ESMTP id
	xQPA77F3DKMrlZsL for <xfs@oss.sgi.com>;
	Tue, 05 May 2009 02:58:35 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca
	[127.0.0.1]) by localhost (Postfix) with SMTP id 9B5891070088
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 02:54:38 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca
	(BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with SMTP id 91A6B107006A
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 02:54:38 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: XFS portion that can be offloaded to hardware
Date: Tue, 5 May 2009 02:54:36 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C8392667061588C6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
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

Hi All,

We are currently performing feasibility analysis of XFS in a dense video tr=
affic over IP and PCI. We have chosen XFS to manage the exorbitant data com=
ing from network and PCI(encoders/decoders) to the system. There is a requi=
rement to support 32 live as well recording and playback of video. =


Just wanted to understand from XFS architecture point of view, whether we c=
an offload any CPU / memory consuming cumbersome activity of XFS be offload=
ed in the hardware to improve the performance and responsiveness of overall=
 system. If yes, can it be made generic through some interface layer which =
can be generic interface but implementation would be file system specific. =


Has anyone tried exploring this path before to have custom hardware for imp=
roving XFS performance?

All inputs / suggestions are welcome.

Thanks
Sagar
=A0
=A0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
