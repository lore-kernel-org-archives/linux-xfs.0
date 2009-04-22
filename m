Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3MJNBYv220175 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:23:11 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D7521CDD1BD
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:23:07 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Ztb6X0QThFTmNMmS for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2009 12:23:07 -0700 (PDT)
Message-ID: <49EF6E93.1050204@sandeen.net>
Date: Wed, 22 Apr 2009 14:22:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enforce lazy-count=0 in log tests 018, 081, 082
References: <49EE28EA.4010409@sandeen.net>
	<20090422191226.GB3709@josefsipek.net>
In-Reply-To: <20090422191226.GB3709@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Tue, Apr 21, 2009 at 03:13:30PM -0500, Eric Sandeen wrote:
>> I was experimenting w/ default lazy-count=1, and it broke a few tests.
>> Seems simplest to enforce lazy-count=0 in the common.log routines
>> for now, and fix up the output?  (vs. updating all the expected
>> output for these tests...)
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Hrm...are there any tests that explicitly check lazy-count=1?

not that I know of, but you can set it in MKFS_OPTIONS or something like
that, IIRC.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
