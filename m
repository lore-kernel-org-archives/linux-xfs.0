Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NEApRV204621 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 09:10:51 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C79C81B8F931
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 07:13:53 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id dHU7iNyP7FlSYqho for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 07:13:53 -0700 (PDT)
Date: Fri, 23 Jul 2010 16:13:41 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: 4k sector drives
Message-ID: <20100723141341.GA3727@citd.de>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<201007231259.11714@zmi.at> <4C4994CB.2050200@hardwarefreak.com>
	<20100723133843.GA3397@citd.de>
	<20100723155034.2a42ccd7@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100723155034.2a42ccd7@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 23.07.2010 15:50, Emmanuel Florac wrote:
> Le Fri, 23 Jul 2010 15:38:43 +0200
> Matthias Schniedermeyer <ms@citd.de> =E9crivait:
> =

> > Only for writes, reads are for practically unaffected.
> =

> Sequential writes may be relatively unaffected too; if you write
> sequentially a couple of megabytes you'll have only a couple of
> additional blocks at the beginning and end of operation.

What MAY hurt, also for large writes, are the meta-data operations while =

writing the file. (e.g. the file-size changes, journaling ...)

But i haven't tested that and can't say for sure how much that hurts.




Bis denn

-- =

Real Programmers consider "what you see is what you get" to be just as =

bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, =

cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
