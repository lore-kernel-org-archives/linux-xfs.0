Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9401dUE018285 for <xfs@oss.sgi.com>; Sun, 3 Oct 2010 19:01:39 -0500
Subject: Re: xfs_metadump in never ending loop
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201010012136.47502.arekm@maven.pl>
References: <201010012136.47502.arekm@maven.pl>
Date: Sun, 03 Oct 2010 18:57:46 -0500
Message-ID: <1286150266.4344.9.camel@doink>
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

On Fri, 2010-10-01 at 21:36 +0200, Arkadiusz Miskiewicz wrote:
> generate_obfuscated_name() in metadump.c can go into
> never ending loop for some file names. Reproducer below.

The reason it hangs is that the algorithm for computing
a name with the same hash value as the name is stuck with
a portion of the hash whose only possible result includes
the string "/" in it.

The hash for the file "R\323\257NE" is 0x3ab4b3740.

One step in the algorithm is this:
        newname[namelen - 3] = (newhash >> 14) & 0x7f;
        if (is_invalid_char(newname[namelen - 3]))
                continue;

But the result of that is 0x2f, which is the '/'
character, which is illegal.  So this algorithm
will try again indefinitely, never finding a file
name with a matching hash.

I am looking into this a bit more.  Will report back
later, probably tomorrow.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
