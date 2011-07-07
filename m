Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67DQMAi173218 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 08:26:22 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38A9E15ED349
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 06:26:20 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id Wpo7HS0Q5G4NeeV4 for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2011 06:26:20 -0700 (PDT)
Date: Thu, 7 Jul 2011 15:26:16 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Number of ACLs
Message-ID: <20110707152616.0e03b866@harpe.intellique.com>
In-Reply-To: <4E15AA1A.3090802@lncsa.com>
References: <4E15AA1A.3090802@lncsa.com>
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
To: Laurent CARON <lcaron@lncsa.com>
Cc: xfs@oss.sgi.com

Le Thu, 07 Jul 2011 14:44:10 +0200
Laurent CARON <lcaron@lncsa.com> =E9crivait:

> I'd like to know if it is possible in a simple & safe way to increase =

> the number of supported ACLs on an already existing FS.

I just realised I missed that part : there is absolutely no way to
change an existing filesystem after the fact. =


My previous answer was about the fact that by installing a modified
kernel module, there is a slight possibility that you can create a
NEW filesystem with more ACLs (and beware, this is untested,
unsupported, uncharted territory, "there be dragons" and al). Given that
the modified xfs module actually works, given that the mkfs.xfs and
other tools behave as expected (unlikely), and that the whole setup
won't fall down in flames the first time you actually create 26 ACLs on
a file, etc.

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
