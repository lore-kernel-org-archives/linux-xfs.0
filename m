Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 20:04:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8D34T4p013103
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 20:04:31 -0700
Message-ID: <46E8A8BD.5050600@sandeen.net>
Date: Wed, 12 Sep 2007 22:04:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E7460D.3000502@sgi.com>
In-Reply-To: <46E7460D.3000502@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:

> But here you use the name of the lock variable.
> 
>          /*
> -        * We actually don't have to acquire the SB_LOCK at all.
> +        * We actually don't have to acquire the m_sb_lock at all.
>           * This can only be called from mount, and that's single threaded. XXX
>           */

I was going to change this, but "sb lock" sounds way too generic to me...

-Eric
