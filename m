Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 18:07:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G17twr016088
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 18:07:55 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 999911274EC9
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 18:09:27 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id BuWD1GUYewtIFHQA for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 18:09:27 -0700 (PDT)
Subject: Re: Bug#499076: Physical walk no longer ignores all symlinks
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <1221526247.21658.21.camel@kulgan.wumi.org.au>
References: <1221526247.21658.21.camel@kulgan.wumi.org.au>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 11:07:31 +1000
Message-Id: <1221527251.5138.15.camel@verge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: tes@sgi.com
Cc: xfs@oss.sgi.com

FYI... that last acl/attr attempt to address symlinks has
broken things for some people it seems ... any thoughts on
the options Kevin lists at the end?

thanks.

On Tue, 2008-09-16 at 10:20 +0930, Kevin Shanahan wrote:
> Package: acl
> Version: 2.2.47-2
> 
> After upgrading a system from Etch to Lenny, we are having some problems
> with our backup scripts which rely on getfacl/getfattr.
> 
> Previously we had been using "getfacl -RP ..." to recursively dump all
> the ACLs in a number of directories which are also Samba shares. Because
> we use the DFS features of Samba, we have numerous intentional
> "dangling" symlinks in these directories. However, now this is causing
> getfacl to exit with non-zero status and spew lots of unwanted output to
> stderr.
> 
> A simple test case to reproduce the problem:
> 
>   #!/bin/sh
>   ln -f -s no_such_file foo
>   getfacl -RP . > dev/null
>   echo $?
> 
> Output on Etch:
>   0
> 
> Output on Lenny:
>   getfacl: ./foo: No such file or directory
>   1
> 
> I realise that upstream changed the behaviour at some point there, as
> the manpage description of the -P option differs between Etch/Lenny.
> However, we still need a way to ignore all symlinks - if the current
> behaviour is be design (I don't understand why this would be desirable),
> then can we have another option to completely ignore symlinks?
> 
> Thanks,
> Kevin.
> 
> 
> 
> 
