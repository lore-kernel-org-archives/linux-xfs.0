Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 251097F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 09:53:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C5638F8035
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 07:53:44 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id V5zGVcAJjczrVLpa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 07:53:42 -0700 (PDT)
Date: Wed, 11 Jun 2014 16:53:42 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS data lost recover
Message-ID: <20140611165342.0cdbd7b2@harpe.intellique.com>
In-Reply-To: <2ccc01cf8580$4e230620$ea691260$@fccn.pt>
References: <27c101cf84e1$7259a7a0$570cf6e0$@fccn.pt>
	<53975CF1.3050807@sandeen.net>
	<2ccc01cf8580$4e230620$ea691260$@fccn.pt>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Duarte  Franco <duarte.franco@fccn.pt>
Cc: xfs@oss.sgi.com

Le Wed, 11 Jun 2014 15:20:32 +0100
"Duarte  Franco" <duarte.franco@fccn.pt> =E9crivait:

> The files are essentially http pages but are thousands of them! Is
> there any way to restore the name of the files or is only by their
> content?
> =


There is no way unfortunately. I've made a perl script that creates a
database of file with their names and inodes to cover precisely this
problem, but you would need to have run it once beforeend to index the
filesystem...

You should try to run the latest xfs_repair first however; you probably
used a very old version. In a similar case a newer xfs_repair was able
to find many files that the previous release couldn't reattach properly
to the filesystem tree.

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
