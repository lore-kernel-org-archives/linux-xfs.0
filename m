Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8879gEU019057 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 02:09:42 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E7FCDA45A0
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 00:21:34 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id VxwPLEJPDOynsrFR for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 00:21:34 -0700 (PDT)
Date: Wed, 8 Sep 2010 09:10:10 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: fragmentation question
Message-ID: <20100908091010.2b3f3478@galadriel.home>
In-Reply-To: <C8AC2AC5.6CA9%bchang@greenplum.com>
References: <C8AC2AC5.6CA9%bchang@greenplum.com>
Mime-Version: 1.0
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
To: Brady Chang <bchang@greenplum.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Le Tue, 7 Sep 2010 17:45:41 -0700 vous =E9criviez:

> I have an issue with fragmentation on a particular device
> thanks for any advice.

I'd try monitoring io with "iostat -mx 4" for a while. I suppose most
write activity goes to data1.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
