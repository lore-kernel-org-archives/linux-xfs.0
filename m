Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S8npH0204274 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 03:49:51 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E657434845
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 01:49:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ps1rEntcngwpr416 for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 01:49:50 -0700 (PDT)
Date: Tue, 28 Jun 2011 18:49:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3 v2] XFS TESTS: Fix 252 Failure: Relax fiemap filter
Message-ID: <20110628084947.GN32466@dastard>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com>
	<20110628045903.GK32466@dastard>
	<4E0963D8.5030002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E0963D8.5030002@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 27, 2011 at 10:17:12PM -0700, Allison Henderson wrote:
> On 06/27/2011 09:59 PM, Dave Chinner wrote:
> >On Mon, Jun 27, 2011 at 09:27:25PM -0700, Allison Henderson wrote:
> >I seriously dislike conditional parameter passing in shell scripts
> >at the best of times, but for filter functions I really think it is
> >the wrong thing to do. It significantly obfuscates the working of
> >the function for no really good reason.
> >
> >Just write a new filter function, and factor out the common parts of
> >them if the amount of code duplication is sufficient to make it
> >desirable to do so.
> >
> 
> Ok, it doesn't look like a lot of code, I can separate them into their
> own functions.
> 
> >>+	md5sum $testfile | cut -d ' ' -f1
> >
> >Why cut out the file name? It's not like it changes at all....
> >
> 
> Oh, it looked like there's a pid attached to the file name, so I
> thought I should remove that from the output

Oh, it does too. My mistake, too trigger happy, just looking for
ways to keep things relatively simple. Maybe using a wrapper
function so if we ever need to modify it we only need to change one
line of code would acheive the same thing?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
