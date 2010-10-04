Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94EKhPs070693 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 09:20:44 -0500
Subject: Re: xfs_metadump in never ending loop
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1286150266.4344.9.camel@doink>
References: <201010012136.47502.arekm@maven.pl> <1286150266.4344.9.camel@doink>
Date: Mon, 04 Oct 2010 09:21:11 -0500
Message-ID: <1286202071.2120.8.camel@doink>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Sun, 2010-10-03 at 18:57 -0500, Alex Elder wrote:
> On Fri, 2010-10-01 at 21:36 +0200, Arkadiusz Miskiewicz wrote:
> > generate_obfuscated_name() in metadump.c can go into
> > never ending loop for some file names. Reproducer below.
> 
> The reason it hangs is that the algorithm for computing
> a name with the same hash value as the name is stuck with
> a portion of the hash whose only possible result includes
> the string "/" in it.

I understand this problem, and have a solution.  But
before sending out the code I want to write up an
explanation of the problem, including the effect of
the hash and why the existing algorithm has problems.

Stay tuned.

					-Alex

> The hash for the file "R\323\257NE" is 0x3ab4b3740.
> 
> One step in the algorithm is this:
>         newname[namelen - 3] = (newhash >> 14) & 0x7f;
>         if (is_invalid_char(newname[namelen - 3]))
>                 continue;
> 
> But the result of that is 0x2f, which is the '/'
> character, which is illegal.  So this algorithm
> will try again indefinitely, never finding a file
> name with a matching hash.
> 
> I am looking into this a bit more.  Will report back
> later, probably tomorrow.
> 
> 					-Alex
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
