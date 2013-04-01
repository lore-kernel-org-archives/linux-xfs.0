Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03B7C29E14
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 08:21:53 -0500 (CDT)
Message-ID: <515989FD.30607@sgi.com>
Date: Mon, 1 Apr 2013 08:22:05 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: set correct seqres variable in new when creating
	test template
References: <1364813895-10883-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1364813895-10883-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

Eryu,

Thanks for submitting this patch, it has been committed.

--Rich

commit d1ec02af9e0516652ce92584dc4f92704579af18
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:58:15 2013 +0000

     xfstests: set correct seqres variable in new when creating test 
template

     When setting seqres in the new script, '$' should be escaped,
     otherwise seqres will be set to '/' not '$RESULT_DIR/$seq'

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
