Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 30F137F52
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:12:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 032EA304043
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:12:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 0WhQ7Wu3kE16IrbN
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:12:35 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C56636C15E
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:12:34 -0500 (CDT)
Message-ID: <51B865B2.5030208@hardwarefreak.com>
Date: Wed, 12 Jun 2013 07:12:34 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<1371025611.7096.10.camel@acme>
In-Reply-To: <1371025611.7096.10.camel@acme>
Reply-To: stan@hardwarefreak.com
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

On 6/12/2013 3:26 AM, Roger Oberholtzer wrote:
...
> I have an application that is streaming data to an XFS disk at a
> sustained 25 MB/sec. This is well below what the hardware supports. The
> application does fopen/fwrite/fclose (no active flushing or syncing).

Buffered IO.

> I see that as my application writes data (the only process writing the
> only open file on the disk), the system cache grows and grows. Here is
> the unusual part: periodically, writes take some number of seconds to
> complete, rather than the typical <50 msecs). The increased time seems
> to correspond to the increasing size of the page cache.

Standard Linux buffered IO behavior.  Note this is not XFS specific.

> If I do:
> 
> echo 1 > /proc/sys/vm/drop_caches

Dumps the page cache forcing your buffered writes to disk.

> while the application is runnung, then the writes do not occasionally
> take longer. Until the cache grows again, and I do the echo again.

Which seems a bit laborious.

> I am sure I must be misinterpreting what I see.

Nope.  The Linux virtual memory system has behaved this way for quite
some time.  You can teak how long IOs stay in cache.  See dirty_* at
https://www.kernel.org/doc/Documentation/sysctl/vm.txt

Given the streaming nature you describe, have you looked at possibly
using O_DIRECT?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
