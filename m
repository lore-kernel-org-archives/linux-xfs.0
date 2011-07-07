Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67DL62D172182 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 08:21:06 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73FD115ED2E5
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 06:21:03 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id lPUtsTkA6Fz4ea8D for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2011 06:21:03 -0700 (PDT)
Date: Thu, 7 Jul 2011 15:20:59 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Number of ACLs
Message-ID: <20110707152059.2e09f346@harpe.intellique.com>
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
> =

> xfs_acl.h:
> #define XFS_ACL_MAX_ENTRIES 25
> =

> Changing XFS_ACL_MAX_ENTRIES to something higher should do the trick, =

> but will it be safe: ie: will I risk corrupting the FS this way ?
> =

> I understand it'll imply a performance penalty if I add too many ACLs.

I asked recently to the list if there was any evolution on this point,
but unfortunately my question went ignored :( =


Actually you can't simply change this entry and hope that it will
work;  from what I understood, at best your filesystem will become
incompatible with any other kernel in the best case and you may need
to recompile the xfs tools too; in the worst case, compilation will
simply fail.

If you really need a lot of ACLs, the best answer so far is to use JFS,
which supports 1024 ACLs per file without tinkering and without pain.
The main culprit with JFS lies in relatively poor ageing (compared to
XFS), and no available tool to contain fragmentation. Imperfect world.

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
