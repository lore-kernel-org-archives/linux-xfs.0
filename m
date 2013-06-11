Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4735A29DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 08:59:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C488FAC004
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:59:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kD2g7hw4MWP1CwkD for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:59:26 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5BDxQEj003575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:59:26 -0400
Received: from tunkums.home (ovpn-113-106.phx2.redhat.com [10.3.113.106])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r5BDxPq6000874
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:59:26 -0400
Message-ID: <51B72D3D.5010206@redhat.com>
Date: Tue, 11 Jun 2013 09:59:25 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
In-Reply-To: <loom.20130611T112155-970@post.gmane.org>
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

On 06/11/2013 05:56 AM, Steve Bergman wrote:
> 4. From the time I write() a bit of data, what's the maximum time before the
> data is actually committed to disk?
>
> 5. Ext4 provides some automatic fsync'ing to avoid the zero-length file
> issue for some common cases via the auto_da_alloc feature added in kernel
> 2.6.30. Does XFS have similar behavior?

I think that here you are talking more about ext3 than ext4.

The answer to both of these - even for ext4 or ext3 - is that unless your 
application and storage is all properly configured, you are effectively at risk 
indefinitely. Chris Mason did a study years ago where he was able to demonstrate 
that dirty data could get pinned in a disk cache effectively indefinitely.  Only 
an fsync() would push that out.

Applications need to use the data integrity hooks in order to have a reliable 
promise that application data is crash safe.  Jeff Moyer wrote up a really nice 
overview of this for lwn which you can find here:

http://lwn.net/Articles/457667

That said, if you have applications that do not do any of this, you can roll the 
dice and use a file system like ext3 that will periodically push data out of the 
page cache for you.

Note that without the barrier mount option, that is not sufficient to push data 
to platter, just moves it down the line to the next potentially volatile cache 
:)  Even then, 4 out of every 5 seconds, your application will be certain to 
lose data if the box crashes while it is writing data. Lots of applications 
don't actually use the file system much (or write much), so ext3's sync 
behaviour helped mask poorly written applications pretty effectively for quite a 
while.

There really is no short cut to doing the job right - your applications need to 
use the correct calls and we all need to configure the file and storage stack 
correctly.

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
