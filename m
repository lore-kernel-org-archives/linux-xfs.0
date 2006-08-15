Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 15:15:08 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7FMEtDW004688
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 15:14:55 -0700
Received: by py-out-1112.google.com with SMTP id c39so1947965pyd
        for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 15:14:24 -0700 (PDT)
Message-ID: <83d59530608151514m288edcf1te3268b413b94dd2a@mail.gmail.com>
Date: Tue, 15 Aug 2006 23:14:23 +0100
From: "Jeff Briggs" <ephemeral.elusive@gmail.com>
Subject: Re: XFS null files
In-Reply-To: <44D66BBF.8010107@thebarn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
	 <44D66BBF.8010107@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

On 06/08/06, Russell Cattelan <cattelan@thebarn.com> wrote:
> Check to see if you have this change
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=1.675;r2=1.676;f=h
>
> I helps reduce the null file problem.

i do not.

> > emacs claims to fsync on write, yet still I lost data, the faq
> > suggests I should not have if this is so?
> >
> > Is this likely to be fixed soon, or should I switch file system?
>
> Any caching file system could potentially loose data, XFS just happens to
> get the file size correct so you end up with a file that is nothing but a
> hole. Other file system would probably just give you an empty file.
> Either way data in cache always has the potential for being lost.
> Running xfs in full sync mode would be safest but you loose many performance
> advantages... so it always a trade off of performance vs data integrity.

it's really ugly how the default is not safe. i didn't have my write
cache disabled, but it is now.

thanks for the responses.
