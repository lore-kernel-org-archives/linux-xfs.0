Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 16:21:42 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k76NLVDW027619
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 16:21:31 -0700
Message-ID: <44D66BBF.8010107@thebarn.com>
Date: Sun, 06 Aug 2006 17:22:55 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: XFS null files
References: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
In-Reply-To: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Briggs <ephemeral.elusive@gmail.com>, xfs@oss.sgi.com

Jeff Briggs wrote:

> Hello.
>
> I've just lost data to XFS, with the files full of nulls. I've found
> posts dating back over two years about such data losses. I'm using
> linux 2.6.17 with xfsprogs 2.8.10.

Check to see if you have this change
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=1.675;r2=1.676;f=h

I helps reduce the null file problem.

>
> emacs claims to fsync on write, yet still I lost data, the faq
> suggests I should not have if this is so?
>
> Is this likely to be fixed soon, or should I switch file system?

Any caching file system could potentially loose data, XFS just happens to
get the file size correct so you end up with a file that is nothing but a
hole. Other file system would probably just give you an empty file.
Either way data in cache always has the potential for being lost.
Running xfs in full sync mode would be safest but you loose many performance
advantages... so it always a trade off of performance vs data integrity.

>
> Many thanks.
>
