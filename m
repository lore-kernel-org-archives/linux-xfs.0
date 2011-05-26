Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4QIX3l6218551 for <xfs@oss.sgi.com>; Thu, 26 May 2011 13:33:04 -0500
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47BA7483B0A
	for <xfs@oss.sgi.com>; Thu, 26 May 2011 11:33:02 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id KoH2WAEJ08FrACPK for
	<xfs@oss.sgi.com>; Thu, 26 May 2011 11:33:02 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4QI8qBR015905
	for <xfs@oss.sgi.com>; Thu, 26 May 2011 14:08:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4QIX27H054330 for <xfs@oss.sgi.com>; Thu, 26 May 2011 14:33:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4QIX2Ba025391 for <xfs@oss.sgi.com>; Thu, 26 May 2011 15:33:02 -0300
Message-ID: <4DDE9CD9.3010300@linux.vnet.ibm.com>
Date: Thu, 26 May 2011 11:32:57 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
In-Reply-To: <4DDAC4EF.1050702@linux.vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

On 5/23/2011 1:34 PM, Allison Henderson wrote:
> Hi all,
>
> While trying to add more punch hole tests to xfstest, I found that test 252 hangs on ext4 due to a loop in xfsprogs that does not exit.  XFS gets out of this loop because there is logic in the loop that looks for the last extent flag and breaks out.  But it looks like ext4 does not return a last extent when the file has a hole at the end.  I am not sure if this is the correct behavior or not, so I will copy the ext4 folks on this too.  Below is a copy of the fix for xfsprogs:
>
> diff --git a/io/fiemap.c b/io/fiemap.c
> index fa990cc..81fc92c 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -246,7 +246,7 @@ fiemap_f(
>   		       flg_w, _("FLAGS"));
>   	}
>
> -	while (!last&&  ((cur_extent + 1) != max_extents)) {
> +	while (!last&&  (cur_extent<= max_extents)) {
>   		if (max_extents)
>   			num_extents = min(num_extents,
>   					  max_extents - (cur_extent + 1));
>
>
> It looks like the loop enters with last=0, cur_extents=0, and max_extents = 0, and on the first iteration cur_extents get set to 2, so we dont see ((cur_extent + 1) == max_extents for a very long time.  I doubt the logic was meant to work that way, so this patch should fix it, but I wanted to make sure that the fiemap for ext4 is working as intended too.  Feed back appreciated!  Thx all!
>
> Allison Henderson
>
Hi all,

I haven't heard much back on this patch, so Im just poking this thread 
to make sure it doesn't get forgotten. I have some patches out there for 
punch hole, and I'm currently looking at fixing up some older punch hole 
tests in the dmapi code, but they wont do much good for ext4 with out 
this fix.  If I could get a quick peek from some one on the xfs list for 
this patch, that would be much appreciated.  Thx all!

Allison Henderson
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
