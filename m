Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 06:51:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NDpRdU000386
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 06:51:29 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1CD710D85A9
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 06:53:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jnDh5yaoGkvXESDS for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 06:53:13 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9943EAC359B
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 08:53:11 -0500 (CDT)
Message-ID: <490081C6.1030301@sandeen.net>
Date: Thu, 23 Oct 2008 08:53:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: print superblock offsets and why they
 can't	be verified
References: <20081022183636.GE20550@kyra> <20081022234128.GC4395@kyra>
In-Reply-To: <20081022234128.GC4395@kyra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

KELEMEN Peter wrote:
> Eric has pointed out that verify_set_primary_sb() will either
> return 1 or XR_INSUFF_SEC_SB.  Move the check lower into
> verify_set_primary_sb() by checking the return value of
> verify_sb().  Example output:
> 
> found candidate secondary superblock...
> verifying sb at 31249334272: bad magic number (1)
> verifying sb at 62498668544: bad magic number (1)
> verifying sb at 93748002816: bad magic number (1)
> verifying sb at 124997337088: bad magic number (1)
> unable to verify superblock, continuing...
> 

This looks better :)  You may want to add even more info...

while it's just searching block by block, if it finds a candidate, I'd
print the sector offset for that candidate (your first output line).

And rather than "verifying sb at..." you might do something like
"comparing to sb N at offset X":

+	} else {
+		do_warn("comparing with sb %d at sector %Lu failed: %s (%d)\n",
+			agno, off, err_string(reason), reason);

because at this point it's using the geometry of the candidate sb to see
if it can be used to find enough other valid sb's....

-Eric


> Signed-off-by: KELEMEN Peter <Peter.Kelemen@cern.ch>
> 
> Index: xfsprogs/repair/sb.c
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfsprogs/repair/sb.c,v
> retrieving revision 1.22
> diff -u -u -r1.22 sb.c
> --- xfsprogs/repair/sb.c	8 Sep 2008 06:18:43 -0000	1.22
> +++ xfsprogs/repair/sb.c	22 Oct 2008 23:17:27 -0000
> @@ -683,6 +683,7 @@
>  	int		num_ok;
>  	int		retval;
>  	int		round;
> +	int		reason;	/* why the sb check failed */
>  
>  	/*
>  	 * select the number of secondaries to try for
> @@ -727,7 +728,7 @@
>  				goto out;
>  			}
>  
> -			if (verify_sb(sb, 0) == XR_OK)  {
> +			if ((reason = verify_sb(sb, 0)) == XR_OK)  {
>  				/*
>  				 * save away geometry info.
>  				 * don't bother checking the sb
> @@ -740,6 +741,9 @@
>  				get_sb_geometry(&geo, sb);
>  				list = add_geo(list, &geo, agno);
>  				num_ok++;
> +			} else {
> +				do_warn("verifying sb at %Lu: %s (%d)\n",
> +					off, err_string(reason), reason);
>  			}
>  		}
>  	}
> 
> 
