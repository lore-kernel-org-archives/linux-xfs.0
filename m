Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0T58Fc8093027 for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 23:08:15 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0D4712F8F2A
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 21:09:19 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id AQeKAaHXegawFa32 for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2010 21:09:19 -0800 (PST)
Message-ID: <4B626D80.3010601@sandeen.net>
Date: Thu, 28 Jan 2010 23:09:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: 219: ignore duplicates reported by repquota
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

Alex Elder wrote:
> (Re-sending; I misaddressed it the first time.)
> 
> Arrange to ignore duplicate entries reported by the repquota command.
> This can happen if an id is used more than once (such as when two user
> names are assigned the same uid).
> 
> Do this here by simply dropping any reported entries whose id number
> has already been seen in the output.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

again with the late review ;)

This is causing failures for me:

--- 219.out	2009-11-12 17:27:40.209152659 -0600
+++ 219.out.bad	2010-01-28 23:03:05.933323333 -0600
@@ -27,7 +27,6 @@
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
-#1        --     144       0       0              3     0     0       

raw output looks like:

                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
#0        --       0       0       0              3     0     0       
#1        --     144       0       0              3     0     0       

there's probably better awk to be written than this, but I think this
fixes it:

Alex, you look like an awk-master, can you fix it?

-Eric


> ---
>  219 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: b/219
> ===================================================================
> --- a/219
> +++ b/219
> @@ -85,7 +85,8 @@ test_accounting()
>  		$here/src/lstat64 $file | head -3 | filter_scratch
>  	done
>  
> -	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch
> +	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
> +	awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'
>  }
>  
>  # real QA test starts here
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
