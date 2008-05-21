Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:15:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L8FB0W001392
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:15:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7317B1992F2
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:16:00 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id uIwOgVzUrD5SLyeU for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:16:00 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4L8FrF3002615
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 10:15:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4L8Fqqm002613
	for xfs@oss.sgi.com; Wed, 21 May 2008 10:15:52 +0200
Date: Wed, 21 May 2008 10:15:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scale down 074 on lower end machines
Message-ID: <20080521081552.GB2398@lst.de>
References: <20080515173913.GA11494@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515173913.GA11494@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping?

On Thu, May 15, 2008 at 07:39:13PM +0200, Christoph Hellwig wrote:
> 074 takes ages to complete on my kvm test VM, but scaling it back to the
> level used on IRIX makes it complete in slightly under 10 minutes.
> 
> I'm not sure if checking for UP vs SMP is the right way to go into slow
> mode, but I couldn't think of anything better.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests/074
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfstests/074,v
> retrieving revision 1.7
> diff -u -p -r1.7 074
> --- xfstests/074	9 Nov 2005 02:49:08 -0000	1.7
> +++ xfstests/074	15 May 2008 17:37:03 -0000
> @@ -120,10 +120,17 @@ if [ $HOSTOS == "IRIX" ]; then 
>          param_type="IRIX nondebug"
>      fi
>  elif [ $HOSTOS == "Linux" ]; then
> -    numloops=10
> -    numfiles=5
> -    numchildren=3
> -    param_type="Linux"
> +    if uname -a | grep -q SMP; then
> +        numloops=10
> +        numfiles=5
> +        numchildren=3
> +        param_type="Linux SMP"
> +    else
> +        numloops=2
> +        numfiles=3
> +        numchildren=3
> +        param_type="Linux UP"
> +    fi
>  else
>      numloops=1
>      numfiles=1
---end quoted text---
