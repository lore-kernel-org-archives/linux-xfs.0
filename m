Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A4877F4E
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 17:40:19 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas3-dc21.corp.sgi.com [137.38.106.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CBE7AC04E
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 15:40:18 -0700 (PDT)
Message-ID: <526EE7CF.7090603@sgi.com>
Date: Mon, 28 Oct 2013 17:40:15 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: linux-3.12 userspace Take 2
References: <526A6FF9.8000506@sgi.com>
In-Reply-To: <526A6FF9.8000506@sgi.com>
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
To: xfs-oss <xfs@oss.sgi.com>

Hey Folks,

Sorry for any confusion, let me try again.

In preparation for the new userspace release, are there any outstanding
userspace patches that should be marked as critical and hold up the new
userspace release?


Code shared by userspace and kernelspace are committed by different
maintainers, I propose we discuss how to make it clear which patch
series are tied together. This would aid reviewers and testers also.

	One thought is to state in the kernel [PATCH 0/XX] email body
	something like:
		This kernel series shares the same headers as the
		userspace series "NAME OF USERSPACE SERIES"

	and a similar email for the userspace series.

	The second commit should contain the first series commit id to
	tie them together.

Userspace patch series will be committed when the entire patch series 
has been reviewed.  Partial series commits will happen only with the 
authors approval (confirmation posted to the list).

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
