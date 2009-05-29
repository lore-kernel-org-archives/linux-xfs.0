Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TEu8Ir062561 for <xfs@oss.sgi.com>; Fri, 29 May 2009 09:56:08 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 037BB1D379EC
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 07:56:22 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Hlo9GIe2FHDqep8z for <xfs@oss.sgi.com>;
	Fri, 29 May 2009 07:56:22 -0700 (PDT)
Message-ID: <4A1FF78C.7050406@sandeen.net>
Date: Fri, 29 May 2009 09:56:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests 206: test for overflow in growfs
	size	calculation
References: <4A1EF50D.8090900@redhat.com> <4A1EFE55.4020505@sandeen.net>
	<20090529145025.GA9205@infradead.org>
In-Reply-To: <20090529145025.GA9205@infradead.org>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, May 28, 2009 at 04:12:53PM -0500, Eric Sandeen wrote:
>> Test trim of last small AG for large filesystem resizes
>>
>> As reported at
>> http://article.gmane.org/gmane.comp.file-systems.xfs.general/29187
>> this trimming may cause an overflow in the new size calculation.
>>
>> Patch to fix it, and testcase at
>> http://article.gmane.org/gmane.comp.file-systems.xfs.general/29193
>>
>> V2: now with proper expected (resized) output!
> 
> This fails for me in really weird ways (Debian -testing, i386):
> 
> 
> --- 206.out	2009-05-29 14:44:54.000000000 +0000
> +++ 206.out.bad	2009-05-29 14:46:01.000000000 +0000
> @@ -1,30 +1,18 @@
>  QA output created by 206
>  === xfs_io ===
> +ftruncate: File too large

hm, 32-bit.  crud.  Should probably just restrict the test to 64-bit
systems, since we need a file > 16T.

What's weirder is that xfs_io shoulda caused an error and caused the
test to bail, I think.

As for the rest of it, I need better error handling I guess :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
