Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UF4cqf008961 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:04:39 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F8CCAC015
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 08:05:14 -0700 (PDT)
Subject: Re: [PATCH] xfstests: update README file to document some recent
	changes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1280771460.2236.68.camel@doink>
References: <1280771460.2236.68.camel@doink>
Date: Mon, 30 Aug 2010 10:05:12 -0500
Message-ID: <1283180712.5273.98.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

On Mon, 2010-08-02 at 12:51 -0500, Alex Elder wrote:
> Update the README file to document the new _cat_passwd and
> _cat_group functions, and to recommend passing "-n" to
> getfacl(1) so it produces numeric output.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Ping?  Trivial change (to README).

> ---
>  README |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: b/README
> ===================================================================
> --- a/README
> +++ b/README
> @@ -160,6 +160,20 @@ Test script environment:
>  				  string DATE for deterministic
>  				  output
>  
> +	_cat_passwd,		- dump the content of the password
> +	_cat_group		  or group file (both the local file
> +				  and the content of the NIS database
> +				  if it is likely to be present)
> +
> +     4. General recommendations, usage conventions, etc.:
> +	- When the content of the password or group file is
> +	  required, get it using the _cat_passwd and _cat_group
> +	  functions, to ensure NIS information is included if NIS
> +	  is active.
> +	- When calling getfacl in a test, pass the "-n" argument so
> +	  that numeric rather than symbolic identifiers are used in
> +	  the output.
> +
>  Verified output:
>  
>      Each test script has a numerical name, e.g. 007, and an associated
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
