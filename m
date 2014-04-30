Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D735829DF8
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 07:02:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7610AAC010
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 05:02:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OHNFJpW3zbsOfhlv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Apr 2014 05:02:13 -0700 (PDT)
Date: Wed, 30 Apr 2014 05:02:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140430120213.GA19963@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397071311-28371-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Looks like I have lost the the argument on the ACLs.  Do you want to
resend a version of this rebased to the current tree, or should I do it?

We probably should get this into 3.15 so that our tmpfile doesn't behave
different from everyone else in the release where we introduce it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
