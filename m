Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09C837F52
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 08:18:00 -0500 (CDT)
Message-ID: <519239A2.8070605@sgi.com>
Date: Tue, 14 May 2013 08:18:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Make test 306 use null and zero device nodes on
	SCRATCH_MNT
References: <1367964573-29620-1-git-send-email-jack@suse.cz>
	<1367964573-29620-2-git-send-email-jack@suse.cz>
In-Reply-To: <1367964573-29620-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

This patch has been committed:

commit 2941898570ccdb32ab5af89c0b25147231489973
Author: Jan Kara <jack@suse.cz>
Date:   Tue May 14 07:02:50 2013 -0500

     Make test 306 use null and zero device nodes on SCRATCH_MNT

Thanks
--Rich

On 05/07/2013 05:09 PM, Jan Kara wrote:
> In one place of test 306, we mistakenly used /dev/null and /dev/zero
> instead of equivalent devices created on tested filesystem. So we were
> not really testing the functionality we intended.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
