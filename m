Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S5HH5q181964 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:17:17 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A66E5176D598
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:17:16 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id HIyzPtbZzuktwAdc for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:17:16 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S4qc9Y016016
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:52:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S5HF0d1687798
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 01:17:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5S5HEag000778 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 02:17:15 -0300
Message-ID: <4E0963D8.5030002@linux.vnet.ibm.com>
Date: Mon, 27 Jun 2011 22:17:12 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3 v2] XFS TESTS: Fix 252 Failure: Relax fiemap filter
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com>
	<20110628045903.GK32466@dastard>
In-Reply-To: <20110628045903.GK32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 06/27/2011 09:59 PM, Dave Chinner wrote:
> On Mon, Jun 27, 2011 at 09:27:25PM -0700, Allison Henderson wrote:
> I seriously dislike conditional parameter passing in shell scripts
> at the best of times, but for filter functions I really think it is
> the wrong thing to do. It significantly obfuscates the working of
> the function for no really good reason.
>
> Just write a new filter function, and factor out the common parts of
> them if the amount of code duplication is sufficient to make it
> desirable to do so.
>

Ok, it doesn't look like a lot of code, I can separate them into their
own functions.

>> +	md5sum $testfile | cut -d ' ' -f1
>
> Why cut out the file name? It's not like it changes at all....
>

Oh, it looked like there's a pid attached to the file name, so I thought 
I should remove that from the output

Allison Henderson


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
