Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EFDB7F8A
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 08:52:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47316304032
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:52:09 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id O33POTfHkTMBv0rV
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:52:08 -0800 (PST)
Message-ID: <52E7C403.5020700@fb.com>
Date: Tue, 28 Jan 2014 09:51:47 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make test btrfs/025 more robust
References: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org


On 01/28/2014 09:46 AM, Filipe David Borba Manana wrote:
> Make the test btrfs/025 not depend on the output of the btrfs tools
> subvolume, send, receive and filesystem commands output. The output
> of these commands has changed several times in the past, and it can
> change again in the future. Therefore just test for failure/success
> and not for the exact output on the success case.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Wow sorry didn't realize this already got taken, but still a good change 
to have anyway.

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
