Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASFa5Wr239918 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 09:36:09 -0600
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BA78572103
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 07:36:01 -0800 (PST)
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id RAo2mlk5nlD4pDoS for
	<xfs@oss.sgi.com>; Mon, 28 Nov 2011 07:36:01 -0800 (PST)
Message-ID: <4ED3AA90.8090202@scalableinformatics.com>
Date: Mon, 28 Nov 2011 10:36:48 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: XFS on CoRAID errors with SMB
References: <20111128135518.GA1232@campbell-lange.net>
	<4ED39EBE.2070206@scalableinformatics.com>
	<20111128152652.GD1795@campbell-lange.net>
In-Reply-To: <20111128152652.GD1795@campbell-lange.net>
Reply-To: landman@scalableinformatics.com
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
To: Jon Marshall <jon@campbell-lange.net>
Cc: xfs@oss.sgi.com

On 11/28/2011 10:26 AM, Jon Marshall wrote:
> Hi Joe,
>
> Thanks for the rapid response.
>
> Is this something that has been reported often in relation to AoE? Is

We've experienced it in the past when we supported our customers with 
Coraid gear.  Most of that is gone now, so we haven't seen much AoE 
stuff as of late (last 2 years or so).

This said, the AoE stack depends critically upon the network stack, and 
between AoE and the network stack (or possibly something else), you ran 
out of memory for use in the kernel.  Our experience with this is 
usually a leaky network driver.  e1000 and similar Intel drivers shipped 
with default RHEL5/Centos5 are highly problematic.  AoE could be leaking 
itself (early versions were pretty bad in this regard, though I haven't 
looked at the driver in the last few years, they hopefully have improved 
it).

The xfs connection to this (to stay relevant to this group) is that xfs 
is ok atop this, as long as the other layers don't go away.  If you can 
detect problems like this in advance, you might be able to issue an 
xfs_freeze, and preserve the integrity of the underlying filesystem 
(obviating the need for an xfs_repair).  The hard part would be an 
accurate prediction, but if your drivers are grabbing memory and not 
releasing it back, or you have a run-away memory consuming process, 
yeah, you could potentially predict this onset.

> there any chance you could point us in the direction of some more
> background on the issue? I am checking the AoE mailing list, but if you know
> of something specific that would be very helpful.

Not really, we aren't doing much with AoE anymore.  This may or may not 
be an AoE issue per se.  Likely AoE crashed, and the reason for the 
crash is very probably the same reason that xfs crashed, it ran out of 
memory.  If AoE is the culprit, you might find some sort of imprint of 
this in the logs, though our experience has been usually a run-away 
network driver.  Since AoE does its block devices over raw ethernet 
packets, it doesn't take very long for a leaky driver to crash such a 
system under load.

>
> I am also looking into the ethernet drivers we have in place on the
> system in question.
>
> Again, thanks for the quick and informative response.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
