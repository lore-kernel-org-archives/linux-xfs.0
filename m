Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11AC77F60
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 19:02:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94596AC002
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 17:02:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0dj92PDfBD7uU3De for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 17:02:53 -0800 (PST)
Date: Thu, 5 Feb 2015 12:02:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Using XFS on Raid
Message-ID: <20150205010221.GQ4251@dastard>
References: <BLU436-SMTP15464F1CAAC1F46E2593ED0FB3B0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP15464F1CAAC1F46E2593ED0FB3B0@phx.gbl>
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
To: James Woolliscroft <j_woolliscroft@hotmail.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 12:23:53AM +0000, James Woolliscroft wrote:
> Hi,
> 
>  
> 
> I am new to XFS, I have spent a significant time searching for information
> and have not found any documentation relating to the use of XFS over RAID
> with N Drives where the Stripe Unit >256K.

Use the defaults - they do the right thing.

> It appears that XFS on RHEL7 and clones is limited to a maximum Stripe Unit
> of 256KB.

That's not correct. mkfs.xfs prior to v3.2.2 (i.e the latest) throw
a warning about the default log stripe unit not being able to be set
larger than 256k, but it then sets the lsu to a default of 32k and
continues.

The current version (which I think will hit RHEL7.1) omits
the warning and just sets the lsu to 32k - defaults should just do
the right thing and not bother users who are using defaults.

Either version, however, will still result in the data stripe
unit/width is still going to be 1m/2m in your case.

> I also would like to find some information on how to correctly interpret the
> statistics output when formatting a volume with XFS, particularly as the
> process may use other settings which may require further investigation?

They are a reflection of the command line parameters, or if not
specified, the default CLI values. So, read the mkfs.xfs man page as
it explains what everything means.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
