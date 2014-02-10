Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 625E97F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:33:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37F70304048
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:32:58 -0800 (PST)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id 7K8KCALa1lzbOSVq
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:32:56 -0800 (PST)
Message-ID: <52F94582.6040703@fb.com>
Date: Mon, 10 Feb 2014 16:32:50 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add test for btrfs data corruption when using
	compression
References: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
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
Cc: clm@fb.com, linux-btrfs@vger.kernel.org



On 02/08/2014 10:50 AM, Filipe David Borba Manana wrote:
> Test for a btrfs data corruption when using compressed files/extents.
> Under certain cases, it was possible for reads to return random data
> (content from a previously used page) instead of zeroes. This also
> caused partial updates to those regions that were supposed to be filled
> with zeroes to save random (and invalid) data into the file extents.
>
> This is fixed by the commit for the linux kernel titled:
>
>     Btrfs: fix data corruption when reading/updating compressed extents
>     (https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3610391/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=JRaF%2BUY%2F2k%2BBfF9nTx3Iwl5JZWNCwew%2BI%2Fw%2B%2BfuDrgc%3D%0A&s=4a033ea8f3cf1f28794e90fcf16ea553766bb1ea83e10fc904182a8f56435eef)
>

Ran with and without the corresponding fix and all worked as expected. 
You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
