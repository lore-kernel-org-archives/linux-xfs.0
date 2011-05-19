Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JNbQtX059221 for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:37:26 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C09BA1618709
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 16:37:25 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id F2jt3SEGeJvWxiH3 for
	<xfs@oss.sgi.com>; Thu, 19 May 2011 16:37:25 -0700 (PDT)
Message-ID: <4DD5A982.9090907@oracle.com>
Date: Thu, 19 May 2011 16:36:34 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test Routines
References: <4DD43300.6010908@linux.vnet.ibm.com>
	<20110519013144.GF32466@dastard>
	<4DD560CF.3040706@linux.vnet.ibm.com>
In-Reply-To: <4DD560CF.3040706@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Mark Fasheh <mfasheh@suse.com>, xfs-oss <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>

On 05/19/2011 11:26 AM, Allison Henderson wrote:
> Thx for the all the reviewing on this one.  Im not quite sure I agree that the tests are analogous though.  I did some poking around in xfsprogs which I believe is what test 252 is using to do perform most of its operations.  I found the code where the hole gets punched, but I didnt find any code that does any kind of analyzing to verify that the hole was punched correctly.  Maybe I over looked it?  It kinda looks like the hole gets punched and it just checks the return code (fpunch_f in io/prealloc.c right?).
>

Mark Fasheh wrote a test for the same for ocfs2 that might help. Check it out.

http://oss.oracle.com/git/?p=ocfs2-test.git;a=tree;f=programs/fill_verify_holes;h=0df38895e7ff6e66a9a558f35407699ebb40f790;hb=HEAD

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
