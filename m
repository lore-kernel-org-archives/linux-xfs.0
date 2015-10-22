Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 449907F37
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 13:27:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA141AC004
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 11:27:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QRlSLRBVPSKZrWko for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2015 11:27:05 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 81A7B602D370
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 13:27:03 -0500 (CDT)
Subject: Re: hdd + ssd
References: <20151022202324.5f00807f@linux>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56292A76.8090600@sandeen.net>
Date: Thu, 22 Oct 2015 13:27:02 -0500
MIME-Version: 1.0
In-Reply-To: <20151022202324.5f00807f@linux>
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
To: xfs@oss.sgi.com

On 10/22/15 1:23 PM, krautus@kr916.org wrote:
> Hello I'm trying to understand why and how to add one or more SSD (as a cache drive / keeping xfs log)
> to a traditional spinning xfs storage volume.
> I mean: which data will go to the ssd ? Inodes and dentries will go to the ssd ?
> Will the _read_ performance increase ?

You might want to look into something like dm-cache
https://en.wikipedia.org/wiki/Dm-cache

(TBH, I've not used it before, so grains of salt apply for your usecase).

Putting the log on an ssd is not likely to be the solution you want;
it certainly won't speed up reads.

-Eric

> In general I'm looking to increase (cache) the reading performance of folders with a lot of small files (emails),
> for email servers.
> 
> Feel free to let me rtfm :)
> I'd gladly study the documentation / articles / benchmarks but my google-fu isn't in best shape.
> 
> Thank you,
> Mike
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
