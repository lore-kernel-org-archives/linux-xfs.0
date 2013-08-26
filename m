Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC8887F52
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 00:38:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBB9A8F8033
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 22:38:33 -0700 (PDT)
Received: from e28smtp07.in.ibm.com (e28smtp07.in.ibm.com [122.248.162.7]) by
	cuda.sgi.com with ESMTP id FeYayhBsmkay0jzu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 22:38:31 -0700 (PDT)
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Mon, 26 Aug 2013 10:59:18 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 44559394004E
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 11:08:15 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7Q5e1gT37748806
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 11:10:01 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7Q5cO7I020394 for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 11:08:25 +0530
From: chandan <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Mon, 26 Aug 2013 11:08:24 +0530
Message-ID: <44437668.FEX1DiRokR@localhost.localdomain>
In-Reply-To: <521A36C6.40006@sandeen.net>
References: <2909046.09LYLQvZ6q@localhost.localdomain>
	<521A36C6.40006@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sekharan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sunday, August 25, 2013 11:54:30 AM Eric Sandeen wrote:
> Can you explain why this is necessary?
> 
> What failures do you see, on what filesystems?

generic/255 currently fails on Btrfs on a ppc64 machine with 64k page size and
hence 64k block size.

generic/255 has been written to test the corner cases for 4k block size. I did
try to make it work with variable sized block sizes, But I got stuck
working with md5sum (since we would need two sets of md5sums, due to
_test_generic_punch() being invoked with and without '-k' option per block
size). 

Since 4k block size support for Btrfs on ppc64 is already being worked on, I
think its better to prevent execution of generic/255 for block sizes greater
than 4k.

Apologies for not including the above description in the patch.

- chandan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
