Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ACBqI3090421 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 07:11:53 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9D391D3CB7B
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:12:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 0uGkhRHDgLwaQ9mf for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:12:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 4C7D2818155
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 14:12:05 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 549F5818174
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 14:12:03 +0200 (CEST)
Date: Wed, 10 Jun 2009 14:12:06 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_growfs doesn't grow on 2TB raid
Message-ID: <20090610141206.380b5edb@harpe.intellique.com>
In-Reply-To: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
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
To: xfs@oss.sgi.com

Le Wed, 10 Jun 2009 12:52:01 +0200
jack the ripper <evil_metalpeet@hotmail.com> =E9crivait:

> But at the last step, when I do xfs_growfs, nothing happens. I
> found out about the -d option and this is what I get (pay attention to
> the last line):

Do you run a full 64 bits system? If you're running a 64 bits kernel,
you need a 64 bits xfs_growfs.

-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
