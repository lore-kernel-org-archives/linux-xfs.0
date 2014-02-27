Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21F1029DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 21:59:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01A2B304059
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:59:53 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id PTTGsnwuZlPNbYXE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:59:52 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id e89so4156427qgf.5
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:59:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Date: Thu, 27 Feb 2014 12:59:51 +0900
Message-ID: <CAKYAXd-ngheH2njza1Tq0umONrF+VBrmB+9SiVG1Q=DsM0PBBA@mail.gmail.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
	FALLOC_FL_COLLAPSE_RANGE
From: Namjae Jeon <linkinjeon@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dongsu Park <dongsu.park@profitbricks.com>, Karel Zak <kzak@redhat.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

Hi Dongsu.
> As discussed in the thread "[PATCH RESEND 3/10] ext4: Add support
> FALLOC_FL_COLLAPSE_RANGE for fallocate", [3] this patch to util-linux
> will be useful for testing collapse-range inside xfstests.
As Dave pointed, this patch is needed for fsstress not xfstests.
>
> [1] https://lkml.org/lkml/2014/2/18/374
> [2] https://lkml.org/lkml/2014/2/20/318
> [3] https://lkml.org/lkml/2014/2/18/83
>
> @@ -51,6 +52,10 @@
>  # define FALLOC_FL_PUNCH_HOLE 2
>  #endif
>
> +#ifndef FALLOC_FL_COLLAPSE_RANGE
> +# define FALLOC_FL_COLLAPSE_RANGE 8
> +#endif
> +
>  #include "nls.h"
>  #include "strutils.h"
>  #include "c.h"
> @@ -66,12 +71,13 @@ static void __attribute__((__noreturn__)) usage(FILE
> *out)
>  	fprintf(out,
>  	      _(" %s [options] <filename>\n"), program_invocation_short_name);
>  	fputs(USAGE_OPTIONS, out);
> -	fputs(_(" -d, --dig-holes     detect and dig holes\n"), out);
> -	fputs(_(" -l, --length <num>  length of the (de)allocation, in bytes\n"),
> out);
> -	fputs(_(" -n, --keep-size     don't modify the length of the file\n"),
> out);
> -	fputs(_(" -o, --offset <num>  offset of the (de)allocation, in bytes\n"),
> out);
> -	fputs(_(" -p, --punch-hole    punch holes in the file\n"), out);
> -	fputs(_(" -v, --verbose       verbose mode\n"), out);
> +	fputs(_(" -c, --collapse-range collapse a hole in the file\n"), out);
I think that it is better to change like this => "collapse space in the file"
And I add util-liunx's maintainer in this mail loop.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
