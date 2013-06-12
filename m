Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE47D7F96
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:34:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CABFB304064
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:34:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VNgGzmCuEYLJXpcS for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:34:28 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5CAYSwB003045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 06:34:28 -0400
Received: from tunkums.home (ovpn-113-49.phx2.redhat.com [10.3.113.49])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r5CAYRel028625
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 06:34:28 -0400
Message-ID: <51B84EB3.1070906@redhat.com>
Date: Wed, 12 Jun 2013 06:34:27 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<1371025611.7096.10.camel@acme>
In-Reply-To: <1371025611.7096.10.camel@acme>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 06/12/2013 04:26 AM, Roger Oberholtzer wrote:
> On Tue, 2013-06-11 at 11:12 -0500, Steve Bergman wrote:
>> Are you saying that with XFS there is no periodic
>> flushing mechanism at all? And that unless there's an
>> fsync/fdatasync/sync or the memory needs to be reclaimed, that it can
>> sit in the page cache forever?
> I read the later responses to this and they seemed to say that the data
> in the page cache should be written to the disk periodically. I am not
> meaning to hijack the thread. I just have a question directly related to
> this point.

You most likely need to adjust some of the vm tunings to cause the vm to kick 
out pages more evenly. Not sure what the opensuse crowd would suggest tweaking.

>
> I have an application that is streaming data to an XFS disk at a
> sustained 25 MB/sec. This is well below what the hardware supports. The
> application does fopen/fwrite/fclose (no active flushing or syncing).

Sounds like this is more likely to be an application issue than a file system 
one. Can you push the IO write speed up with a simple "dd" test to a file?

Ric
'
>
> I see that as my application writes data (the only process writing the
> only open file on the disk), the system cache grows and grows. Here is
> the unusual part: periodically, writes take some number of seconds to
> complete, rather than the typical <50 msecs). The increased time seems
> to correspond to the increasing size of the page cache.
>
> If I do:
>
> echo 1 > /proc/sys/vm/drop_caches
>
> while the application is runnung, then the writes do not occasionally
> take longer. Until the cache grows again, and I do the echo again.
>
> I am sure I must be misinterpreting what I see.
>
> (on openSUSE 12.1. kernel 3.1.0)
>
> --
> Roger Oberholtzer
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
