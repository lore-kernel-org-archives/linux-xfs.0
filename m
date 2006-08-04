Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 04:38:23 -0700 (PDT)
Received: from otto.lonx.net (work.lonx.net [195.243.240.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74Bc6DW013390
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 04:38:07 -0700
Received: from localhost (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id 19826261F
	for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 13:37:34 +0200 (CEST)
Received: from otto.lonx.net ([127.0.0.1])
 by localhost (otto [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 30432-08 for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 13:37:32 +0200 (CEST)
Received: from otto.lonx.net (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id B57112619
	for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 13:37:32 +0200 (CEST)
Message-ID: <48367.62.159.242.114.1154691452.squirrel@otto.lonx.net>
In-Reply-To: <20060804102949.B2401829@wobbly.melbourne.sgi.com>
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>
    <44D20473.3010304@sandeen.net>
    <20060804102949.B2401829@wobbly.melbourne.sgi.com>
Date: Fri, 4 Aug 2006 13:37:32 +0200 (CEST)
Subject: Re: "xfs_io -c chattr +i " on a symlink
From: "Dan Am" <xfs@lonx.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, August 4, 2006 2:29 am, Nathan Scott wrote:

> ... I think you just set immutable on /tmp.  Try a broken symlink,
> instead of one that points to an existing inode.
Nope:
/data/tara-test > ls -l test
lrwxr-xr-x  1 root root 13 Aug  4 13:33 test -> /archive/no-such-file

/data/tara-test > xfs_io -c "chattr +i" test
test: No such file or directory

Best Regards
Dan
