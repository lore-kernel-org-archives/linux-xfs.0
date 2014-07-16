Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF9857FBC
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 12:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27954AC001
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 10:26:28 -0700 (PDT)
Received: from mail-qc0-f169.google.com (mail-qc0-f169.google.com
	[209.85.216.169]) by cuda.sgi.com with ESMTP id
	ssYBYm9RWjnjOpyQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 10:26:26 -0700 (PDT)
Received: by mail-qc0-f169.google.com with SMTP id m20so1078952qcx.28
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 10:26:25 -0700 (PDT)
Received: from mail-qa0-f50.google.com (mail-qa0-f50.google.com
	[209.85.216.50])
	by mx.google.com with ESMTPSA id o10sm32547450qah.3.2014.07.16.10.26.23
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Wed, 16 Jul 2014 10:26:23 -0700 (PDT)
Received: by mail-qa0-f50.google.com with SMTP id s7so949219qap.23
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 10:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140716092226.GA23561@infradead.org>
References: <alpine.DEB.2.00.1407151634250.21336@cobra.newdream.net>
	<20140716092226.GA23561@infradead.org>
Date: Wed, 16 Jul 2014 10:26:23 -0700
Message-ID: <CAPYLRziqpnjHbViaFw2MtXcYKiCDE9wz8qaqiQjAJGDoUbG7cg@mail.gmail.com>
Subject: Re: v0.80.4 Firefly released
From: Gregory Farnum <gregory.farnum@dreamhost.com>
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
To: Christoph Hellwig <hch@infradead.org>, Samuel Just <sam.just@inktank.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>, xfs@oss.sgi.com

On Wed, Jul 16, 2014 at 2:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jul 15, 2014 at 04:45:59PM -0700, Sage Weil wrote:
>> This Firefly point release fixes an potential data corruption problem
>> when ceph-osd daemons run on top of XFS and service Firefly librbd
>> clients.  A recently added allocation hint that RBD utilizes triggers
>> an XFS bug on some kernels (Linux 3.2, and likely others) that leads
>> to data corruption and deep-scrub errors (and inconsistent PGs).  This
>> release avoids the situation by disabling the allocation hint until we
>> can validate which kernels are affected and/or are known to be safe to
>> use the hint on.
>
> I've not really seen an report for that on the XFS list, could it be
> that you're running into the issue fixed by
>
>  "xfs: Use preallocation for inodes with extsz hints"
>
> (commit aff3a9edb7080f69f07fe76a8bd089b3dfa4cb5d)?

Sam reported the issue we're seeing in "consequences of
XFS_IOC_FSSETXATTR on non-empty file?", but didn't have it narrowed
down very far. I think he's trying to get a minimal reproducer and
identify as much as he can right now, but he's also trying to get out
the door for a vacation. :)

But yes, looking at the patch description that sounds about right.
-Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
