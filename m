Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 15:41:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6AMfo6U030424
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:41:52 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A5DCDF2F31
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:42:55 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ySo8bYDKupSItD0N for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:42:55 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KH4qU-0002jZ-23
	for xfs@oss.sgi.com; Fri, 11 Jul 2008 08:42:38 +1000
Date: Fri, 11 Jul 2008 08:42:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfsqa 078 - use rmdir to remove directories
Message-ID: <20080710224237.GX11558@disturbed>
References: <20080522061120.GP173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061120.GP173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping?

On Thu, May 22, 2008 at 04:11:20PM +1000, David Chinner wrote:
> 
> If test 078 fails and you try to run it again immediately, it
> will execute a 'rm -f' on a directory which will fail. This should
> be a rmdir....
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/078 |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: xfs-cmds/xfstests/078
> ===================================================================
> --- xfs-cmds.orig/xfstests/078	2008-03-20 09:10:02.000000000 +1100
> +++ xfs-cmds/xfstests/078	2008-05-15 23:21:58.192413673 +1000
> @@ -50,8 +50,8 @@ _filter_io()
>  # real QA test starts here
>  
>  echo "*** create loop mount point"
> -rm -f $LOOP_MNT 2>/dev/null
> -mkdir $LOOP_MNT || _fail "cannot create loopback mount point"
> +rmdir $LOOP_MNT 2>/dev/null
> +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
>  
>  _grow_loop()
>  {
> 
> 

-- 
Dave Chinner
david@fromorbit.com
