Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4773F7F84
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 07:56:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EDEDAAC011
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 05:56:39 -0800 (PST)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id rqUmB6KZt1c6UfhF
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 05:56:35 -0800 (PST)
Message-ID: <52E7B707.4070707@fb.com>
Date: Tue, 28 Jan 2014 08:56:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add test for btrfs incremental send data
	corruption
References: <1390873242-8723-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390873242-8723-1-git-send-email-fdmanana@gmail.com>
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


On 01/27/2014 08:40 PM, Filipe David Borba Manana wrote:
> Btrfs incremental send had an issue where it would detect a non-existent
> file hole and then overwrite the file section that hole covers with zeroes,
> overriding file data that it shouldn't.
>
> The respective btrfs kernel patch that fixed this issue is titled:
>
>     Btrfs: fix send file hole detection leading to data corruption
>     (https://patchwork.kernel.org/patch/3544831/)
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
Thanks for this

Reviewed-by: Josef Bacik <jbacik@fb.com>

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
