Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 17:41:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2O0foYZ026330
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 17:41:53 -0700
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86D966DA2AD
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 17:42:24 -0700 (PDT)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id RAmJA4sFhKxNj0nR for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 17:42:24 -0700 (PDT)
Date: Mon, 24 Mar 2008 01:41:50 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Poor VMWare disk performance on XFS partition
In-Reply-To: <876423.51989.qm@web52006.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk>
References: <876423.51989.qm@web52006.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Hendrik ." <chasake@yahoo.com>
Cc: xfs@oss.sgi.com

On Sun, 23 Mar 2008, Hendrik . wrote:

> I've been converting some of my drives from EXT3 to
> XFS a while ago. Now I notice poor disk performance
> when using XFS as underlying filesystem for a VMware
> virtual drive. I did some experiments and it really
> seems to be the XFS filesystem 'trashing' the speed of
> a VMware Windows XP guest.

Mount XFS partition with "nobarrier" option. I'm using also
logbufs=8,logbsize=256k for vmware.

jan

-- 
