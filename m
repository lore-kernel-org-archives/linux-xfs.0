Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7CCA7CBF
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C95FE8F8049
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 01:26:58 -0700 (PDT)
Received: from stockholm.opq.se ([213.88.151.150]) by cuda.sgi.com with ESMTP
	id zkpuQRw1R3pEiY3A (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 01:26:56 -0700 (PDT)
Received: from [10.2.10.35] (shark.pacific [10.2.10.35])
	by stockholm.opq.se (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id
	r5C8Qpu6027988 for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 10:26:53 +0200
Message-ID: <1371025611.7096.10.camel@acme>
Subject: Re: Questions about XFS
From: Roger Oberholtzer <roger@opq.se>
Date: Wed, 12 Jun 2013 10:26:51 +0200
In-Reply-To: <CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
Mime-Version: 1.0
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

On Tue, 2013-06-11 at 11:12 -0500, Steve Bergman wrote: 
> Are you saying that with XFS there is no periodic
> flushing mechanism at all? And that unless there's an
> fsync/fdatasync/sync or the memory needs to be reclaimed, that it can
> sit in the page cache forever?

I read the later responses to this and they seemed to say that the data
in the page cache should be written to the disk periodically. I am not
meaning to hijack the thread. I just have a question directly related to
this point.

I have an application that is streaming data to an XFS disk at a
sustained 25 MB/sec. This is well below what the hardware supports. The
application does fopen/fwrite/fclose (no active flushing or syncing).

I see that as my application writes data (the only process writing the
only open file on the disk), the system cache grows and grows. Here is
the unusual part: periodically, writes take some number of seconds to
complete, rather than the typical <50 msecs). The increased time seems
to correspond to the increasing size of the page cache.

If I do:

echo 1 > /proc/sys/vm/drop_caches

while the application is runnung, then the writes do not occasionally
take longer. Until the cache grows again, and I do the echo again.

I am sure I must be misinterpreting what I see.

(on openSUSE 12.1. kernel 3.1.0)

--
Roger Oberholtzer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
