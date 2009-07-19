Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6JMPVZ1257821
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 17:25:31 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46A1C370A70
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 15:26:13 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id vyDBVvPh1Rg2t172 for
	<linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 15:26:13 -0700 (PDT)
Message-ID: <4A639D83.4010501@sandeen.net>
Date: Sun, 19 Jul 2009 17:26:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: nslookup not found
References: <alpine.DEB.2.01.0907191050010.6439@bogon>
	<20090719182012.GA10936@infradead.org>
In-Reply-To: <20090719182012.GA10936@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sun, Jul 19, 2009 at 10:57:35AM -0700, Christian Kujau wrote:
>> Hi,
>>
>> while trying to run ./check in a current xfstests tree, execution stopped 
>> because "nslookup" was not available. I could've just installed this tool 
>> but I wondered why xfstests, a filesystem testing tool, would need 
>> nslookup at all. Turns out that it's being used in a routine called 
>> "_get_fqdn", which in turn is only called once in ./new, to set a variable 
>> called "owner" and I ask myself: do I really want my FQDN listed in the 
>> testresults, that maybe even get published for analysis? I changed this 
>> whole _get_fqdn thingy to just "uname -n", but I'm eager to know why the 
>> FQDN is crucial here :-)
> 
> It uses it as email address for the test owner.  In these days this
> probably requires hand-editing anyway, but the fqdn is certainly
> a better approximation than uname -n.
> 
> Can you resend a patch that just moves _get_fqdn and the check for
> nslookup from common* into the "new" script?

That'd be great - sounds like the right solution to me; I've run into
this too but never bothered to fix it.  :)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
