Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25330YN089307 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 21:03:00 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zigUI2GAr1pC936N for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 19:02:56 -0800 (PST)
Date: Mon, 5 Mar 2012 14:02:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Poor performance using discard
Message-ID: <20120305030254.GA3592@dastard>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
	<1330702910.6438.40.camel@core24>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330702910.6438.40.camel@core24>
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
To: Thomas Lynema <lyz27@yahoo.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 10:41:50AM -0500, Thomas Lynema wrote:
> Peter was right then.  Per multiple recommendations
> I'm switching to fstrim, it is quicker than the deletes.
> 
> fstrim consistently takes about a minute to run on a 40GB
> volume.
> 
> time fstrim -v /usr
> /usr: 9047117824 bytes were trimmed
> 
> real	0m56.121s
> user	0m0.090s
> sys	0m0.000s
> 
> I see that the running of fstrim was already discussed
> http://oss.sgi.com/archives/xfs/2011-05/msg00338.html.
> 
> Please add something to the FAQ about using SSDs.  It would be great if
> people could see the recommended mount options and fstrim crontab entry
> (or other option) for running xfs on a SSD.  

It's a publicly modifiable wiki. Feel free to add what you've
learned here to a new FAQ entry - others will come by and correct
anything in it that is inaccurate....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
