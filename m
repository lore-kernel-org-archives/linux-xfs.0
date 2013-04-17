Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 028C27F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 08:44:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79964AC004
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:44:18 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	XEY841nCHb20gYrQ for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 06:44:17 -0700 (PDT)
Message-ID: <516EA72F.3030200@univ-nantes.fr>
Date: Wed, 17 Apr 2013 15:44:15 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
	<516CFCB8.1060804@univ-nantes.fr> <516D518F.1000708@sgi.com>
In-Reply-To: <516D518F.1000708@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Le 16/04/2013 15:26, Mark Tinguely a =E9crit :
>
> The filesystem can hang but only if the OS cannot allocate another =

> worker when doing certain calls.
>
> --Mark.

Ok, any chance to see these fixes backported to 3.4 ?

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
