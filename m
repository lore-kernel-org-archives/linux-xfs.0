Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10C337FA3
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 06:43:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91848AC002
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 04:43:43 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id vxkjA9UUYYhyCADr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 04:43:41 -0700 (PDT)
Date: Fri, 29 Aug 2014 13:43:43 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Run out of inodes?
Message-ID: <20140829134343.5d1c1c61@harpe.intellique.com>
In-Reply-To: <54005108.1020203@inserm.fr>
References: <54005108.1020203@inserm.fr>
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
To: Samuel Granjeaud <samuel.granjeaud@inserm.fr>
Cc: xfs@oss.sgi.com

Le Fri, 29 Aug 2014 12:08:08 +0200
Samuel Granjeaud <samuel.granjeaud@inserm.fr> =E9crivait:

> I have a XFS system of 18T over LVM. Recently, I could not create new =

> files or directories.

What is the distribution, the kernel version (uname -a)? What are the
mount options? Maybe the FS has been mounted with inode64 as an option
at some point in time, but isn't anymore?

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
